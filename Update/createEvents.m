function [STOP1_Dataset, STOP2_Dataset, START_Dataset] = createEvents(hexData, dataFormat, range)
%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "createEvents.m"                                  %
% Purpose: Receives all data and creates the events cell array % 
% in a parallel manner.                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create hex to binary map
hexToBinMap = createHTBMap();

%% Loop across all events, creating the cell array
numOfEvents = size(hexData, 2); % total number of events in our file
allEvents(1:numOfEvents, 1) = Event();
helpCell = cell(hexData); % this line and the next one are unneeded if
% indeed we manage to parfor the Python list named hexData.
helpCell = cellfun(@char, helpCell, 'UniformOutput', false);

if mod(dataFormat.otherThanTime, 4) == 0 % all timepatches besides timepatch == 3
    parfor n = 1:numOfEvents
       allEvents(n) = createSingleEvent(helpCell{n}, dataFormat, range, hexToBinMap); % A single event each time
       % changed helpCell{n} to char(hexData{n}) when trying to parfor
       % Python lists
    end
else % only timepatch == 3
    parfor n = 0:numOfEvents
       allEvents(n) = createSingleEvent3(hexData{n}, hexToBinMap);
    end
end

%% Sort the events to the different channels they originated from
STOP1_Dataset = allEvents([allEvents.channel] == 1);
STOP2_Dataset = allEvents([allEvents.channel] == 2);
START_Dataset = allEvents([allEvents.channel] == 6);

end