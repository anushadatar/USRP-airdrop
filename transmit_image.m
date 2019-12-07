function[] = transmit_image(image_file, tx_filename)
    % obtain binary representation of photo
    packet = photo2data(image_file);
    % compress
    compressed_data = compress(packet);
    % add redundancy and known bits
    packed_data = pack_data(compressed_data);
    
    % prepared packed_data for transmission
    % replace 0s with -1s
    packed_data(packed_data == 0) = -1;
    % add extra bit if length is odd
    if mod(packed_data, 2) == 1
        packed_data = [packed_data -1];
    end
    % I contains odd bits, Q contains even bits
    bits_I = packed_data(1:2:end);
    bits_Q = packed_data(2:2:end);
    m_k = bits_I+j*bits_Q;
    % convolve with pulse
    pulse_length = 100;
    p = ones(pulse_length,1);
    x = conv(upsample(m_k, pulse_length), p);
    
    % write to file
    f1 = fopen(tx_filename, 'w');
    fwrite(f1, x, 'float32');
    fclose(f1);
end
