function prepared_data = pack_data(compressed_data)
    % Pack data to prepare for transmission by adding known bits,
    % converting to complex numbers, and convolving with a pulse. Add zeros
    % to the end of the signal to maintain consistent signal length. 
    % Input : compressed_data = An array of individual bits to transmit.
    % Output: prepared_data = An array of packed data ready to convolve 
    %                         with a pulse and saved to a file. 
    
    % Current scheme (may need to be changed when 
    % 1:200 - known data (1s)
    % 201:220 - length of compressed data (in binary)
    % 221:(220+length(compressed_data)) - compressed data
    % rest is padding (0s)
    
    % Add known bits and pad the end with 0s to match the final length.
    final_length = 100000;
    % Length (in bits) of known bits for data signal.
    known_data_length = 200;
    % Amplitude value for the signal.
    amplitude = 0.5;
    % Length of the pulse to convolve the data bits with.
    pulse_length = 100;
    
    % Adjust length of signal.
    known_data = ones(1, known_data_length*2);

    compressed_length = de2bi(length(compressed_data), 20, 'left-msb');
    known_compressed = [known_data compressed_length compressed_data];

    % Replace 0s with -1s.
    known_compressed(known_compressed == 0) = -1;
    packed_data = [known_compressed zeros(1,final_length-length(known_compressed))];

    % I contains odd bits, Q contains even bits.
    bits_I = packed_data(1:2:end);
    bits_Q = packed_data(2:2:end);
    % Store each symbol as a complex number. 
    m_k = amplitude*bits_I+amplitude*1i*bits_Q;
    p = ones(pulse_length,1);
    prepared_data = conv(upsample(m_k, pulse_length), p);
    if mod(length(prepared_data), 2)
        prepared_data = [prepared_data 0];
    end
end