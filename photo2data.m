function  packet = photo2data(image_file)
    % Converts image file into data bits. In the process, it converts
    % color images and black and white images.
    % Input: image_file = String path to image file.
    %
    % Output: im_size = Array of row size and column size for the image.
    %         packet  = Concatenated binary data stream including both the
    %                   size of the picture in the first 20 bits and the 
    %                   data bits.

    image = imread(image_file);
    bw_image =im2bw(image);
    [size_row size_col] = size(bw_image);
    im_size = [size_row size_col];
    dataStream = reshape(bw_image, 1, []);
    sizes = [de2bi(size_row,10, 'left-msb') de2bi(size_col,10, 'left-msb')];
    packet = horzcat(sizes, dataStream);
end
