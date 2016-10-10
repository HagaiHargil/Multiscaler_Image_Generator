function event = createSingleEvent(hexLine, dataFormat, range, hexToBinMap)
%% Script info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File name: "createSingleEvent.m"                             %
% Purpose: Receives a single data line and creates an instance %
% of the Event class out of it.                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initializations
lost = [];
sweep = [];
tag = [];

%%
binChannelEdge = hexToBinMap(hexLine(end));
edge = str2double(binChannelEdge(1));
channel = str2double(binChannelEdge(2:end));

%%
time = hex2dec(fliplr(hexLine(end-1:-1:end-(dataFormat.time / 4))));

%%
if dataFormat.otherThanTime ~= 0
    binOtherThanTime = hex2bin({hexLine(1:dataFormat.otherThanTime / 4)}, dataFormat.otherThanTime);
    if dataFormat.others(3) > 0 
        lost = bin2dec(binOtherThanTime(1));
        binOtherThanTime = binOtherThanTime(2:end);
    end
    if dataFormat.others(2) > 0
        tag = bin2dec(binOtherThanTime(1:dataFormat.others(2)));
        binOtherThanTime = binOtherThanTime(dataFormat.others(2) + 1:end);
    end
    if dataFormat.others(1) > 0
        sweep = bin2dec(binOtherThanTime(1:dataFormat.others(1)));
        time = time + ((sweep - 1) * range); % change the absolute time
    end
end

event = Event(time, channel, edge, sweep, tag, lost);

end