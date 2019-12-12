function[] = receive_image(rx_filename)
    % Process the data captured by the receiver to display the image.
    % Input: rx_filename = The path to the file with received data.
    % Output: Shows an image decoded from the captured information. 
    
    % Unpack data using filename, correct for error across the channel.
    unpacked_data = unpack_data(rx_filename);
    % Run the decompression algorithm to recover the image.
    decompressed_data = decompress(unpacked_data);
    % Convert the decompressed data to an actual image. 
    data2photo(decompressed_data);
end