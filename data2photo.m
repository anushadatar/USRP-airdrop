function  data2photo(dataStream)
    % converts bitstream into image
    %input:  Photo file 
    %        = output of data2photo includes size of image and data
    %output: bit stream

    size_row = bi2de(dataStream(1:10),'left-msb')
    size_col = bi2de(dataStream(11:20), 'left-msb')
    og_image = reshape(dataStream(21:end), size_row, size_col);
    imagesc(og_image)


end