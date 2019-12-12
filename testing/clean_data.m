function  filtered_data = clean_data(rx)
% Reads in received raw file data and removes noise from prior to
% transmission and the known bits. Also calculates angle of the rotation of
% the constellation from the channel for further correction/
% Input:  rx            = Received data from transmission 
% Output: filtered_data = Filtered information from the file.
%the known signal is 100 1s. 

% NOT FULLY WORKING YET
%goals:
%remove beginning noise find time in which data transmission starts
%find angle in which it is rotatated. 
    f1 = fopen(rx, 'r');
    tmp = fread(f1,'float32');
    fclose(f1);
    rx = tmp(1:2:end)+1i*tmp(2:2:end);

%full_sig = datastream
%figure(1)
%plot(real(rx))
known_sig = ones(100,1)';
[xCorr,lags] = xcorr(rx,known_sig);

%figure(2)

%plot(lags,xCorr)
%title('xcor')
%
[~,I] = max(abs(xCorr));
maxt = lags(I);
new_rx = rx(maxt-20000:end);

%newer_rx = rx(maxt:length of transmission;

plot(real(new_rx))
%
 filtered_data = new_rx

end