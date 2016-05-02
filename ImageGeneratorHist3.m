function RawImagesMat = ImageGeneratorHist3(PhotonArray, SizeX, SizeY, StartOfFrameVec, NumOfLines, TotalEvents)

RawImagesMat = zeros(SizeX, SizeY, size(StartOfFrameVec, 1) - 1); % Last half-recorded frame won't be imaged

%% Create histograms
for CurrentFrameNum = 1:size(StartOfFrameVec, 1) - 1 % If a frame isn't complete an image won't be generated from it
   
    %% Take relevant data
    CurrentEvents = PhotonArray((PhotonArray(:,2) >= StartOfFrameVec(CurrentFrameNum, 1) & (PhotonArray(:,2) < StartOfFrameVec(CurrentFrameNum + 1, 1))),:); % Only photons that came in the specific time interval of the CurrentFrameNum's frame
    
    %% Calculate edge vector of image (for hist3 function)
    EdgeX = linspace(0, max(diff(CurrentEvents(:,2))), SizeX);
    EdgeY = linspace(0, CurrentEvents(end,2), SizeY);
    
    %% Run hist3
    RawImagesMat(:,:,CurrentFrameNum) = PhotonSpreadToImage2(CurrentEvents, SizeX, SizeY, EdgeX, EdgeY);
end

end
