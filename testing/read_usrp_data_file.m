% Read the sent and received data files as interleaved real and 
% complex numbers. 

f1 = fopen('rx.dat', 'r');
tmp = fread(f1,'float32');
fclose(f1);
y = tmp(1:2:end)+1i*tmp(2:2:end);

f2 = fopen('tx.dat', 'r');
tmp2 = fread(f2,'float32');
fclose(f2);
x = tmp2(1:2:end)+1i*tmp2(2:2:end);

% Cut out data that is not from the transmission.
magnitude_threshold = 0.01;
center_y = y; %(floor((size(y)/2)):end);
magnitude = sqrt(real(center_y).^2 + imag(center_y).^2);
center_y = center_y(magnitude > magnitude_threshold);

plot(center_y)