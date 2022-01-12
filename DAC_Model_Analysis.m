%% Initialisation
clc
close all
clear all
	
%% ADC spÈcifications
res = 6;
Vrefp = 1;
Vrefm = 0;
q = (Vrefp-Vrefm)/(2^(res));
jitter = 1e-10;
offset = 0.0;
gain = 1;

%% Test setup
N = 64*2^(res);
fs = 200e6;
fin = 2e6;
Signed = 0;

k = round(N*fin/fs);
if (rem(k,2)==0)
	k = k+1;
end
fin = k*fs/N;
AmpSig = 0.3;
Vof = 0.5;

%% Simulink Model
% Opening model
open_system('ADC_DAC_SimulinkModel_2016a.slx')
% Simulating command
sim('ADC_DAC_SimulinkModel_2016a.slx')

%% ADC time domain output analysis
figure('Name','Digital signal');
plot(ADCdata);
axis([0 N/32 0 63])
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
PE = 2^res; % exprim√© en LSB
norm = ((PE/2)^2)/4;
PyfdB = 10*log10(Pyf/norm);
figure('Name','Spectrum digital signal');
plot(0:(N-1)/2,PyfdB(1:N/2))
grid
axis([0 N/16 -90 0])

title_str = ['SNR (dB) = ' num2str(SNR,4)];
title(title_str)

%% CrÈation de la matrice des capacitÈs

ax = 0.005; %erreur axe x en decimal
ay = 0.005; %erreur axe y en decimal
offset = -0.2;
bx = 0;
by = 0;
alpha = 2*pi/360  * 20;

%x*sin(alpha) - y*cos(alpha)

A = ones(8);

for x = 1:8
   for y = 1:8
       A(x,y) = A(x,y) + ax*((x*cos(alpha) - y*sin(alpha))-bx) + ay*((x*sin(alpha) - y*cos(alpha))-by) + offset;
       A(x,y) = A(x,y) + ax*((x*cos(alpha) - y*sin(alpha))-bx)^2 + ay*((x*sin(alpha) - y*cos(alpha))-by)^2;
   end
end

figure;
surf(A);
counter = 0;


%% Conversion numÈrique analogique simple

DACdata = zeros([numel(ADCdata) 1]);

for z = 1:numel(ADCdata)
    counter = 0;
    for x = 1:8
        
       for y = 1:8
           counter = counter + 1;
           if (counter > ADCdata(z))
               break
           end
           DACdata(z) = DACdata(z) + A(x,y);
       end
       
       if (counter > ADCdata(z))
           break
       end
       
    end
end

%% ADC time domain output analysis
figure('Name','Analog converted signal');
plot(DACdata);
axis([0 N/32 0 63])
grid

%% ADC frequency domain analysis
yf = fft(DACdata)/N;
Pyf = abs(yf.*conj(yf));

%% Signal to Noise Ratio computation
Ps = sum(Pyf(2:N/2));
k = round(k);
Pfond = Pyf(k+1);
Pn = Ps - Pfond;
SNR = 10*log10(Pfond/Pn);

%% Positive frequency spectrum plot
PE = 2^res; % exprim√© en LSB
norm = ((PE/2)^2)/4;
PyfdB = 10*log10(Pyf/norm);
figure('Name','Spectrum output analog signal');
plot(0:(N-1)/2,PyfdB(1:N/2))
grid
axis([0 N/16 -90 0])

title_str = ['SNR (dB) = ' num2str(SNR,4)];
title(title_str)










%% Reshuffled diagonal rotated walk switching scheme

diag = 1:1:16;
submatrix = makeSubmatrix(diag)

%% stage 2

diag = stage2(diag);
submatrix = makeSubmatrix(diag)

%% stage 3
diag = stage3(diag);
submatrix = makeSubmatrix(diag)

%% findCell

number = 2;
[row,col] = findCell(submatrix, number)














%% Conversion numÈrique analogique simple

DACdata_shuffle = zeros([numel(ADCdata) 1]);

diag = 1:1:16;
submatrix = makeSubmatrix(diag);

state = 1;

for z = 1:numel(ADCdata)

    for y = 1:ADCdata(z)
       DACdata_shuffle(z) = DACdata_shuffle(z) + A(findCell( submatrix, y ));
    end
    
    if state == 1
        diag = stage2(diag);
        submatrix = makeSubmatrix(diag);
        state = 2;
    elseif state == 2
        diag = stage3(diag);
        submatrix = makeSubmatrix(diag);
        state = 1;
    end

end

%% ADC time domain output analysis
figure('Name','Analog converted signal with shuffle');
plot(DACdata_shuffle);
axis([0 N/32 0 63])
grid

%% ADC frequency domain analysis
yf = fft(DACdata_shuffle)/N;
Pyf = abs(yf.*conj(yf));

%% Signal to Noise Ratio computation
Ps = sum(Pyf(2:N/2));
k = round(k);
Pfond = Pyf(k+1);
Pn = Ps - Pfond;
SNR = 10*log10(Pfond/Pn);

%% Positive frequency spectrum plot
PE = 2^res; % exprim√© en LSB
norm = ((PE/2)^2)/4;
PyfdB = 10*log10(Pyf/norm);
figure('Name','Spectrum output analog signal with shuffle');
plot(0:(N-1)/2,PyfdB(1:N/2))
grid
axis([0 N/16 -90 0])

title_str = ['SNR (dB) = ' num2str(SNR,4)];
title(title_str)









