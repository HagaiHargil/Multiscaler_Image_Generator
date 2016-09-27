%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "CreateDataList.m"                                %
% Purpose: Creates a two-columned vector - left column is the  %
% photon arrival time (in timebins), and the right one is the  %
% fitting start-of-line time. The final dataset is released    %
% after subtracting the start-of-line time from photon time.   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

function [DataArray, MaxNumOfEventsInLine, MaxDiffOfLines] = CreateDataList(numOfPhotons, numOfLines, DataEvents, DataLines)

if numOfLines == 0
    DataArray(:,1) = DataEvents(:,1);
    DataArray(:,2) = ones(size(DataArray, 1), 1);
    MaxNumOfEventsInLine = 0;
    MaxDiffOfLines = 0;
    return;
end

%% Create basic vector of start-of-line times
StartingTimeOfLine = zeros(1, numOfLines);
StartingTimeOfLine(1,:) = DataLines(:,1)';
MaxDiffOfLines = max(diff(StartingTimeOfLine(1, :)));

%% Create the full data vector
DataArray = NaN(numOfPhotons, 2); % Initialize the full data cell array
DataArray(:,1) = DataEvents(:,1);

CurrentDataValue = DataEvents(1,1);
CurrentDataNumber = 0;
NumOfEventsInLine = 0; % To receive the maximum number of photons in all line, for use when generating the image 
MaxNumOfEventsInLine = 0;
LastUsedLine = 0;

for CurrentLine = 1:numOfLines - 1
    while ((CurrentDataValue < StartingTimeOfLine(1, CurrentLine + 1))  && (CurrentDataNumber + 1 <= numOfPhotons))
        DataArray(CurrentDataNumber + 1, 2) = StartingTimeOfLine(1, CurrentLine);
        
        % Next line of data follows:
        
        CurrentDataValue = DataEvents(CurrentDataNumber + 1, 1);
        
        MaxNumOfEventsInLine = max(MaxNumOfEventsInLine, NumOfEventsInLine + 1);
        CurrentDataNumber = CurrentDataNumber + 1;
        NumOfEventsInLine = NumOfEventsInLine + 1;
      
    end
    %%
    LastUsedLine = LastUsedLine + NumOfEventsInLine;
    NumOfEventsInLine = 0;
end

%% Change the NaNs at the end of the DataArray
DataArray(isnan(DataArray)) = StartingTimeOfLine(1, end);

%% Substract the line time from photon arrival times to receive relative arrival times
DataArray(:,1) = DataArray(:,1) - DataArray(:,2);

%% 

end