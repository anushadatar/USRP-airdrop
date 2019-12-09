clear;
[rx, tx] = open_data('rx2.dat','tx.dat');

%%
plot(rx(100000:160000));
%%

%rx = trim_data(rx, 0.01);
%rx = rx(6400000:8500000); % rx4 trim
rx = rx(15300000:17400000); % rx2 trim
%rx = rx(14000000:16200000); % rx_10000_2 trim
%rx = rx(11700000:22000000); % rx_50000_2 trim
%rx = rx(6700000:17000000); % rx trim
%rx = rx(12200000:13300000);
%rx = rx(8600000:9000000);
%%
rx = rx(894000:900000);
%%
[phi, f_delta] = estimate_cfo(rx(20000:24000));
corrected_data = cfo_correct(rx(20000:24000), phi, f_delta);
%%
corrected = costas_loop(rx);
%%
errors = compute_errors(rx);
ds = compute_d(errors);
psi = compute_psi_hats(ds);
plot(ds);
%%
plot(rx)
%%
plot(rx, 'r.')
hold on
plot(real(corrected), imag(corrected),'b.');
%%

tx_bits = decode_data(tx);
rx_bits = decode_data(corrected_data);

%%
plot(rx)



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
    beta = 0.2;
    alpha = 0.01;
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

    
    
    
        
      
 
