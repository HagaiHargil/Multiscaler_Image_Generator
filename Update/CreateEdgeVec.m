function mapPhotonArray = CreateEdgeVec(imageSize, mapPhotonArray, use_slow_galvo_for_frames)
%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "CreateEdgeVec.m"                                 %
% Purpose: Adds a field to the struct photons that contains    %
% the relevant edge vector for the data field.                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

curImageSize = 1;
for n = cell2mat(keys(mapPhotonArray))
    photons = mapPhotonArray(n);
    if n == 5 % TAG lens channel receives special treatment.
        photons.edge = linspace(-1, 1, imageSize(3)); % Z is always for TAG
        mapPhotonArray(n) = photons;
    elseif (n == 3 || n == 4) 
        if use_slow_galvo_for_frames % Galvo channels that are used for frames
            photons.edge = linspace(photons.list(1,2), photons.list(end, 2), imageSize(curImageSize));
            photons.thisIsFrame = 1;
            mapPhotonArray(n) = photons;
        else
            photons.edge = linspace(0, photons.maxDiffOfLines, imageSize(curImageSize));
            mapPhotonArray(n) = photons;
            curImageSize = curImageSize + 1;
        end
    end
end
end