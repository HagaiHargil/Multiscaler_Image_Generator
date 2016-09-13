OutputFileName = strcat('MultiscalerMovie-', FileName(1:end-3),'mat' );
clear PMT_Dataset Binary_Data; % To avoid the -v7.3 switch
save(OutputFileName, '-v7.3'); % -v7.3 switch needed after all

TiffFileName = strcat(OutputFileName(1:end-3),'tif' );

SizeZ = SizeX;
for n=1:SizeZ
    imwrite(squeeze(uint16(RawImagesMat{3}(:,:,n))), TiffFileName, 'Tiff', 'WriteMode', 'append');
end
