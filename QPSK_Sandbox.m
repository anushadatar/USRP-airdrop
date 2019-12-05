%% Compression
% sam and vivien
num_bits = 5e6;
data = [];

%%
for(i = 0:1:(num_bits./8))
    data = [data 0, 1, 2, 3];
end
    



% map complex number into phase-shifted cosine and sine components. 

% make time vector that corresponds to length of a symbol 
% correspond each symbol to a phase shift
% multiply shifted cosine by 
fc = 100000;
T = 1./fc;
t = T./99:T./99:T;
modulated = [];
real_part = [];
imag_part = [];

for(i= [1, 3, 5])
    in_phase = data(i).*cos(2.*pi.*fc.*t);
    quad_arm = data(i+1).*sin(2.*pi.*fc.*t);
    
    modulated = [modulated in_phase+quad_arm];
    
    real_part = [real_part data(i)];
    imag_part = [imag_part data(i+1)];
end

complex_nums(1, :) = real_part;
complex_nums(2, :) = imag_part;

%%
plot(modulated)
%% Export to file for transmit

% rip code from Siddhartan's examples that he sent us. 

f1 = fopen('tx_complex.dat', 'w');
fwrite(f1, complex_nums, 'float32');
fclose(f1);

f1 = fopen('tx_modulated.dat', 'w');
fwrite(f1, modulated, 'float32');
fclose(f1);

%% Fix Smearing

% open received data
f1 = fopen('rx2.dat', 'r');
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
center_y = center_y(1:300000,:);

plot(real(center_y)) % plot scrambled data

%% estimate phase offset

y_norm = center_y./(rms(abs(center_y)));
y_dtft = fftshift(fft(((y_norm).^4)));
plot(abs(real(y_dtft)));
%%

[M, I] = max(y_dtft);

phi = angle(M)./4; % angle of impulse

N = size(y_dtft, 1);
freqs = linspace(-pi, (pi-(2.*pi)./(N+1)), N);
f_delta = freqs(I)./4;

%% Demod?

indices = [0:1:length(center_y)-1];
exponentials = exp(-j.*((f_delta.*indices') + phi));
%%

demod_signal = center_y.*exponentials;


plot(imag(demod_signal))
