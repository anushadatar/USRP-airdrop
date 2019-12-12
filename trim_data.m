function  [trimmed_w_known, trimmed_no_known, known_sig] = trim_data(rx, pulse_size)
    % Finds the start of the received signal in the received data, removes
    % noise prior to it, and removes the known bits. 
    % Input:  rx         = Received data signal vector. 
    %         pulse_size = The width of the pulse convolved with the data.
    % Output: trimmed_w_known  = Trimmed data with known bits included.
    %         trimmed_no_known = Trimmed data without known bits included.  
    
    %f1 = fopen(rx, 'r');
    %tmp = fread(f1,'float32');
    %fclose(f1);
    %rx = tmp(1:2:end)+1i*tmp(2:2:end);
    % Length of transmitted data file (based on pulse length of 50
    % and 100000 data points and 2 bits/symbol). 
    len_transmit = 25000000

    %full_sig = datastream
    %figure(1)
    %plot(real(rx))
    
    p = ones(pulse_size,1);
    x = conv(rx, p);
    %plot(real(x))
    t = linspace(0,20000,20000);
    %load('known_sig_5000.mat');
    %known_sig = x(8386000:8386000+80000);
    %known_sig = cos(10*pi*(.015)*t);
    
    known_sig = ones(200.*pulse_size,1)';
    [xCorr,lags] = xcorr(x,known_sig);
    % %best known signal for data 
    % %figure(2)
    % 
    % %plot(lags,xCorr)
    % %title('xcor')
    % %
    
    [~,I] = max(abs(xCorr));
    maxt = lags(I) + 1500
    new_rx = rx(maxt:len_transmit+maxt-1);
    newer_rx_no_known = rx(maxt+(200.*pulse_size):len_transmit+maxt-1);
    % figure(1)
    % hold on
    %figure(2)
    %plot(real(new_rx))
    %figure(3)
    %plot(real(newer_rx_no_known))
    % %
    
    %  filtered_data = newer_rx
    trimmed_w_known = new_rx;
    trimmed_no_known = newer_rx_no_known;
    
end