%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "CreatePhotonArray.m"                             %
% Purpose: Devides received data points into a two-columned    %
% array. First one is the photon arrival time relative to the  %
% second column, which is the start-of-row time. All data      %
% channels are put into cells, while the second row in that    %
% cell array is the suitable edge vector.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

function [mapPhotonArray, numOfLines, maxNumOfEventsInLine, numOfPhotons, maxDiffOfLines] = CreatePhotonArray(mapSortedEventsVectors, inputChannels, numOfDataVectors)
cellPhotonArray = cell(1, max(1, numOfDataVectors - 1));
maxDiffOfLines = cell(1, max(1, numOfDataVectors - 1));
numOfPhotons = size(mapSortedEventsVectors(inputChannels(1)), 1);

%% Case of only photon data taken
if numOfDataVectors == 1
   [cellPhotonArray{1,1}, maxNumOfEventsInLine, maxDiffOfLines] = GenerateLineTimes(numOfPhotons, 0, mapSortedEventsVectors(inputChannels(1)), []); 
   fprintf('Finished creating the photon array.');
   numOfLines = 0;
   photons.list = cellPhotonArray{1,1};
   mapPhotonArray = containers.Map(inputChannels, photons);
   return;
end

%% Case of line data from one of more channels was also taken
existingKeys = cell2mat(keys(inputChannels));
existingKeys = existingKeys(existingKeys(1,:) ~= 1); % Excluding PMT data
mapPhotonArray = containers.Map('KeyType', 'double', 'ValueType', 'any');
for n = existingKeys
   numOfLines = size(mapSortedEventsVectors(inputChannels(n)), 1);
   
   if n == 5 % TAG lens data requires different interpolation
       fprintf('TAG lens data being interpolated...\n');
       photons.list = InterpolateTAGPhase(numOfPhotons, numOfLines, mapSortedEventsVectors(inputChannels(1)), mapSortedEventsVectors(inputChannels(n)));
       photons.numOfLines = numOfLines;
       mapPhotonArray = [mapPhotonArray; containers.Map(n, photons)];
       fprintf('TAG lens data interpolated successfully.\n');
   else
       [photons.list, photons.maxEventsInLine, photons.maxDiffOfLines] = GenerateLineTimes(numOfPhotons, numOfLines, mapSortedEventsVectors(inputChannels(1)), mapSortedEventsVectors(inputChannels(n))); 
       photons.numOfLines = numOfLines;
       mapPhotonArray = [mapPhotonArray; containers.Map(n, photons)];
   end
end
maxNumOfEventsInLine = 0;
fprintf('Finished creating the photon array.');

end