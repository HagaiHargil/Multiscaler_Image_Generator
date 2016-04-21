%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "PhotonCells.m"                                   %
% Purpose: Devides received photons into cell array, each      %
% having its timecode and list of photons in this "line".      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [PhotonCellArray] = PhotonCells(START_Dataset, STOP1_Dataset, STOP2_Dataset, PMT_Channel_Num)

% The switch determines in which channel will we find the photon arrival time data. 
switch PMT_Channel_Num
    case 1
        mean_frequency_start = mean(diff(START_Dataset.Time_of_Arrival(1:end))); % here we find the data channel that is responsible to the rows of the picture.
        mean_frequency_stop2 = mean(diff(STOP2_Dataset.Time_of_Arrival(1:end)));
        if mean_frequency_start < mean_frequency_stop2 
            Num_of_Lines = numel(START_Dataset.Time_of_Arrival) .* 2 - 1; % Each start-of-line signal tells us that two lines have passed.
            PhotonCellArray = cell(2, Num_of_Lines);
            %% Create the first row of PhotonCellArray that holds the starting arrival time of this column
            StartingTimeOfLine = zeros(1, Num_of_Lines);
            StartingTimeOfLine(1,1:2:end) = table2array(START_Dataset(:,1))'; % odd cells receive the original numbers
            HalfDiffVector = round(diff(START_Dataset.Time_of_Arrival(:)) ./ 2);
            StartingTimeOfLine(1,2:2:end) = START_Dataset.Time_of_Arrival(1:end - 1) + HalfDiffVector; % even cells receive half of that number
            PhotonCellArray(1,:) = num2cell(StartingTimeOfLine); % first row of cell array is the starting arrival time (in time bins) of photons in that cell
            
            %% Create the second row, that contains a list of photon arrival times
            PhotonNumber = size(STOP1_Dataset.Time_of_Arrival,1);
            CurrentPhotonValue = STOP1_Dataset.Time_of_Arrival(1);
            CurrentPhotonNumber = 1;
            CurrentPhotonArray = zeros(PhotonNumber,1);
            for CurrentLine = 1:Num_of_Lines
                while ((CurrentPhotonValue < PhotonCellArray{1,CurrentLine + 1}) && (CurrentPhotonNumber <= PhotonNumber))
                    CurrentPhotonArray(CurrentPhotonNumber, 1) = CurrentPhotonValue;
                    CurrentPhotonNumber = CurrentPhotonNumber + 1;
                    CurrentPhotonValue = STOP1_Dataset.Time_of_Arrival(CurrentPhotonNumber);
                end
                PhotonCellArray{2,CurrentLine} = CurrentPhotonArray;
                CurrentPhotonArray = [];
            end
     
        % Flip the even cells
        %PhotonCellArray{2,2:2:end} = flip(PhotonCellArray{2,2:2:end});
            
        else
            Num_of_Lines = numel(STOP2_Dataset.Time_of_Arrival) .* 2 - 1; % Each start-of-line signal tells us that two lines have passed.
            PhotonCellArray = cell(2, Num_of_Lines);
            %% Create the first row of PhotonCellArray that holds the starting arrival time of this column
            StartingTimeOfLine = zeros(1, Num_of_Lines);
            StartingTimeOfLine(1,1:2:end) = table2array(STOP2_Dataset(:,1))'; % odd cells receive the original numbers
            HalfDiffVector = round(diff(STOP2_Dataset.Time_of_Arrival(:)) ./ 2);
            StartingTimeOfLine(1,2:2:end) = STOP2_Dataset.Time_of_Arrival(1:end - 1) + HalfDiffVector; % even cells receive half of that number
            PhotonCellArray(1,:) = num2cell(StartingTimeOfLine); % first row of cell array is the starting arrival time (in time bins) of photons in that cell
            
            %% Create the second row, that contains a list of photon arrival times
            PhotonNumber = size(STOP1_Dataset.Time_of_Arrival,1);
            CurrentPhotonValue = STOP1_Dataset.Time_of_Arrival(1);
            CurrentPhotonNumber = 1;
            CurrentPhotonArray = zeros(PhotonNumber,1);
            for CurrentLine = 1:Num_of_Lines
                while ((CurrentPhotonValue < PhotonCellArray{1,CurrentLine + 1}) && (CurrentPhotonNumber <= PhotonNumber))
                    CurrentPhotonArray(CurrentPhotonNumber, 1) = CurrentPhotonValue;
                    CurrentPhotonNumber = CurrentPhotonNumber + 1;
                    CurrentPhotonValue = STOP1_Dataset.Time_of_Arrival(CurrentPhotonNumber);
                end
                PhotonCellArray{2,CurrentLine} = CurrentPhotonArray;
                CurrentPhotonArray = [];
            end
        end
        % Flip the even cells
        %PhotonCellArray{2,2:2:end} = flip(PhotonCellArray{2,2:2:end});
        
        %%
    case 2
        mean_frequency_start = mean(diff(START_Dataset.Time_of_Arrival(1:100)));
        mean_frequency_stop1 = mean(diff(STOP1_Dataset.Time_of_Arrival(1:100)));
        if mean_frequency_start < mean_frequency_stop1
            photon_cell_channel = 6;
        else
            photon_cell_channel = 1;
        end
    case 6
        mean_frequency_stop1 = mean(diff(STOP1_Dataset.Time_of_Arrival(1:100)));
        mean_frequency_stop2 = mean(diff(STOP2_Dataset.Time_of_Arrival(1:100)));
        if mean_frequency_stop2 < mean_frequency_stop1
            photon_cell_channel = 2;
        else
            photon_cell_channel = 1;
        end
end

%% First division of photons into cells, disregarding the other input channels

end