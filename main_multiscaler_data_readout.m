%% Readout of Multiscaler data
% This is the main file that reads the MPANT data.
% Run it when you wish to do so. DO NOT RUN IT IF YOU DON'T.

%% Data Read
close all;
clear all;
clc;
H = Multiscaler_GUI;
waitfor(H);
[Binary_Data, Time_Patch, Range] = LSTDataRead(FileName);

%% Time patch choice - create data vector
switch Time_Patch
    case '32'
        PMT_Dataset   = CreateDataVector32(Binary_Data, 1, double(Range));
        Galvo_Dataset = CreateDataVector32(Binary_Data, 2, double(Range));
        TAG_Dataset   = CreateDataVector32(Binary_Data, 6, double(Range));
    
    case '1a'
        PMT_Dataset   = CreateDataVector1a(Binary_Data, 1, double(Range));
        Galvo_Dataset = CreateDataVector1a(Binary_Data, 2, double(Range));
        TAG_Dataset   = CreateDataVector1a(Binary_Data, 6, double(Range)); 
end

%% Blubber

TotalHitsX = [];
TotalHitsZ = [];


for SweepNumber = 1:100

    photon_single_sweep = PMT_Dataset((PMT_Dataset.Sweep_Counter == SweepNumber),1);
    Galvo_single_sweep = Galvo_Dataset((Galvo_Dataset.Sweep_Counter == SweepNumber),1);
    TAG_single_sweep = TAG_Dataset((TAG_Dataset.Sweep_Counter == SweepNumber),1);


    % MaximalGalvoPeriod = max(diff(table2array(Galvo_single_sweep)));
    % 
    % [G,P] = meshgrid(single(table2array(Galvo_single_sweep)),single(table2array(photon_single_sweep)));
    % 
    % RawRelativePhotonArrivalTime = P-G;
    % RawRelativePhotonArrivalTime(RawRelativePhotonArrivalTime < 1) = 1e10;
    % RawRelativePhotonArrivalTime(RawRelativePhotonArrivalTime > MaximalGalvoPeriod) = 1e10;
    % 
    % RelativePhotonArrivalTime = min(RawRelativePhotonArrivalTime');
    % RelativePhotonArrivalTime(RelativePhotonArrivalTime>1e9) = 1;

    X_hits = ArrivalTimeRelativer(Galvo_single_sweep,photon_single_sweep);
    Z_hits = ArrivalTimeRelativer(TAG_single_sweep,photon_single_sweep);

    TotalHitsX = [TotalHitsX; X_hits];
    TotalHitsZ = [TotalHitsZ; Z_hits];

end

OutputFileName = strcat('MultiscalerMovie-', FileName(1:end-3),'mat' );
save(OutputFileName);

% plot(TotalHitsX,TotalHitsZ,'.')
PhotonSpreadToImage2;

figure;
imshow(RawImage',[]);
% imshow(log(double(RawImage'+1)));colorbar;
axis square;
