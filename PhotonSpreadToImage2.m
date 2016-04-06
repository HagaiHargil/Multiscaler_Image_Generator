
<<<<<<< HEAD
ShrinkFactorX = max(TotalHitsX(:)) ./ 1000;
=======
ShrinkFactorX = 1e1;
>>>>>>> ae1361fcb70c63a6278f69e48ba987a75ba20bba

MaxX = round( max(TotalHitsX(:)) ./ ShrinkFactorX);
MaxZ = max(TotalHitsZ(:));

RawImage = (zeros(MaxX+3,MaxZ+3));

for m = 1:numel(TotalHitsX)
    RawImage(round(TotalHitsX(m)./ShrinkFactorX) +1 ,   TotalHitsZ(m)+1) = RawImage(round(TotalHitsX(m)./ShrinkFactorX) +1,    TotalHitsZ(m)+1 ) + 1;
end