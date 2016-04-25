function [RawImage] = PhotonSpreadToImage2(CurrentEvents, SizeX, SizeY, EdgeX, EdgeY)

%% Building a histogram of photon locations
Edges = {EdgeX EdgeY};
RawImage = hist3(CurrentEvents, 'Edges', Edges);

end