%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "Multiscaler_GUI.m"                               %
% Purpose: Script for the GUI that controls the readout script %
% from the multiscaler.                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

function varargout = Multiscaler_GUI(varargin)
% MULTISCALER_GUI MATLAB code for Multiscaler_GUI.fig
%      MULTISCALER_GUI, by itself, creates a new MULTISCALER_GUI or raises the existing
%      singleton*.
%
%      H = MULTISCALER_GUI returns the handle to a new MULTISCALER_GUI or the handle to
%      the existing singleton*.
%
%      MULTISCALER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTISCALER_GUI.M with the given input arguments.
%
%      MULTISCALER_GUI('Property','Value',...) creates a new MULTISCALER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Multiscaler_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Multiscaler_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Multiscaler_GUI

% Last Modified by GUIDE v2.5 05-Apr-2016 17:55:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Multiscaler_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Multiscaler_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Multiscaler_GUI is made visible.
function Multiscaler_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Multiscaler_GUI (see VARARGIN)

% Choose default command line output for Multiscaler_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Multiscaler_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Multiscaler_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function FolderName = pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FolderName = uigetdir;
set(handles.nameOfFolder, 'String', FolderName);


% --- Executes on button press in pushbutton2.
function FileName = pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName = uigetfile('*.lst')
set(handles.nameOfFile, 'String', FileName);
assignin('base','FileName',FileName);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;
