%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "RegularizeEvents.m"                              %
% Purpose: Finds the two datasets which are not PMT data and   %
% makes sure they're evenly separated. RegularEventsCell only  %
% contains datasets which are not empty and are not photons.   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

function [mapSortedEventsVectors] = RegularizeEvents(inputChannels, mapOfDataVectors)
mapSortedEventsVectors = containers.Map(keys(mapOfDataVectors), values(mapOfDataVectors)); % sorting out the line events without changing original data

for n = [1 2 6]
    helpVec = mapSortedEventsVectors(n);
    eventsVector = [helpVec(:).absoluteTime];
    
    %% Skipping the channel with the PMT data and empty channels
    if ((n == inputChannels(1)) || (isempty(eventsVector)))
        continue;
    end   
    
    %% Regularize the data
    diffVec = diff(eventsVector);
    baseTimeSeparation = mean(diffVec); % Frequency of data in timebins
    allowedNoise = 0.08 * baseTimeSeparation; % 8% deviation from the mean for each successive pulse
    
    changedTicks = 1;
    while changedTicks ~= 0
        %% First we'll find all extra ticks. Then we'll deal with missing ticks.
        diffVec = diffVec - baseTimeSeparation;
        diffVec(abs(diffVec) <= allowedNoise) = 0; % if allowed noise is greater than the difference, we zero the cell
        
        extraTicks = find(diffVec(2:end) < 0) + 1; % negative values are too-frequent ticks
        eventsVector(extraTicks) = [];
        
        %% Moving on to missing ticks, and adding them up manually
        diffVec = diff(eventsVector);
        diffVec = diffVec - baseTimeSeparation;
        diffVec(abs(diffVec) <= allowedNoise) = 0; % if allowed noise is greater than the difference, we zero the cell
        
        missingTicks = find(diffVec(2:end) > 0) + 1; % negative values are too-frequent ticks
        
        if (size(missingTicks, 1) + size(extraTicks, 1)) > 0.25 * size(eventsVector, 1)
                error('Line events are too scattered. Image cannot be generated.');
        end
        
        newTicks = eventsVector(missingTicks) + baseTimeSeparation; % contains the time stamp of the missing TAG ticks
        eventsVector = [eventsVector ; newTicks]; % concatenate both arrays, placing new values in the end (simple and straight-forward, we sort them later)
        
        if isempty(missingTicks)
             if isempty(extraTicks)
                 changedTicks = 0;
                 continue;
             else
                 changedTicks = size(extraTicks, 1);
                 mapSortedEventsVectors(n) = eventsVector;
                 diffVec = diff(eventsVector);
                 continue;
             end
        else 
             changedTicks = size(extraTicks, 1) + size(missingTicks, 1);
             eventsVector = sort(eventsVector);
             mapSortedEventsVectors(n) = eventsVector;
             diffVec = diff(eventsVector);
        end            
    end
end
end