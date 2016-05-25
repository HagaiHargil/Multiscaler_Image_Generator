%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "main_multiscaler_data_readout.m"                 %
% Purpose: Main program that controls the data readout from    %
% multiscaler list files. Run it to open the GUI to choose the %
% proper file or folder for readout.                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
close all;
clear all;
clc;

%% Open GUI
useIteration = 0; % One file or more?
numOfFiles = 'All files'; % Default choice
H = Multiscaler_GUI; % Start GUI
waitfor(H); % While GUI is open don't continue

%% Number of files to read as defined in GUI
if useIteration 
    myFolderInfo = dir(folderOfFiles);
    myFolderCell = struct2cell(myFolderInfo); % Only names of files
    helpcell = strfind(myFolderCell(1,:), '.lst');
    listOfListFiles = myFolderCell(1,cellfun(@numel, helpcell) == 1); % Only files that end with .lst
    indexInListFile = 1; % Default is to start from first list file
    FileName = listOfListFiles{1,indexInListFile}
    
    %% Decide on the number of iterations
    if strcmp(numOfFiles, 'All files')
        numOfFiles_int = 1;
    else    
        numOfFiles_int = str2double(numOfFiles);
    end
else
    numOfFiles_int = 1;
end

currentIterationNum = 1;

while (currentIterationNum <= numOfFiles_int)
    %% Data Read
    fprintf('Reading file... ');
    [Binary_Data, Time_Patch, Range] = LSTDataRead(FileName);
    fprintf('File read successfully. Time patch value is %s. \nCreating data vectors... ', Time_Patch);

    %% Time patch choice - create data vector
    num_of_data_vectors = 0;
    switch Time_Patch
        case '32'
            if STOP1 == 8
                STOP1_empty = true;
                STOP1_Dataset = [];
            else
                STOP1_Dataset   = CreateDataVector32(Binary_Data, 1, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            if STOP2 == 8
                STOP2_empty = false;
                STOP2_Dataset = [];
            else
                STOP2_Dataset   = CreateDataVector32(Binary_Data, 2, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            if START == 8
                START_empty = false;
                START_Dataset = [];
            else
                START_Dataset   = CreateDataVector32(Binary_Data, 6, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            
        case '1a'
            if STOP1 == 8
                STOP1_empty = true;
                STOP1_Dataset = [];
            else
                STOP1_Dataset   = CreateDataVector1a(Binary_Data, 1, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            if STOP2 == 8
                STOP2_empty = false;
                STOP2_Dataset = [];
            else
                STOP2_Dataset   = CreateDataVector1a(Binary_Data, 2, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            if START == 8
                START_empty = false;
                START_Dataset = [];
            else
                START_Dataset   = CreateDataVector1a(Binary_Data, 6, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end 

        case '43'
            if STOP1 == 8
                STOP1_empty = true;
                STOP1_Dataset = [];
            else
                STOP1_Dataset   = CreateDataVector43(Binary_Data, 1, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            if STOP2 == 8
                STOP2_empty = false;
                STOP2_Dataset = [];
            else
                STOP2_Dataset   = CreateDataVector43(Binary_Data, 2, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            if START == 8
                START_empty = false;
                START_Dataset = [];
            else
                START_Dataset   = CreateDataVector43(Binary_Data, 6, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end

        case '2'
            if STOP1 == 8
                STOP1_empty = true;
                STOP1_Dataset = [];
            else
                STOP1_Dataset   = CreateDataVector2(Binary_Data, 1, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            if STOP2 == 8
                STOP2_empty = false;
                STOP2_Dataset = [];
            else
                STOP2_Dataset   = CreateDataVector2(Binary_Data, 2, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
            if START == 8
                START_empty = false;
                START_Dataset = [];
            else
                START_Dataset   = CreateDataVector2(Binary_Data, 6, double(Range));
                num_of_data_vectors = num_of_data_vectors + 1;
            end
    end
    fprintf('%f data vectors created successfully. \n Generating photon array...\n', num_of_data_vectors);
   

%% Create the photon cell array of lines

input_channels = [START; STOP1; STOP2];
[PhotonArray, NumOfLines, StartOfFrameChannel, MaxNumOfEventsInLine, TotalEvents] = PhotonCells(START_Dataset, STOP1_Dataset, STOP2_Dataset, input_channels(input_channels(:,1) == 1,1));
fprintf('Finished creating the photon array. Creating Raw image...\n');

%% Determine which data channel contains frame data
switch StartOfFrameChannel
    case 1
        StartOfFrameVec = CreateFrameStarts(STOP1_Dataset.Time_of_Arrival(:));
    case 2
        StartOfFrameVec = CreateFrameStarts(STOP2_Dataset.Time_of_Arrival(:));
    case 6
        StartOfFrameVec = CreateFrameStarts(START_Dataset.Time_of_Arrival(:));
    case 0 % No start of frame signal
        StartOfFrameVec = [];
end

%% Create Images 
% SizeX = 100;
% SizeY = 100;

RawImagesMat = ImageGeneratorHist3(PhotonArray, SizeX, SizeY, StartOfFrameVec, NumOfLines, TotalEvents);

%% Save Results

% MySaver;

%% Display Outcome

DisplayOutcome;

    %% Update while loop parameters
    if useIteration
        if strcmp(numOfFiles, 'All files')
            indexInListFile = indexInListFile + 1;
            helpcell = strfind(myFolderCell(1,:), '.lst'); % Update list of files in folder
            listOfListFiles = myFolderCell(1,cellfun(@numel, helpcell) == 1); % Only files that end with .lst
            FileName = listOfListFiles{1,indexInListFile}; % Move forward one file
        else
            currentIterationNum = currentIterationNum + 1;
            indexInListFile = indexInListFile + 1;
            helpcell = strfind(myFolderCell(1,:), '.lst'); % Update list of files in folder
            listOfListFiles = myFolderCell(1,cellfun(@numel, helpcell) == 1); % Only files that end with .lst
            FileName = listOfListFiles{1,indexInListFile}; % Move forward one file
        end
             
    else
        break; % When a specific file was chosen run the loop once
    end
end
