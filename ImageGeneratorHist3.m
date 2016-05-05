function RawImagesMat = ImageGeneratorHist3(PhotonArray, SizeX, SizeY, StartOfFrameVec, NumOfLines, TotalEvents)

RawImagesMat = zeros(SizeX, SizeY, size(StartOfFrameVec, 1) - 1,'uint16'); % Last half-recorded frame won't be imaged

%% Create histograms
for CurrentFrameNum = 1:size(StartOfFrameVec, 1) - 1 % If a frame isn't complete an image won't be generated from it
   
    %% Take relevant data
    CurrentEvents = PhotonArray((PhotonArray(:,2) >= StartOfFrameVec(CurrentFrameNum, 1) & (PhotonArray(:,2) < StartOfFrameVec(CurrentFrameNum + 1, 1))),:); % Only photons that came in the specific time interval of the CurrentFrameNum's frame
    
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
