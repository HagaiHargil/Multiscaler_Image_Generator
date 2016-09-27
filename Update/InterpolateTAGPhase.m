%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "InterpolateTAGPhase.m"                                %
% Purpose: When the user desires it take data from PMT and TAG %
% lens and finds the phase of each data point in the TAG       %
% period. Note that it adds another column to existing data    %
% table containing phase data, between 0 and 2pi.              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

function dataArray = InterpolateTAGPhase(numOfPhotons, numOfLines, dataPhotons, dataLines)

%% Sort all events, creating the basic pairs of photons and their respective line starts and ends
dataArray(:, 1) = dataPhotons;
[allEvents, ind] = sort([dataPhotons; dataLines]); % Create a long vector cotaining sorted line and photon events
photonIndices = find(ind < numOfPhotons); % Indices of photons in that long array

%% Initializations before going through each photon
dataToBeSent = zeros(10000, 1) - 1;
totalEventsNum = size(allEvents, 1);

curNumOfPhotons = 1;

for n = photonIndices'
    dataToBeSent(find(dataToBeSent < 0, 1), 1) = allEvents(n); % append photon to list
    endOfLineCheck = min(n + 1, totalEventsNum);
    startOfLineCheck = max(n - 1, 1);
    
    if ~ismember(startOfLineCheck, photonIndices) % do we need to update start of line time?
        startOfLine = allEvents(startOfLineCheck);
    end
    
    if ~ismember (endOfLineCheck, photonIndices) % do we need to update end  of line time? if we don't - interpolate the phase
        endOfLine = allEvents(endOfLineCheck);
        [phaseVec, sizeOfPhaseVec] = FindThePhase(endOfLine - startOfLine, dataToBeSent(dataToBeSent > -1) - startOfLine);
        dataArray(curNumOfPhotons:curNumOfPhotons + sizeOfPhaseVec - 1, 2) = phaseVec;
        dataToBeSent = zeros(10000, 1) - 1;
        curNumOfPhotons = curNumOfPhotons + sizeOfPhaseVec;
    end
end
end