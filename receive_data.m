% Testing code to view received data and validate correction. 
% rx_filename = 'rx_chicken.dat';
% pulse_width = 500;
% % % % % % %%
% [rx, tx] = open_data(rx_filename, 'tx_500_conv.dat');
% % % %%
% corrected = costas_loop(rx);
% %%
% plot(real(corrected))
% % [trimmed_w_known, trimmed_no_known] = trim_data(corrected, pulse_width);
% % [spun_corrected, angle] = rotate_dat(corrected);
% % % 
% % plot(real(spun_corrected))

function receive_data(rx_filename, pulse_width)
    % Process the received data file to extract the image.
    % Input:  rx_filename = The received data file.
    %         pulse_width = The width of the pulse convolved with the data.
    % Output: Displays the photo decoded from the data.
    
    [rx] = open_data(rx_filename);
    % Use a costas loop to correct for frequency error.
    corrected = costas_loop(rx);

    % Trim data to only include transmission
    [trimmed_w_known, trimmed_no_known] = trim_data(corrected, pulse_width); 
    
    % DEBUG: Run Costas Loop and plot the corrected data
    %corrected = costas_loop(trimmed_w_known);

    % Rotate data based on the angle of the offset from the original 
    % constellation (found using rotate_dat).
    [spun_corrected, angle] = rotate_dat(trimmed_w_known);
    
    % DEBUG: Check for rotation.
    %figure(3)
    %plot(real(spun_corrected));

    % Sample data to get symbols.
    sampled_rx = sample_data(spun_corrected, pulse_width);
    sampled_tx = downsample(tx, pulse_width);

    % Decode symbols into individual bits.
    rx_bits = decode_data(sampled_rx);
    tx_bits = decode_data(sampled_tx);
    % Convert bits to 0 and 1 (binary data) instead of 1 and -1.
    rx_bits(rx_bits == -1) = 0;

    % Find start indices in rx bits to determine data location 
    start_indices = find(~rx_bits);
    
    if start_indices(1) > 350
        start_index = start_indices(1)
        indices = 1
    elseif start_indices(2) > 350
        start_index = start_indices(2)
        indices = 2
    elseif start_indices(3) > 350
        start_index = start_indices(3)
        indices = 3
    else 
        start_index = start_indices(4)
        indices = 4
    end
    % Get data bits following start index.
    rx_bits = rx_bits(start_index:end);
    % Find length of actual data based on value encoded in housekeeping 
    % bits. Only account for and decompress the number of data points in
    % the actual image, as the remaining points are filler.
    data_length_binary = rx_bits(1:20);
    data_length = bi2de(data_length_binary', 'left-msb')
    unpacked_data = rx_bits(21:21+data_length-1);
    % Decompress bits and display the image!
    data2photo(decompress(unpacked_data')); 
end

function qpsk_signal = qpsk(data, fc)
    % Generate a qpsk signal.
    % Input:  data        = Data to encode in signal.
    %         fc          = Center frequency of the signal.
    % Output: qpsk_signal = The generated QPSK signal. 
    T = 1./fc; % period
    t = T./99:T./99:T; % time vector

    modulated = [];

    for(i= [1, 3, 5])
        in_phase = data(i).*cos(2.*pi.*fc.*t);
        quad_arm = data(i+1).*sin(2.*pi.*fc.*t);
    
        qpsk_signal = [modulated in_phase+quad_arm];
    end
    plot(qpsk_signal) % plot modulated signal to show phase shifts
end

function rx = open_data(rx_filename)
    % Open received data file (and, if needed for debug, transmit file). 
    % Input:  rx_filename = Filename of .dat file with received data.
    % Output: rx          = Data vector from rx file.
    
    % Open received data file.
    f1 = fopen(rx_filename, 'r');
    tmp = fread(f1,'float32');
    fclose(f1);
    rx = tmp(1:2:end)+1i*tmp(2:2:end);
end


function decoded_data = decode_data(data)
    % Decode the data vector based on a QPSK modulation scheme.
    % Output should be two times as long as the input.
    % Input:  data = Data vector containing complex QPSK symbols.
    % Output: decoded_data = Data vector containing real bits. 
    
    decoded_data = zeros(size(data,1).*2,1);
    
    for i = [1:1:size(data,1)]
        decoded_data(2.*i - 1, 1) = sign(real(data(i)));
        decoded_data(2.*i, 1) = sign(imag(data(i)));
    end
end

function corrected = costas_loop(data)
    % Costas loop function that uses a PI controller to account for
    % frequency-domain QPSK smearing
    % Input:  data      = The data vector to correct.
    % Output: corrected = The data vector corrected for frequency error.
    
    beta = 3;
    alpha = 0.01;
    error_sum = 0;
    psi_hat = 0;
    corrected = zeros(size(data));
    
    %rms_data = data./(rms(abs(data)));
    rms_data = data;
    
    for k = [1:1:size(data,1)]
        corrected(k) = rms_data(k).*exp(1i.*psi_hat);
        
        error = -(sign(real(corrected(k))).*imag(corrected(k))) + (sign(imag(corrected(k))).*real(corrected(k)));
        
        error_sum = error_sum + error;
        
        d = (beta.*error) + (alpha.*error_sum);
        
        psi_hat = psi_hat + d;
        
        if psi_hat < -pi
            psi_hat = psi_hat + (2.*pi);
        end
        
        if psi_hat > pi
            psi_hat = psi_hat - (2.*pi);
        end
        
    end
end

function sampled_data = sample_data(data, pulse_size)
    % Sample points from the data vector based on the size of the pulse.
    % Removes redundancy associated with pulse size to show actual bits.
    % Input:  data       = Data vector, corrected for frequency and phase.
    %         pulse_size = Size of the pulse convolved with data bits.
    % Ouput:  sampled_data = Data sampled at a single point for each pulse.
    
    sampled_data = zeros(round(size(data)./pulse_size));
    offset = 150;

    for i = [1:1:(size(data)./pulse_size)-1]
        if (offset+(pulse_size.*i)) > size(data)
            sampled_data(i, 1) = 0;
        end
        sampled_data(i,1) = data(offset+((pulse_size.*i)));
    end
end        
 
        
        
    
    
    
    
    
        
      
 
