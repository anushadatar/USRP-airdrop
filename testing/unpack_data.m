function unpacked_data = unpack_data(rx_filename)
    % Unpacks received file from B210 radio to reveal bits originally
    % transmitted. 
    % Input :  rx_filename   = Path to file containing the recevied data.
    % Output : unpacked_data = Image file data, still compressed. 
    
    rx_file = fopen(rx_filename, 'r');
    raw_rx_data = fread(rx_file,'float32');
    fclose(rx_file);
    % Add real and complex values for each data point from the saved file.%
    cleared_data = raw_rx_data(1:2:end)+1i*raw_rx_data(2:2:end);
%    [trimmed_w_known, trimmed_no_known] = trim_data(rx_filename, 50); % this still doesn't call correctly from livescript


    % From here on, we assume that we have data that is made up of complex
    % numbers containing first the known data, then 
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
    % Assumes that known data is 400 bits (200 real and 200 imaginary) and
    % includes 20 bits of the size of the actual signal.
    data_length_binary = unpacked_data(401:420);
    data_length = bi2de(data_length_binary', 'left-msb');
    % Actual unpack data to return to the main function.
    unpacked_data = unpacked_data(420:420+data_length);
end
