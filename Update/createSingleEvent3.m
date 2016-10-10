function event = createSingleEvent3(hexLine, hexToBinMap)
%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "createSingleEvent3.m"                            %
% Purpose: Receives a single data line and creates an instance %
% of the Event class out of it, specialized for timepatch = 3. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
binChannelEdge = hexToBinMap(hexLine(end));
edge = str2double(binChannelEdge(1));
channel = str2double(binChannelEdge(2:end));

%% Translating to hex following the binary representation because of the unique structure of 3
binVec = hex2bin({hexLine(1:end - 3)}, 60);
lost = binVec(1);
tag = hex2dec(binVec(2:6));
time = hex2dec(binVec(7:end));
event = Event(time, channel, edge, [], sweep, tag, lost);

end