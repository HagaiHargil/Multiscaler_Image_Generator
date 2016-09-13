%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "main_multiscaler_data_readout.m"                 %
% Purpose: Main program that controls the data readout from    %
% multiscaler list files. Run it to open the GUI to choose the %
% proper file or folder for readout.                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
close all;
clearvars;
clc;

%% Open GUI
useIteration = 0; % One file or more?
InterpolateTAGLens = 0; % Initialization
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

%% Check inputs from GUI
% Existing file in folder
if ~exist('FileName', 'var')
    error('No file chosen.');
end

% Image pixel data
if ((SizeX <= 0) || (SizeY <= 0))
    error('Pixel size of final image incorrect. \n'); 
end

% Tag bits data
if ((Polygon_X_TAG_bit_start > Polygon_X_TAG_bit_end) || (Polygon_X_TAG_bit_start <= 0) || ( Polygon_X_TAG_bit_start > 16) || ...
     (Polygon_X_TAG_bit_end <= 0) || (Polygon_X_TAG_bit_end > 16) || ...
     (Galvo_Y_TAG_bit_start > Galvo_Y_TAG_bit_end) || (Galvo_Y_TAG_bit_start <= 0) || (Galvo_Y_TAG_bit_start > 16) || ...
     (Galvo_Y_TAG_bit_end <= 0) || (Galvo_Y_TAG_bit_end > 16) || ...
     (TAG_Z_TAG_bit_start > TAG_Z_TAG_bit_end) || (TAG_Z_TAG_bit_start <= 0) || (TAG_Z_TAG_bit_start > 16) || ...
     (TAG_Z_TAG_bit_end <= 0) || (TAG_Z_TAG_bit_end > 16))
    error('TAG bits allocation incorrect.'); 
end

% Tag lens data
if ((TAGFreq <= 0) || (TAGFreq > 193))
    error('Invalid TAG lens frequency.');
end

%% 
currentIterationNum = 1;

while (currentIterationNum <= numOfFiles_int)
    %% Data Read
    fprintf('Reading file... ');
    [Binary_Data, Time_Patch, Range] = LSTDataRead(FileName);
    fprintf('File read successfully. Time patch value is %s. \nCreating data vectors... ', Time_Patch);

    %% Create map for all possible time patch values
    num_of_data_vectors = 0;
    keySet = {'32', '1a', '43', '2', '2a', '22', '5b', 'Db', 'f3', 'c3', '3'};
    valueSet = {'CreateDataVector32(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVector1a(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVector43(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVector2(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVector2a(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVector22(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVector5b(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVectorDb(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVectorf3(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVectorc3(Binary_Data, CurrentChannel, double(Range));', ...
        'CreateDataVector3(Binary_Data, CurrentChannel, double(Range));', ...
    };
% WHEN ADDING A NEW TIME PATCH DON'T FORGET TO UPDATE LST_DATAREAD AND THE
% CREATE DATA VECOTR FUNCTION
    mapObj = containers.Map(keySet, valueSet);
    
    %% Time patch choice - go through each channel and extract its data
    if STOP1 == 8
        STOP1_empty = true;
        STOP1_Dataset = [];
    else
        CurrentChannel = 1;
        STOP1_Dataset = eval(mapObj(Time_Patch));
        if ~isempty(STOP1_Dataset)
            num_of_data_vectors = num_of_data_vectors + 1;
        end
    end
    
    if STOP2 == 8
        STOP2_empty = false;
        STOP2_Dataset = [];
    else
        CurrentChannel = 2;
        STOP2_Dataset = eval(mapObj(Time_Patch));
        if ~isempty(STOP2_Dataset)
            num_of_data_vectors = num_of_data_vectors + 1;
        end
    end
    
    if START == 8
        START_empty = false;
        START_Dataset = [];
    else
        CurrentChannel = 6;
        START_Dataset = eval(mapObj(Time_Patch));
        if ~isempty(START_Dataset)
            num_of_data_vectors = num_of_data_vectors + 1;
        end
    end
    
    fprintf('\n%d data vector(s) created successfully. \nGenerating photon array...\n', num_of_data_vectors);

    
%% TEMPORARY FOR SCANIMAGE 25 August 2016

%     STOP2_Dataset.Time_of_Arrival = STOP2_Dataset.Time_of_Arrival + 1e6;

    
%% Create the photon array of lines
valueSet2 = {6, 1, 2};
keySet2 = {START, STOP1, STOP2};
input_channels = containers.Map(keySet2, valueSet2);
%input_channels(1) is the PMT data.
[PhotonArray, NumOfLines, StartOfFrameChannel, MaxNumOfEventsInLine, TotalEvents, PMTChannelNum, MaxDiffOfLines, MaxDiffOfLines2] = PhotonCells(START_Dataset, STOP1_Dataset, STOP2_Dataset, input_channels(1));
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

%% Determine which data channel contains TAG data and interpolate TAG for each photon
if InterpolateTAGLens
    fprintf('TAG lens data being interpolated...\n');
    keySet3 = {1, 2, 6};
    valueSet3 = {STOP1_Dataset, STOP2_Dataset, START_Dataset};
    mapData = containers.Map(keySet3, valueSet3);
    

    
    InterpData = Plot_TAG_Phase(mapData(input_channels(1)), TAGFreq, mapData(input_channels(5))); 
    
    if ~isnan(InterpData{1,1})
        PhotonArray = [PhotonArray, table2array(InterpData(:,end))];

        fprintf('TAG lens data interpolated successfully. Generating image...\n');
    else
        fprintf('TAG input channel was incorrect. Proceeding to generate image...\n');
    end
end

%% TAG Phase sanity check

% figure('windowStyle','docked');
% xi = 1 : 100000;
% plot(table2array(InterpData(xi,1)), sin(table2array(InterpData(xi,4))),'.-', ...
% table2array(STOP2_Dataset(xi,1)),zeros(size(table2array(STOP2_Dataset(xi,1)))),'.')
% xlim([0 xi(end)])

%% Attempting to guess when each frame starts:

NumGuessedFrames = 3;

StartOfFrameVec = linspace(1,PhotonArray(end,2) , NumGuessedFrames+1)';


%% Create Images


% RawImagesMat = ImageGeneratorHist3(PhotonArray, SizeX, SizeY, StartOfFrameVec, NumOfLines, TotalEvents, MaxDiffOfLines);
[RawImagesMat] = ImageGeneratorHist5(PhotonArray, SizeX, SizeY, StartOfFrameVec, NumOfLines, TotalEvents, MaxDiffOfLines, MaxDiffOfLines2);

% for n = 1:6
%     subplot(3,2,n)
%     OffsetPhase = 0.2 * (n-1) * pi; 
%     RawImagesMat = ImageGeneratorHist3(PhotonArray, SizeX, SizeY, StartOfFrameVec, NumOfLines, TotalEvents, MaxDiffOfLines, OffsetPhase);
%     title(num2str(OffsetPhase));
% end
%% Raw Histogram Inspection
%  histogram( PhotonArray(:,1) + PhotonArray(:,2) , 1e5);


%% Save Results

 MySaver;

%% Display Outcome

% DisplayOutcome;

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

%% 

figure;
subplot(2,1,1);
plot(   diff(STOP2_Dataset.Time_of_Arrival) .* 800e-12, '.-');
xlabel('Line number');
ylabel('dt [seconds]');
title('STOP2 time intervals between successive line triggers')
subplot(2,1,2);
plot(   diff(START_Dataset.Time_of_Arrival)  .* 800e-12, '.-');
xlabel('Line number');
ylabel('dt [seconds]');
title('START time intervals between successive line triggers')