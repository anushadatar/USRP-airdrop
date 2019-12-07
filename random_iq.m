N=1e5;
pulse_length = 100;
fname = 'tx_100.dat';
% make random sequence of bits
bits_I  = sign(randn(N,1));
bits_Q = sign(randn(N,1));

m_k = bits_I+j*bits_Q;
p = ones(pulse_length,1);
x = conv(upsample(m_k, pulse_length), p);
write_usrp_data_file_function(x, fname);