function[] = transmit_image(image_file, tx_filename)
    % Prepare a file to send the image using the transmitter.
    % Input: image_file  = The path to the image file to save the data of.
    %        tx_filename = The path to the file to save the transmit data to.
    %
    % Output: Saves the image data to the tx file. 

    % Create a binary representation of the photo.
    packet = photo2data(image_file);
    % Compress the data.
    compressed_data = compress(packet);
    % Add redundancy and known bits.
    packed_data = pack_data(compressed_data);
    % Save the data to the specified file location.
    write_usrp_data_file(packed_data, tx_filename);
end
