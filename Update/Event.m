classdef Event
    properties
        absoluteTime
        channel
        edge
        preceedingLines % Every photon has a preceeding time event in all axes.
        sweep = []
        tagBit = []
        dataLost = []
        
    end
    
    properties (Dependent)
        relativeTime % actual relative time for photons for image generation
    end
    
    methods
        function obj = Event(absTime, chan, edge, swp, tagB, dataL)
            if nargin > 0
                obj.absoluteTime = absTime;
                obj.channel = chan;
                obj.edge = edge;
                obj.sweep = swp;
                obj.dataLost = dataL;
                obj.tagBit = tagB;
            end
        end
        
        function obj = set.channel(obj, channelNum)
            if ((channelNum == 1) || (channelNum == 2) ||...
            (channelNum == 3))
                obj.channel = channelNum;
            else
                error('Invalid channel number for this event.');
            end
        end
        
        function obj = set.preceedingLines(obj, relEdge)
            obj.preceedingLines = relEdge;
        end
        
        function relTime = get.relativeTime(obj)
            if exists(obj.preceedingLines)
                relTime = zeros(size(obj.preceedingLines, 1), 1);
                for n = 1:size(obj.preceedingLines, 1)
                    relTime(n) = obj.absoluteTime - obj.preceedingLines(n);
                end
            else
                error('This is not a photon and thus does not have relativeTime property.');
            end
        end
        
        function obj = set.relativeTime(obj, ~)
            error('You cannot set the relativeTime property. Make sure this event has absoluteTime and preceedingEdge set up.');
        end
        
    end
end
