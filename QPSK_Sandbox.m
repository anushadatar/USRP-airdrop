%% Open RX and TX
clear
[rx, tx] = open_data('rx2.dat', 'tx_500_conv.dat');

%%
[trimmed_w_known, trimmed_no_known] = trim_data('rx.dat', 50); % this still doesn't call correctly from livescript

%% Run Costas Loop and plot the corrected data 
corrected = costas_loop(trimmed_w_known);

%% Spin data by some angle and plot (this will eventually be integrated with rotate_dat)
[spun_corrected, angle] = rotate_dat(corrected);

%% Sample data to get symbols
pulse_width = 500;
pulse = ones(pulse_width, 1);

sampled_rx = sample_data(spun_corrected, pulse_width);
sampled_tx = downsample(tx, pulse_width); 

%% Decode symbols into individual bits
rx_bits = decode_data(sampled_rx); 
tx_bits = decode_data(sampled_tx);

%%
plot(rx_bits(1:400))

%% Check error between received and transmitted bits
error = nnz(rx_bits(418:418+83940)+tx_bits(420:420+83940)) % this finds num of differences between tx and rx



function qpsk_signal = qpsk(data, fc)
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

function [rx, tx] = open_data(rx_filename, tx_filename)
    % open received data
    f1 = fopen(rx_filename, 'r');
    tmp = fread(f1,'float32');
    fclose(f1);
    rx = tmp(1:2:end)+1i*tmp(2:2:end);

    f2 = fopen(tx_filename, 'r');
    tmp2 = fread(f2,'float32');
    fclose(f2);
    tx = tmp2(1:2:end)+1i*tmp2(2:2:end);
end


function decoded_data = decode_data(data)
    decoded_data = zeros(size(data,1).*2,1);
    
    for i = [1:1:size(data,1)]
        decoded_data(2.*i - 1, 1) = sign(real(data(i)));
        decoded_data(2.*i, 1) = sign(imag(data(i)));
    end
end

function corrected = costas_loop(data)
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
    sampled_data = zeros(round(size(data)./pulse_size));
    offset = 150;

    for i = [1:1:(size(data)./pulse_size)-1]
        if (offset+(pulse_size.*i)) > size(data)
            sampled_data(i, 1) = 0;
        end
        sampled_data(i,1) = data(offset+((pulse_size.*i)));
    end
end        
 
        
        
    
    
    
    
    
        
      
 
