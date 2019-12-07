function  packet = photo2data(image_file)
    %input:  converts color photo to bw to sendable datastream
    %       image_file = "path_to_image.jpg"
    %   
    %output: 
    % im_size = array of row and column size
    % packet = concatonated binary data stream including size of picture and
    % data
    image = imread(image_file);
    bw_image =im2bw(image);
    [size_row size_col] = size(bw_image);
    im_size = [size_row size_col];
    dataStream = reshape(bw_image, 1, []);
    sizes = [de2bi(size_row,10, 'left-msb') de2bi(size_col,10, 'left-msb')];
    packet = horzcat(sizes, dataStream);
end
