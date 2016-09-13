function RawImagesMat = ImageGeneratorHist5(PhotonArray, SizeX, SizeY, SizeZ, StartOfFrameVec, NumOfLines, TotalEvents, MaxDiffOfLines, MaxDiffOfLines2)

% Changing SizeX to SizeX-1 if using histcounts2 instead of hist3
% RawImagesMat = zeros(SizeX-1, SizeY-1, max(size(StartOfFrameVec, 1) - 1, 1),'uint16'); % Last half-recorded frame won't be imaged
% RawImagesMat = zeros(SizeX, SizeY, max(size(StartOfFrameVec, 1) - 1, 1),'uint16'); % Last half-recorded frame won't be imaged

CurrentFrameNum = 1;

%% Create histograms
if (isempty(StartOfFrameVec) && (NumOfLines == 0)) % A single frame that has no line data
    CurrentEvents = PhotonArray;
    MaxPhotonTime = CurrentEvents(end,1);
    TimeForYLine = ceil(MaxPhotonTime / SizeY);
    m = 1;
    for n = 1:SizeY
       while ((CurrentEvents(m,1) <= TimeForYLine * n) && (m < TotalEvents))
          CurrentEvents(m,2) = TimeForYLine * (n - 1);
          m = m + 1;
       end
    end
    
    %% Substract line start times from photon arrival times
    CurrentEvents(:,1) = CurrentEvents(:,1) - CurrentEvents(:,2);
    
    % Create edge vectors
    EdgeY = (unique(CurrentEvents(:,2)))';
    EdgeY = EdgeY(1,2:end); % Otherwise it takes 0 as its first value
%     EdgeX = linspace(0, TimeForYLine, SizeX);
   
    %% Run hist3
    RawImagesMat(:,:,CurrentFrameNum) = PhotonSpreadToImage2(CurrentEvents, SizeX, SizeY, EdgeX, EdgeY);
    imagesc(RawImagesMat(:,:,CurrentFrameNum))
else
    for CurrentFrameNum = 1:max(1, size(StartOfFrameVec, 1) - 1) % If a frame isn't complete an image won't be generated from it

        %% Take relevant data
        if ~isempty(StartOfFrameVec)
            CurrentEvents = PhotonArray((PhotonArray(:,2) >= StartOfFrameVec(CurrentFrameNum, 1) & (PhotonArray(:,2) < StartOfFrameVec(CurrentFrameNum + 1, 1))),:); % Only photons that came in the specific time interval of the CurrentFrameNum's frame
        else
            CurrentEvents = PhotonArray;
        end
        
        %% Check if we have TAG phase data and calculate edge vector of image (for hist3 function)
 
        % X is responsible for TAG\line data
        if MaxDiffOfLines ~= 0
            EdgeX = linspace(0, MaxDiffOfLines,     SizeX);
            EdgeZ = linspace(0, MaxDiffOfLines2,    SizeZ); 
        elseif isempty(MaxDiffOfLines)
            continue;
        else
%             EdgeX = linspace(0, CurrentEvents(1,2), SizeX);
        end  

        %% Modified by LG 08.09.2016
%         if size(PhotonArray, 2) < 3
        if size(PhotonArray, 2) < 5
        %% end of modification 08.09.2016   
            TAGPhaseUse = 0;
            EdgeY = linspace(CurrentEvents(1,2), CurrentEvents(end,2), SizeY);
        else
            % Modified by LG 27 July 2016 
%             CurrentEvents(:, 3) = abs(sin(CurrentEvents(:, 3)));
%             OffsetPhase = 0.5 .* pi;
            OffsetPhase = 0; % if necessary, add OffsetPhase as an input parameter
            CurrentEvents(:, 3) = 0.5 .* (1 + sin(CurrentEvents(:, 3) + OffsetPhase));
            
            
            TAGPhaseUse = 1;
            finiteEvents = CurrentEvents(isfinite(CurrentEvents(:,3)), :);
            CurrentEvents = finiteEvents; % We throw out all photons without TAG phase
            sumOfEvents = CurrentEvents(:,1) + CurrentEvents(:,2);
            CurrentEvents(:,1) = sumOfEvents; 
           
%             %% 
%             % Modified by LG 27 July 2016 
%             EdgeY = linspace(0, 1, SizeY);
%             EdgeX = linspace(min(CurrentEvents(:,1)), max(CurrentEvents(:,1)), SizeX);
%             %%
%             RawImagesMat(:,:,CurrentFrameNum) = PhotonSpreadToImage2(CurrentEvents(:,[1 3]), EdgeX, EdgeY);
% %             RawImagesMat(:,:,CurrentFrameNum) = PhotonSpreadToImage2(CurrentEvents(:,[1 3]), EdgeX, EdgeY);
        end

        %% Run hist3
        if ~TAGPhaseUse
            RawImagesMat{CurrentFrameNum} = uint16( PhotonSpreadToImage3(CurrentEvents(:,1:3), EdgeX, EdgeY, EdgeZ) );
%             RawImagesMat(:,:,CurrentFrameNum) = PhotonSpreadToImage2(CurrentEvents(:,1:2), EdgeX, EdgeY);
        end
        
        %% Flip the frames of image - only relevant for MPScope
%         if mod(CurrentFrameNum, 2) == 0
%             RawImagesMat(:,:,CurrentFrameNum) = flipud(RawImagesMat(:,:,CurrentFrameNum));
%          
%         end
        
        %% Show image
%         figure(CurrentFrameNum)
        figure('windowStyle','docked')
%         imagesc(RawImagesMat(:,:,CurrentFrameNum)')
        FilteredData = smooth3(RawImagesMat{CurrentFrameNum},'gaussian',3);
        for k = 1:SizeZ;
            imagesc(squeeze(FilteredData(:,:,k)'));
            title(strcat(['Plane ', num2str(k), ' out of ', num2str(SizeZ), ' planes']))
            pause(0.05);

            axis image
        end
        
%         imagesc(log(double(RawImagesMat(:,:,CurrentFrameNum)+1)))
        axis image;
    end
end

end
