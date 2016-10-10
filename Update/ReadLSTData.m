function [hexData, dataFormat, range] = ReadLSTData(fileName, folderOfFile)
%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "ReadLSTData.m"                                   %
% Purpose: Receives a filename of a list file and creates a    %
% binary string vector of that data. It also detects the       %
% time_patch and range value of the data.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
fprintf('Reading file... ');

fileID = fopen(strcat(folderOfFile, fileName));

%% Find the range value
formatSpec = 'range=%d';
cellRange = textscan(fileID, formatSpec, 'HeaderLines', 1);
rangeBeforeBitDepth = cell2mat(cellRange);

%% Find the bit depth value
formatSpec = 'bitshift=%s';
cellBitshift = textscan(fileID, formatSpec, 'HeaderLines', 32);
cellBitshift{1,1} = hex2dec(char(cellBitshift{1,1}));
bitshift = mod(cellBitshift{1,1}, 100);
range = rangeBeforeBitDepth * 2^(bitshift);

%% Find the time_patch value
formatSpec = '%s';
expr = 'time_patch=(\w+)';
cellTimePatch = cell(0);
while isempty(cellTimePatch)
    current_line_cell = textscan(fileID, formatSpec, 1);
    [cellTimePatch] = regexp(cell2mat(current_line_cell{1,1}), expr, 'tokens');
end
timePatch = cell2mat(cellTimePatch{1,1});

%% Reach Data
formatSpec = '%s';
temp1 = {'[DATA]'}; % Start of DATA text line
temp2 = {'abc'}; % Initialization
while ~cellfun(@strcmp, temp1, temp2);
    temp2 = textscan(fileID, formatSpec, 1);
end

%% Read data using Python
f = py.open([folderOfFile fileName], 'r');
f.seek(ftell(fileID) + 2); % move Python file pointer to MATLAB's position
dataOneLine = f.read();
hexData = dataOneLine.splitlines();

%% Depending on timePatch number, read the data vector accordingly
dataFormat = determineDataFormat(timePatch);

%%
fclose(fileID);
f.close();
fprintf('File read successfully. Time patch value is %s. Total number of events: %d.\nCreating data vectors... ', timePatch, size(hexData, 2));
end
