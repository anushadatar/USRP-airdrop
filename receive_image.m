function[] = receive_image(rx_filename)
    % Unpack data using filename, correct for error across the channel.
    unpacked_data = unpack_data(rx_filename);
    % Run the decompression algorithm to recover the image.
    decompressed_data = decompress(unpacked_data);
    % Convert the decompressed data to an actual image. 
    data2photo(decompressed_data);
end