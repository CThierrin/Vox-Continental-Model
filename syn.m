Fs = 44100; %sample frequency
note_8 = 69; %MIDI note
drawbar = [6, 8, 6, 5, 8, 6]; %drawbar settings

drawbar_amplitude = [0.001348963, 0.001659587, 0.001659587, 0.002018366, 0.002344229, 0.002754229, 0.003548134, 0.004897788, 0.00616595, 0.007413102, 0.013489629, 0.022387211, 0.034276779, 0.053088444, 0.078523563, 0.112201845];

%Calculate pitches of other ranks
note_16 = note_8 - 12;
note_4 = note_8 +12;

note_IV_1 = note_8 + 7+ 12;
note_IV_2 = note_8 + 24;
note_IV_3 = note_8 + 24 + 4;
note_IV_4 = note_8 + 36;

%Reed tone
reed_output_8 = reed(note_8, Fs);
reed_output_16 = reed(note_16, Fs);
reed_output_4 = reed(note_4, Fs);

reed_output_IV_1 = reed(note_IV_1, Fs);
reed_output_IV_2 = reed(note_IV_2, Fs);
reed_output_IV_3 = reed(note_IV_3, Fs);
reed_output_IV_4 = reed(note_IV_4, Fs);

%Filter coefficients for foundation
K = 2*Fs;
n = [1, 2*K, 1];
RC = 0.0005;
d =[RC^2*K^2+3*RC*K+1, 1-2*RC^2*K^2, RC^2*K^2-3*RC*K+1];

flute_output_8 = filter(n,d,reed_output_8);
flute_output_16 = filter(n,d,reed_output_16);
flute_output_4 = filter(n,d,reed_output_4);

flute_output_IV_1 = filter(n,d,reed_output_IV_1);
flute_output_IV_2 = filter(n,d,reed_output_IV_2);
flute_output_IV_3 = filter(n,d,reed_output_IV_3);
flute_output_IV_4 = filter(n,d,reed_output_IV_4);

%adjust volume based on drawbars
flute_output_8 = flute_output_8/max(flute_output_8) * drawbar_amplitude(drawbar(2) + drawbar(5));
flute_output_16 = flute_output_16/max(flute_output_16) * drawbar_amplitude(drawbar(1) + drawbar(5));
flute_output_4 = flute_output_4/max(flute_output_4) * drawbar_amplitude(drawbar(3) + drawbar(5));

flute_output_IV_1 = flute_output_IV_1/max(flute_output_IV_1) * drawbar_amplitude(drawbar(4) + drawbar(5));
flute_output_IV_2 = flute_output_IV_2/max(flute_output_IV_2) * drawbar_amplitude(drawbar(4) + drawbar(5));
flute_output_IV_3 = flute_output_IV_3/max(flute_output_IV_3) * drawbar_amplitude(drawbar(4) + drawbar(5));
flute_output_IV_4 = flute_output_IV_4/max(flute_output_IV_4) * drawbar_amplitude(drawbar(4) + drawbar(5));

reed_output_8 = reed_output_8 * drawbar_amplitude(drawbar(2) + drawbar(6));
reed_output_16 = reed_output_16 * drawbar_amplitude(drawbar(1) + drawbar(6));
reed_output_4 = reed_output_4 * drawbar_amplitude(drawbar(3) + drawbar(6));

reed_output_IV_1 = reed_output_IV_1 * drawbar_amplitude(drawbar(4) + drawbar(6));
reed_output_IV_2 = reed_output_IV_2 * drawbar_amplitude(drawbar(4) + drawbar(6));
reed_output_IV_3 = reed_output_IV_3 * drawbar_amplitude(drawbar(4) + drawbar(6));
reed_output_IV_4 = reed_output_IV_4 * drawbar_amplitude(drawbar(4) + drawbar(6));

%Output
output = reed_output_8 + reed_output_16 + reed_output_4 + reed_output_IV_1 + reed_output_IV_2 + reed_output_IV_3 + reed_output_IV_4 + flute_output_8 + flute_output_16 + flute_output_4 + flute_output_IV_1 + flute_output_IV_2 + flute_output_IV_3 + flute_output_IV_4;
Amp = audioread('Vox AC30 Non Top Boost - Vox AC30.wav');
amp = Amp(:,1);
output = conv(output,amp);

%Normalisation
if max(abs(output)) > 1
    output = output/max(output)*0.8
end

plot((1:length(output))/Fs, output)
sound(output,Fs)
