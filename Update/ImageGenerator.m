function RawImagesMat = ImageGenerator(mapPhotonArray, numOfLines, numOfPhotons, startOfFrameVec)

%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "ImageGenerator.m"                                %
% Purpose: Creates a histogram of a 3D matrix (4D in total),   %
% one for each frame of the dataset.                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

for curFrameNum = 1:size(startOfFrameVec, 1)
    for curKey = cell2mat(keys(mapPhotonArray))
        helpCell = mapPhotonArray(curKey);
        curEvents = helpCell{1,:}((helpCell{1,:}(:,2) >= StartOfFrameVec(CurrentFrameNum, 1)) & (helpCell{1,:}(:,2) < StartOfFrameVec(CurrentFrameNum + 1, 1)), :); % Only photons that came in the specific time interval of the CurrentFrameNum's frame
        
        photonsForImage = [photonsForImage curEvents]
    end
end
