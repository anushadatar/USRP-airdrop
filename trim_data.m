function  filtered_data = trim_data(rx)
%function inputs recieved raw data and ouputs cleaned data with front end noise removed and "known bits" removed. 
%It also outputs the angle in which
%the data is rotated in the constellation for future correction. 
%input:  raw data stream. Vector 1xN
%   
%output: 
%  filetered data:  vector 1xM

%the known signal is 100 1s. 

% NOT FULLY WORKING YET
%goals:
%remove beginning noise find time in which data transmission starts
%find angle in which it is rotatated. 
    f1 = fopen(rx, 'r');
    tmp = fread(f1,'float32');
    fclose(f1);
    rx = tmp(1:2:end)+1i*tmp(2:2:end);
    len_transmit = 2e6

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

newer_rx = rx(maxt:len_transmit);

plot(real(new_rx))
%
 filtered_data = new_rx

end