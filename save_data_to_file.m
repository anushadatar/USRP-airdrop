function[] = save_data_to_file(packed_data, tx_filename)    
    % Save packed data to a file ready for transmit.
    % Input: packed_data = Bits prepared for transmission, with known.
    %        tx_filename = Path to file to store transmit information in.
    % Output: Saves packed_data to file at tx_filename.
    % Write to file with specified filename.
    f1 = fopen(tx_filename, 'w');
    fwrite(f1, packed_data, 'float32');
    fclose(f1);
end
