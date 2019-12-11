function prepared_data = pack_data(compressed_data)
    % Pack data to prepare for transmission by adding known bits,
    % converting to complex numbers, and convolving with a pulse. Add zeros
    % to the end of the signal to maintain consistent signal length. 
    % Input : compressed_data = An array of individual bits to transmit.
    % Output: prepared_data = An array of packed data ready to convolve 
    %                         with a pulse and saved to a file. 
        
    % Final length that each transmission should be in total. 
    final_length = 100000;
    % Length in bits for data signal.
    known_data_length = 400;
    % Amplitude value for the signal overall. 
    amplitude = 0.5;
    % Length of the pulse to convolve the data bits with.
    pulse_length = 50;
    
    % Create known data vector.
    known_data = ones(1, known_data_length);
    % Set binary value of signal length.
    compressed_length = de2bi(length(compressed_data), 20, 'left-msb');
    % Create signal containing known data, length, then real data.
    known_compressed = horzcat(known_data, compressed_length, compressed_data);
    % Replace 0s with -1s.
    known_compressed(known_compressed == 0) = -1;
    % Pad remaining space in vector with 0s to meet final length. 
    packed_data = amplitude.*[known_compressed zeros(1,final_length-length(known_compressed))];

    % I contains odd bits, Q contains even bits.
    bits_I = packed_data(1:2:end);
    bits_Q = packed_data(2:2:end);
    % Store each symbol as a complex number. 
    m_k = (bits_I)+(1i*bits_Q);
    
    % Convolve and upsample with a pulse.
    p = ones(pulse_length,1);
    prepared_data = conv(upsample(m_k, pulse_length), p, 'same');
    
    % Ensure even length of signal.
    if mod(length(prepared_data), 2)
        prepared_data = [prepared_data 0];
    end
end