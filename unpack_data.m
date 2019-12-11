function unpacked_data = unpack_data(rx_filename)
    rx_file = fopen(rx_filename, 'r');
    raw_rx_data = fread(rx_file,'float32');
    fclose(rx_file);
    % Add real and complex values for each data point from the saved file.%
    cleared_data = raw_rx_data(1:2:end)+1i*raw_rx_data(2:2:end);
    % TODO: All of the part that is actual work - 
        % Decode none bits to find phase offset
        % Magnitude/temporal error correction
    unpacked_data = zeros(2*length(cleared_data), 1);
    for index = 1 : length(cleared_data)
        if real(cleared_data(index)) > 0
            unpacked_data(2*index-1) = 1;
            if imag(cleared_data(index)) > 0
                unpacked_data(2*index) = 1;
            else
                unpacked_data(2*index) = 0;
            end
        else
            unpacked_data(2*index-1) = 0;
            if imag(cleared_data(index)) > 0
                unpacked_data(2*index) = 1;
            else
                unpacked_data(2*index) = 0;
            end
        end
    end
    disp(length(unpacked_data));
    % assumes that unpacked data includes known bits
    data_length_binary = unpacked_data(401:420);
    disp(size(data_length_binary))
    disp(data_length_binary)
    data_length = bi2de(data_length_binary', 'left-msb');
    disp(data_length);
    unpacked_data = unpacked_data(420:420+data_length);
end
