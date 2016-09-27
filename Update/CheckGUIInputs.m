%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "CheckGUIInputs.m"                                %
% Purpose: Make sure all inputs in GUI are valid.              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Existing file in folder
if ~exist('FileName', 'var')
    error('No file chosen.');
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
