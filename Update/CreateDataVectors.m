%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "CreateDataVectors.m"                             %
% Purpose: Goes through all input channels and creates         %
% properly formatted data vectors.                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

function [STOP1_Dataset, STOP2_Dataset, START_Dataset, numOfDataVectors] = CreateDataVectors(mapForTimePatch, timePatch, Binary_Data, Range)
    
    numOfDataVectors = 0;
    
%%
    CurrentChannel = 1;
    STOP1_Dataset = eval(mapForTimePatch(timePatch));
        if ~isempty(STOP1_Dataset)
            numOfDataVectors = numOfDataVectors + 1;
        end
  
%%   
    CurrentChannel = 2;
    STOP2_Dataset = eval(mapForTimePatch(timePatch));
        if ~isempty(STOP2_Dataset)
            numOfDataVectors = numOfDataVectors + 1;
        end
    
%%     
    CurrentChannel = 6;
    START_Dataset = eval(mapForTimePatch(timePatch));
        if ~isempty(START_Dataset)
            numOfDataVectors = numOfDataVectors + 1;
        end
    
    fprintf('\n%d data vector(s) created successfully. \nGenerating photon array...\n', numOfDataVectors);
        
end