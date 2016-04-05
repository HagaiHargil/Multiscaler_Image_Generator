
ShrinkFactorX = 1e1;

MaxX = round( max(TotalHitsX(:)) ./ ShrinkFactorX);
MaxZ = max(TotalHitsZ(:));

RawImage = (zeros(MaxX+3,MaxZ+3));

for m = 1:numel(TotalHitsX)
    RawImage(round(TotalHitsX(m)./ShrinkFactorX) +1 ,   TotalHitsZ(m)+1) = RawImage(round(TotalHitsX(m)./ShrinkFactorX) +1,    TotalHitsZ(m)+1 ) + 1;
end