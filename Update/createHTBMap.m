function htbMap = createHTBMap()
%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "createHTBMap.m"                                  %
% Purpose: Create a simple containers.Map element that         %
% converts a hexadecimal character to a binary double.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
keySet = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
valueSet = {'0000', '0001', '0010', '0011', '0100', '0101', '0110', ...
'0111', '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111'};

htbMap = containers.Map(keySet, valueSet);
end