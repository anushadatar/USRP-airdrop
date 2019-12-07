function  [filtered_data, rotate_angle] = process_known(rx)
%function inputs recieved raw data and ouputs cleaned data with front end noise removed and "known bits" removed. 
%It also outputs the angle in which
%the data is rotated in the constellation for future correction. 
%input:  raw data stream. Vector 1xN
%   
%output: 
%  filetered data:  vector 1xM
%  rotate_angle: angle in radians

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
figure(1)
plot(real(rx))
known_sig = ones(100,1)'
full_sig = horzcat(rand(2000,1)', known_sig+ .5*rand(1))

full_sig = horzcat(full_sig, rand(2000,1)')
[xCorr,lags] = xcorr(full_sig,known_sig);

figure(2)

plot(lags,xCorr)
title('xcor')
% 
% [~,I] = max(abs(xCorr));
% maxt = lags(I);
% new_rx = rx(maxt-20:end);
% [xCorr_end,lags_end] = xcorr(real(new_rx),real(rx(1:1000)));
% [~,I_end] = max(abs(xCorr_end));
% maxt_end = lags(I_end);
% figure(3)
% 
% plot(lags_end,xCorr_end)
% title('end xcorr')
% figure(4)
% hold on
% title('compare')
% plot(real(rx))
% plot(real(new_rx))
% 
% rotate_angle = maxt
% filtered_data = maxt_end

end