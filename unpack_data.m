function unpacked_data = unpack_data(rx_filename)
    % TODO: Grab data from file, remove redundancy.
    rx_file = fopen(rx_filename, 'r');
    raw_rx_data = fread(rx_file,'float32');
    fclose(f1);
    % Add real and complex values for each data point from the saved file.
    data_points = raw_rx_data(1:2:end)+1i*raw_rx_data(2:2:end);
    % TODO: All of the part that is actual work - 
        % Decode none bits to find phase offset
        % Magnitude/temporal error correction
        % Removal of redundancy
   
    cleared_data = data_points;
    unpacked_data = zeros(2*length(data_points));
    for index = 1 : length(N)
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
end