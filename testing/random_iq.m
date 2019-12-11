N=1e5;
pulse_length = 100;
fname = 'tx.dat';
% make random sequence of bits
bits_I  = 0.5*sign(randn(N,1));
bits_Q = 0.5*sign(randn(N,1));
known = 0.5*ones(200,1) + 0.5*1i*ones(200,1);
m_k = bits_I+1i*bits_Q;
m_k_with_known = [known; m_k];
p = ones(pulse_length,1);
x = conv(upsample(m_k_with_known, pulse_length), p);
write_usrp_data_file_function(x, fname);