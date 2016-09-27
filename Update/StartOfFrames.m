function [startOfFrameVec, numOfFrames] = StartOfFrames(numOfFrames, use_slow_galvo_for_frames, mapPhotonArray);
    if use_slow_galvo_for_frames
        curKeys = keys(mapPhotonArray);
        minRows = 1e12;
        for n = cell2mat(curKeys)
            frameVec = mapPhotonArray(n).list;
            if size(frameVec, 1) < minRows
                minRows = size(frameVec, 1);
                minKey = n;
            end
        end
        startOfFrameVec = mapPhotonArray(minKey).list;
        numOfFrames = minRows - 1;
    else
        curKeys = keys(mapPhotonArray);
        photonsInFrame = mapPhotonArray(curKeys{1}).list; % just a default, we care about the photons
        startOfFrameVec = linspace(photonsInFrame(1,1), photonsInFrame(end,2), numOfFrames + 1)';
    end
end