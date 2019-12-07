N=5e5;
pulse_length = 20;
fname = 'tx_20.dat';
% make random sequence of bits
bits_I  = sign(randn(N,1));
bits_Q = sign(randn(N,1));

m_k = bits_I+1i*bits_Q;
p = ones(pulse_length,1);
x = conv(upsample(m_k, pulse_length), p);
write_usrp_data_file_function(x, fname);