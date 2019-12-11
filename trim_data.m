function  [trimmed_w_known, trimmed_no_known] = trim_data(rx)
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
    len_transmit = 2500050

%full_sig = datastream
%figure(1)
%plot(real(rx))
p = ones(50,1);
x = conv(rx, p);
plot(real(x))
t = linspace(0,20000,20000);
load('known_sig.mat');
%known_sig = cos(10*pi*(.015)*t);
% known_sig = ones(4000,1)';
[xCorr,lags] = xcorr(x,known_sig);
% %best known signal for data 
% %figure(2)
% 
% %plot(lags,xCorr)
% %title('xcor')
% %
[~,I] = max(abs(xCorr));
maxt = lags(I)
new_rx = rx(maxt:len_transmit+maxt-1);
newer_rx_no_known = rx(maxt+10000:len_transmit+maxt-1);
% figure(1)
% hold on
figure(2)
plot(real(new_rx))
figure(3)
plot(real(newer_rx_no_known))
% %
%  filtered_data = newer_rx
trimmed_w_known = new_rx;
trimmed_no_known = newer_rx_no_known;

end