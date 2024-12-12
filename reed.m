function output = reed(note, Fs)

freq =440 * 2^((note-69)/12);
t = (1:Fs)/Fs;
y = square(2*pi*t*freq);

G = 0.15;
w0 = freq*pi;
Q =0.9;
K = 2*Fs;
n = G*[1, 2*K, 1];
d= [K^2/w0^2 + K/(Q*w0)+1, 2-2*K^2/w0^2, K^2/w0^2-K/(Q*w0)+1];

z = filter(n,d, y);
output = z/(max(z));