
%% Outlier removal

%%%%%%%%%%%%%%%%%%% CHANGE THIS WITH TAG RESONANCE FREQUENCY %%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                   %            
    UltraFastLensFrequency = 188000; % [Hz] - CHANGE IF NECESSARY                   %
    GalvoFrequency = 400 ; % [Hz] - Minimal galvo frequency, change if necessary    %
%                                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ExpectedLensPeriodicityInBins = 1 ./ (0.8e-9 .* UltraFastLensFrequency); % The expected number of 800 ps time bins within a single TAG lens oscillation
WrongLensPeriodicityReadings = ExpectedLensPeriodicityInBins .* 1.0001; % Periodicities higher by 0.01% of expected value are presumably outright wrong 

ExpectedGalvoPeriodicityInBins = 1 ./ (0.8e-9 .* GalvoFrequency); % The expected number of 800 ps time bins within a single TAG lens oscillation
WrongGalvoPeriodicityReadings = ExpectedGalvoPeriodicityInBins .* 1.2; % Periodicities higher by 20% of expected value are presumably outright wrong 


LegalHitsZ = cellfun(@(x) x(x<WrongLensPeriodicityReadings ), TotalHitsZ, 'UniformOutput',false);
LegalHitsX = cellfun(@(x) x(x<WrongGalvoPeriodicityReadings), TotalHitsX, 'UniformOutput',false);

% TotalHitsZ(TotalHitsZ>WrongLensPeriodicityReadings) = WrongLensPeriodicityReadings; % Dumping incorrect axial coordinates
% TotalHitsX(TotalHitsX>WrongGalvoPeriodicityReadings) = WrongGalvoPeriodicityReadings; % Dumping incorrect lateral coordinates


%% Raw image size

ShrinkFactorX = max(LegalHitsX{1}) ./ 1000;
ShrinkFactorZ = max(LegalHitsZ{1}) ./ 1000;

MaxX = round( max(LegalHitsX{1}) ./ ShrinkFactorX);
MaxZ = round( max(LegalHitsZ{1}) ./ ShrinkFactorZ);

RawImage = single(zeros(MaxX+1,MaxZ+1,max(NumFrames,1)));

RescaledZ = cellfun(@(x) floor(x ./ ShrinkFactorZ ) + 1, LegalHitsZ, 'UniformOutput',false);
RescaledX = cellfun(@(x) floor(x ./ ShrinkFactorX ) + 1, LegalHitsX, 'UniformOutput',false);

%% Populating the raw image

% Adding photons one at a time to the relevant voxel

for m = 1:NumFrames
    if numel(TotalHitsX{m})     
        for n = 1:numel(LegalHitsX{m})
%             RawImage(round(LegalHitsX{m}(n)./ShrinkFactorX) +1 ,   round(LegalHitsZ{m}(n)./ShrinkFactorZ)+1, m) = 1 + RawImage(round(LegalHitsX{m}(n)./ShrinkFactorX) +1 ,   round(LegalHitsZ{m}(n)./ShrinkFactorZ)+1, m);
            RawImage(RescaledX{m}(n), RescaledZ{m}(n), m) = 1 + RawImage(RescaledX{m}(n), RescaledZ{m}(n), m);
 
        end
    end
end
