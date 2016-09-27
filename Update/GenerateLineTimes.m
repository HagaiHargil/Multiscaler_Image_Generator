%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "CreateDataList.m"                                %
% Purpose: Creates a two-columned vector - left column is the  %
% photon arrival time (in timebins), and the right one is the  %
% fitting start-of-line time. The final dataset is released    %
% after subtracting the start-of-line time from photon time.   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

function [dataArray, maxNumOfEventsInLine, maxDiffOfLines] = GenerateLineTimes(numOfPhotons, numOfLines, dataEvents, dataLines)

%% Datasets without line data
if numOfLines == 0 
    dataArray(:,1) = dataEvents(:,1);
    dataArray(:,2) = ones(size(dataArray, 1), 1);
    maxNumOfEventsInLine = 0;
    maxDiffOfLines = 0;
    return;
end

%% Datasets with line data
maxDiffOfLines = max(diff(dataLines(:, 1)));

% Initializations
dataArray = NaN(numOfPhotons, 2); % Initialize the full data array
dataArray(:,1) = dataEvents(:,1);
numOfEventsInLine = 0; % To receive the maximum number of photons in all line, for use when generating the image 
maxNumOfEventsInLine = 0;

% Throw away first lines of photons that came before line data
indexInData = find(dataArray(:,1) >= dataLines(1,1), 1);
if indexInData ~= 1
    dataArray(1:max(1, indexInData - 1), :) = [];
end

currentPhoton = 1;
negativeIndices = 1;

% Loop through all photons, assigning them line values
while ~isempty(negativeIndices) && (currentPhoton < numOfPhotons + 1)
    dataArray(currentPhoton, 2) = dataLines(negativeIndices, 1);
    lineTimes = dataLines - dataArray(currentPhoton);
    negativeIndices = find(lineTimes<0, 1, 'last');   
    currentPhoton = currentPhoton + 1;
end


%% Change the NaNs at the end of the DataArray
dataArray(isnan(dataArray)) = dataLines(end, 1);

%% Substract the line time from photon arrival times to receive relative arrival times
dataArray(:,1) = dataArray(:,1) - dataArray(:,2);
dataArray = dataArray(dataArray(:, 1) > 0, :);
end
