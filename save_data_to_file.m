function[] = save_data_to_file(packed_data, tx_filename)    
    % Save packed data to 
    % Amplitude value for the signal.
    amplitude = 0.5;
    % Replace 0s with -1s.
    packed_data(packed_data == 0) = -1;
    
    % I contains odd bits, Q contains even bits
    bits_I = packed_data(1:2:end);
    bits_Q = packed_data(2:2:end);
    m_k = amplitude*bits_I+j*bits_Q;
    % Convolve the data bits with a pulse.
    pulse_length = 20;
    p = ones(pulse_length,1);
    x = conv(upsample(m_k, pulse_length), p);
    
    % write to file
    f1 = fopen(tx_filename, 'w');
    fwrite(f1, x, 'float32');
    fclose(f1);
end
