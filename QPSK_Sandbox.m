%% Mock QPSK to show concept
data = [-1, 1, -1, -1, 1, -1, 1, 1]; % bits to modulate (1 and -1)
fc = 100000; % center frequency

clear;
[rx, tx] = open_data('rx2.dat','tx.dat');

rx = trim_data(rx, 0.01);

[phi, f_delta] = estimate_cfo(rx);
corrected_data = cfo_correct_looping(rx);


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

    phi = angle(M)./4; % angle of impulse

    N = size(y_dtft, 1);
    freqs = linspace(-pi, (pi-(2.*pi)./(N+1)), N);
    f_delta = freqs(I)./4; % center frequency offset
end
%% Correct for Center Frequency Offset

function corrected_signal = cfo_correct(data, phi, f_delta)
    indices = [0:1:length(data)-1];
    exponentials = exp(-j.*((f_delta.*indices') + phi));

    corrected_signal = data.*exponentials;
end

function corrected_data = cfo_correct_looping(data)
    corrected_data = [];
    for i = [1:length(data)./100:length(data)]
        data_section = data(i:i+length(data)./100-1);
        [phi, f_delta] = estimate_cfo(data_section);
        corrected_section = cfo_correct(data_section, phi, f_delta);
        
        corrected_data = [corrected_data corrected_section];
    end
    
    plot(real(corrected_data), imag(corrected_data), '.')
    

end
 
