
[trimmed_w_known, trimmed_no_known] = trim_data('rx_sam.dat');
%% Run Costas Loop and plot the corrected data 
corrected = costas_loop(trimmed_w_known);
plot(real(corrected), imag(corrected),'b.'); 

%% Spin data by some angle and plot (this will eventually be integrated with rotate_dat)
angle = (3.*pi)./2;
spun_corrected=corrected.*exp(1i*angle);
   
plot(real(spun_corrected), imag(spun_corrected),'b.'); 
%% Sample data to get symbols
pulse_width = 20;

sampled_rx = sample_data(spun_corrected, pulse_width);
sampled_tx = sample_data(tx, pulse_width);

%% Decode symbols into individual bits
rx_bits = decode_data(sampled_rx); 
tx_bits = decode_data(sampled_tx);

%%
plot(rx_bits)
hold on
plot(tx_bits)

%% Check error between received and transmitted bits
error = size(rx_bits,1) - nnz(rx_bits+tx_bits) % this finds num of differences between tx and rx



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

function trimmed_data = trim_data(data, threshold)

    % Cut out data that is not from the transmission.
    % this can be improved with cross-correlation with noise?
    center_y = data; %(floor((size(y)/2)):end);
    magnitude = sqrt(real(center_y).^2 + imag(center_y).^2);
    trimmed_data = center_y(magnitude > threshold);

    plot(real(center_y)) % plot scrambled data
end

function decoded_data = decode_data(data)
    decoded_data = zeros(size(data,1).*2,1);
    
    for i = [1:1:size(data,1)]
        decoded_data(2.*i - 1, 1) = sign(real(data(i)));
        decoded_data(2.*i, 1) = sign(imag(data(i)));
    end
end

function corrected = costas_loop(data)
    beta = 2.5;
    alpha = 0.009;
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

    for i = [1:1:(size(data)./pulse_size)]
        if ((pulse_size./2)+(pulse_size.*i)) > size(data)
            sampled_data(i, 1) = 0;
        end
        sampled_data(i,1) = data((pulse_size./2)+((pulse_size.*i)));
    end
end        
 
        
        
    
    
    
    
    
        
      
 
