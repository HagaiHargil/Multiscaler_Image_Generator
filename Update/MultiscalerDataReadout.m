%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "MultiscalerDataReadout.m"                        %
% Purpose: Main program that controls the data readout from    %
% multiscaler list files. Run it to open the GUI and choose    %
% the proper file or folder for readout.                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
close all;
clearvars;
clc;

%% Run the GUI
RunGUI;

%% Read data and convert to a readable hexadecimal list
[hexData, dataFormat, range] = ReadLSTData(FileName, folder_of_file);
    
%% Run through all events in a parallel manner, creating the Event cell array
[STOP1_Dataset, STOP2_Dataset, START_Dataset] = createEvents(hexData, dataFormat, range);

%% Create Map containers for data
inputChannels = containers.Map({STOP1, STOP2, START}, {1, 2, 6}); % e.g. inputChannels(1) is the PMT channel data.
mapOfDataVectors = containers.Map({1, 2, 6}, {STOP1_Dataset, STOP2_Dataset, START_Dataset}); %e.g. mapOfDataVectors(inputChannels(5)) is the actual TAG dataset.

%% Make events (line, frame) not originated from the PMT regular
[mapSortedEventsVectors] = RegularizeEvents(inputChannels, mapOfDataVectors); % send all three data vectors, the function will know inside which data vector is the PMT one. 

%% Allocate the photons with their respective start-of-line times
photonList = allocateLines(STOP1_Dataset, STOP2_Dataset, START_Dataset);

%% Seperate data to different channels and convert to timebins
% % Create map of all possible time patch values
% mapForTimePatch = CreateMapForTimePatch;
%     
% % Go through each data channel and create its data vector
% [STOP1_Dataset, STOP2_Dataset, START_Dataset, numOfDataVectors] = CreateDataVectors(mapForTimePatch, timePatch, Binary_Data, Range);

%% Create PhotonArray
[mapPhotonArray, numOfLines, MaxNumOfEventsInLine, numOfPhotons, MaxDiffOfLines] = CreatePhotonArray(mapSortedEventsVectors, inputChannels, numOfDataVectors);

%% Make sure we have the same number of photons in all vectors
mapPhotonArray = IntersectPhotonArray(mapPhotonArray);

%% Determine number of frames and the cut-off points
startOfFramesVec = StartOfFrames(num_of_frames, use_slow_galvo_for_frames, mapPhotonArray);

%% Create edge vectors for all datasets
mapPhotonArray = CreateEdgeVec([SizeX, SizeY, SizeZ], mapPhotonArray, use_slow_galvo_for_frames);

%% Create matrix containing viewable data
[RawImagesMat] = ImageGenerator(mapPhotonArray, numOfLines, numOfPhotons, startOfFramesVec);

%% Visualize data

%% Save data 

%% Rerun script for rest of files in folder
