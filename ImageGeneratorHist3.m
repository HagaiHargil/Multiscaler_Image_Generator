function RawImagesMat = ImageGeneratorHist3(PhotonArray, SizeX, SizeY, StartOfFrameVec, NumOfLines, TotalEvents)

RawImagesMat = zeros(SizeX, SizeY, size(StartOfFrameVec, 1) - 1,'uint16'); % Last half-recorded frame won't be imaged
CurrentFrameNum = 1;
%% Create histograms
if (isempty(StartOfFrameVec) && (NumOfLines == 0))
    CurrentEvents = PhotonArray;
    MaxPhotonTime = CurrentEvents(end,1);
    TimeForYLine = ceil(MaxPhotonTime / SizeY);
    TimeForXLine = ceil(TimeForYLine / SizeX);
    m = 1;
    for n = 1:SizeY
       while ((CurrentEvents(m,1) <= TimeForYLine * n) && (m < TotalEvents))
          CurrentEvents(m,2) = TimeForYLine * (n - 1);
          m = m + 1;
       end
    end
    
    %% Substract line start times from photon arrival times
    CurrentEvents(:,1) = CurrentEvents(:,1) - CurrentEvents(:,2);
    
    %% Create edge vectors
    EdgeY = (unique(CurrentEvents(:,2)))';
    EdgeY = EdgeY(1,2:end); % Otherwise it takes 0 as its first value
    EdgeX = linspace(0, TimeForYLine, SizeX);
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
        
        %% Calculate edge vector of image (for hist3 function)
        MaxDiffInStarts = max(diff(CurrentEvents(:,2)));
        if MaxDiffInStarts ~= 0
            EdgeX = linspace(0, MaxDiffInStarts, SizeX);
        elseif isempty(MaxDiffInStarts)
            continue;
        else
            EdgeX = linspace(0, CurrentEvents(1,2), SizeX);
        end

        EdgeY = linspace(CurrentEvents(1,2), CurrentEvents(end,2), SizeY);

        %% Run hist3
        RawImagesMat(:,:,CurrentFrameNum) = PhotonSpreadToImage2(CurrentEvents, SizeX, SizeY, EdgeX, EdgeY);
        imagesc(RawImagesMat(:,:,CurrentFrameNum))
    end
end

end
