function  data2photo(dataStream)
    % Converts bitstream into image.
    % Input: dataStream = Stream of bits associated with image.
    % Output: Displays image 

    size_row = bi2de(dataStream(1:10),'left-msb')
    size_col = bi2de(dataStream(11:20), 'left-msb')
    og_image = reshape(dataStream(21:end), size_row, size_col);
    imagesc(og_image)
end