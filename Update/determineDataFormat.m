function dataFormat = determineDataFormat(timePatch)
%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "determineDataFormat.m"                           %
% Purpose: Creates a dictionary to find all needed attributes  % 
% of list file following its time patch.                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create containers.Map
keySet = {'0', '5', '1', '1a', '2a', '22', '32', '2', '5b', 'Db', 'f3', '43', 'c3', '3'};
% Format of valueSet (number of bits): [channel edge time sweep tag lost otherThanTime]
valueSet ={[3 1 12 0 0 0 0], [3 1 20 8 0 0 8], [3 1 28 0 0 0 0], [3 1 28 16 0 0 16], ...
[3 1 28 8 8 0 16], [3 1 36 0 8 0 8], [3 1 36 7 0 1 8], [3 1 44 0 0 0 0], [3 1 28 16 15 1 32], ...      
[3 1 28 16 16 0 32], [3 1 36 7 16 1 24], [3 1 44 0 15 1 16], [3 1 44 0 16 0 16], [3 1 54 0 5 1 6]}; 

dataFormatMap = containers.Map(keySet, valueSet);

%% Assign actual data to the dataFormat struct
dataFormatArray = dataFormatMap(timePatch);

dataFormat.channel = dataFormatArray(1);
dataFormat.edge = dataFormatArray(2);
dataFormat.time = dataFormatArray(3);
dataFormat.others = [dataFormatArray(4) dataFormatArray(5) dataFormatArray(6)];
dataFormat.otherThanTime = dataFormatArray(7);


end