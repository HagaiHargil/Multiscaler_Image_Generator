function [RawImage] = PhotonSpreadToImage3(CurrentEvents, EdgeX, EdgeY, EdgeZ)

%% Building a histogram of photon locations
Edges = {EdgeX ; EdgeY };
% RawImage = hist3(CurrentEvents, 'Edges', Edges);
% [RawImage,~,~] = histcounts2(CurrentEvents(:,1),CurrentEvents(:,2),EdgeX,EdgeY);
RawImage = histcn(CurrentEvents, EdgeX, EdgeY, EdgeZ);
%     RawImage = histcn(CurrentEvents, EdgeX, EdgeY);
end