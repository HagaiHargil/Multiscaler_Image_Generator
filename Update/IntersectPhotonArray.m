function mapPhotonArray = IntersectPhotonArray(mapPhotonArray)
%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "IntersectPhotonArray.m"                          %
% Purpose: Finds the photons that are in common to all data    %
% vectors and keeps only them.                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Extract data to simple arrays
for n = cell2mat(keys(mapPhotonArray))
    helpMat1 = mapPhotonArray(n).list;
    if n ~= 5 % not TAG data
        helpMat1(:,1) = helpMat1(:,1) + helpMat1(:,2);
    end
    helpMat2{n} = helpMat1;
end
helpMat2(cellfun(@isempty, helpMat2)) = [];

%% Determine the photon num
minRows = 1e12;
dataChannels = [];
for n = 1:size(helpMat2, 2)
    if size(helpMat2{n}, 1) < minRows
        minRows = size(helpMat2{n}, 1);
        minChannelNum = n;
    end
    dataChannels = [dataChannels n];
end

dataChannels(minChannelNum) = [];
%% We'll intersect the minimum number of photons channel with all others

for n = dataChannels
    [~, indexInOne, indexInTwo] = intersect(helpMat2{minChannelNum}, helpMat2{n});
    helpMat2{minChannelNum} = helpMat2{minChannelNum}(indexInOne, :); % Only leaves the intersected indices
    helpMat2{n} = helpMat2{n}(indexInTwo, :);
end

i = 1;
for n = cell2mat(keys(mapPhotonArray))
    photons = mapPhotonArray(n);
    if n ~= 5
        helpMat2{i}(:,1) = helpMat2{i}(:,1) - helpMat2{i}(:,2);
    end
    photons.list = helpMat2{i};
    mapPhotonArray(n) = photons;
    i = i+1;
end