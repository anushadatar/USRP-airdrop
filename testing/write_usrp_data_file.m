% Create a sample QPSK data file to transmit and receive. 

% Number of times to repeat each symbol. 
len = 1e6;
x = ones(len, 1);

tmp = zeros(4*len,1);
tmp(1:2:len) = 1;
tmp(2:2:len) = 1;
tmp(len:2:2*len) = 1;
tmp(len+1:2:2*len) = -1;
tmp(2*len:2:3*len) = -1;
tmp(2*len+1:2:3*len) = 1;
tmp(3*len:2:4*len) = -1;
tmp(3*len+1:2:4*len) = -1;

f1 = fopen('tx.dat', 'w');
fwrite(f1, tmp, 'float32');
fclose(f1);
