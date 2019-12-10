clear;
[rx, tx] = open_data('rx.dat','tx_20.dat');
%%
trimmed = trim_data('rx.dat');
%%
pulse_size = 20; % this is trying to sample at the center of each pulse, you don't need to run this
sampled_rx = zeros(round(size(trimmed)./pulse_size)-1);

for i = [1:1:(size(rx)./pulse_size)]
    sampled_rx(i,1) = trimmed((pulse_size./2)+(pulse_size.*i));
end
%%
alt_corrected = alt_costas_loop(rx);
   
plot(rx, 'r.')
hold on
plot(real(alt_corrected), imag(alt_corrected),'b.'); % plot uncorrected and corrected data to see difference
%%

rx_bits = decode_data(alt_corrected); % this takes the corrected symbols and turns them into bits
tx_bits = decode_data(sampled_tx);
%%
error = nnz(rx_bits+tx_bits) % this finds num of differences between tx and rx



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

%% Estimate Center Frequency Offset and Angle

function [phi, f_delta] = estimate_cfo(data)
    y_norm = data./(rms(abs(data)));
    y_dtft = fftshift(fft(((y_norm).^4)));

    [M, I] = max(y_dtft);

    phi = (angle(M)+pi)./4; % angle of impulse

    N = size(y_dtft, 1);
    freqs = linspace(-pi, (pi-(2.*pi)./(N+1)), N);
    f_delta = freqs(I)./4; % center frequency offset
end
%% Correct for Center Frequency Offset

function corrected_signal = cfo_correct(data, phi, f_delta)
    indices = [0:1:length(data)];
    exponentials = exp(-j.*((f_delta.*indices') + phi));

    corrected_signal = data.*exponentials;
    
    plot(real(corrected_signal), imag(corrected_signal), '.');
end

function corrected_data = cfo_correct_looping(data)
    corrected_data = [];
    for i = [1:200:length(data)]
        if i>(length(data)-199)
            data_section = data(i:length(data));
        else
            data_section = data(i:(i+199));
        end
        
        [phi, f_delta] = estimate_cfo(data_section);
        corrected_section = cfo_correct(data_section, phi, f_delta);
        
        corrected_data = vertcat(corrected_data, corrected_section);
    end
    
    plot(real(corrected_data), imag(corrected_data), '.')
    

end

function decoded_data = decode_data(data)
    decoded_data = [];
    for i = [1:1:size(data,1)]
        decoded_symbol = [sign(real(data(i))), sign(imag(data(i)))];
        decoded_data = [decoded_data decoded_symbol];
    end
end

function errors = compute_errors(data)
    errors = ones(size(data));
    
    for i = [1:1:size(data)]
        x_hat = data(i);
    
        real_term = -(sign(real(x_hat)).*imag(x_hat));
        imag_term = sign(imag(x_hat)).*real(x_hat);
    
        error = real_term + imag_term;
    
        errors(i) = error;
    end
end

function ds = compute_d(errors)
    beta = 0.1;
    alpha = 0.05;
    ds = ones(size(errors));
    
    for i = [1:1:size(errors, 1)]
        ds(i) = beta.*errors(i) + alpha.*sum(errors(1:i));
    end
end

function psi_hats = compute_psi_hats(ds)
    psi_hats = ones(size(ds));
    psi_hats(1) = 0;
    
    for i = [1:1:size(psi_hats, 1)-1]
        psi_hats(i+1) = psi_hats(i) + ds(i);
        
        if(psi_hats(i+1)<-pi)
            psi_hats(i+1) = psi_hats(i+1) + (2.*pi);
        end
        
        if(psi_hats(i+1)>pi)
            psi_hats(i+1) = psi_hats(i+1) - (2.*pi);
        end
        
    end
end 

function corrected = correct_cfo(data, psi_hats)
    corrected = ones(size(data));
    
    for i = [1:1:size(data,1)]
        corrected(i) = data(i).*exp(j.*(psi_hats(i)));
    end
end

function corrected = costas_loop(data);
    rms_data = data; %./(rms(abs(data)));
    errors = compute_errors(rms_data);
    ds = compute_d(errors);
    psi_hats = compute_psi_hats(ds);
        
    corrected = correct_cfo(rms_data, psi_hats);
end

function alt_corrected = alt_costas_loop(data)
    beta = 2;
    alpha = 0.009;
    error_sum = 0;
    psi_hat = 0;
    alt_corrected = zeros(size(data));
    
    %rms_data = data./(rms(abs(data)));
    rms_data = data;
    
    for k = [1:1:size(data,1)]
        alt_corrected(k) = rms_data(k).*exp(1i.*psi_hat);
        
        error = -(sign(real(alt_corrected(k))).*imag(alt_corrected(k))) + (sign(imag(alt_corrected(k))).*real(alt_corrected(k)));
        
        error_sum = error_sum + error;
        
        d = (beta.*error) + (alpha.*error_sum);
        
        psi_hat = psi_hat + d;
        
        if psi_hat < -pi
            psi_hat = psi_hat + (2.*pi);
        end
        
        if psi_hat > pi
            psi_hat = psi_hat - (2.*pi);
        end
        
        %alt_corrected(k) = rms_data(k).*exp(1i.*psi_hat);
    end
end
        
 
        
        
    
    
    
    
    
        
      
 
