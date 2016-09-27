%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "RunGUI.m"                                        %
% Purpose: Initialize needed variables and run the GUI.        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
useIteration = 0; % One file or more?
use_slow_galvo_for_frames = 0; %Initialization

%% Open GUI
H = Multiscaler_GUI; % Start GUI
waitfor(H); % While GUI is open don't continue

%% Check inputs and submit error if they're invalid
CheckGUIInputs;
