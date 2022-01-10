%% Initialisation
clc
close all
clear all
	
%% ADC spécifications
res = 6;
Vrefp = 1;
Vrefm = 0;
q = (Vrefp-Vrefm)/(2^(res));
jitter = 1e-10;
offset = 0.0;
gain = 1;

%% Test setup
N = 4*2^(res);
fs = 200e6;
fin = 10e6;
Signed = 0;

k = round(N*fin/fs);
if (rem(k,2)==0)
	k = k+1;
end
fin = k*fs/N;
AmpSig = 0.49;
Vof = 0.5;

%% Simulink Model
% Opening model
open_system('ADC_DAC_SimulinkModel_2016a.slx')
% Simulating command
sim('ADC_DAC_SimulinkModel_2016a.slx')

%% ADC time domain output analysis
plot(ADCdata);
axis([0 N-1 1.1*min(ADCdata) 1.1*max(ADCdata)])
grid

%% ADC frequency domain analysis
yf = fft(ADCdata)/N;
Pyf = abs(yf.*conj(yf));

%% Signal to Noise Ratio computation
Ps = sum(Pyf(2:N/2));
k = round(k);
Pfond = Pyf(k+1);
Pn = Ps - Pfond;
SNR = 10*log10(Pfond/Pn);

%% Positive frequency spectrum plot
PE = 2^res; % exprimé en LSB
norm = ((PE/2)^2)/4;
PyfdB = 10*log10(Pyf/norm);
figure(2)
plot(0:(N-1)/2,PyfdB(1:N/2))
grid
axis([0 (N-1)/2 1.1*min(PyfdB(1:N/2)) 1])

title_str = ['SNR (dB) = ' num2str(SNR,4)];
title(title_str)

%% Simulation DAC
ax = 0.05; %erreur axe x en decimal
ay = 0.005; %erreur axe y en decimal
bx = 4;
by = 4;



A = ones(8);

for x = 1:8
   for y = 1:8
       A(x,y) = A(x,y) + ax*(x-bx) + ay*(y-by);
       A(x,y) = A(x,y) + ax*(x-bx)^2 + ay*(x-by)^2;
   end
end



figure;
surf(A);
counter = 0;

DACdata = zeros([numel(ADCdata) 1]);

for z = 1:numel(ADCdata)
    for x = 1:8
       for y = 1:8
           counter = counter + 1;
           if (counter > numel(ADCdata))
               break
           end
           DACdata(z) = DACdata(z) + A(x,y);
       end
       if (counter > numel(ADCdata))
           break
       end
    end
end




