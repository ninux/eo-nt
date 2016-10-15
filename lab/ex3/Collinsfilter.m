%--------------------------------------------------------------------------
% file:         Collinsfilter.m
% author:       Ervin Mazlagic, Chistian Di Batista
% description:  Calculation for Collinsfilter
%--------------------------------------------------------------------------

%% cleanup environment
%clear all;
close all;

%% given static parameters
f  = 455E3; % [Hz]      filter resonant frequency
Ra = 1.5E3; % [Ohm]     filter output impedance equivalent parallel resistor
Ca = 3E-12; % [Farad]   filter output impedance equivalent parallel capacitor
Re = 50.0;    % [Ohm]     wire impedance

%% chosen static parameters
L = 62.9822E-6;  % [Henry]   collins filter inductance

%% derived static parameters
w     = (2 * pi * f);               % [1/s] angular resonant frequency
Zca   = 1 / (1i * w * Ca);          % [Ohm] complex capacitor impedance
Za    = (Ra * Zca) / (Ra + Zca);    % [Ohm] complex filter output impedance
Za_re = real(Za);                   % [Ohm] real part filter output impedance
Za_im = imag(Za);                   % [Ohm] imaginary part filter output impedance

%% collinsfilter transformation ratio
t = (Re / Za_re);

%% collinsfilter capacitor ratio limit
if (t < 0)
    c_max = sqrt(t);
else
    c_min = sqrt(t);
end

%% capacitor ratio calculation
x = (w^2 * L^2 * t) / (Re^2 * (t-1));   % substitution for calculation
c_1 = t*x/(x+1) + sqrt((t-t^2*x)/(x+1) + (t*x)^2/(x+1)^2);
c_2 = t*x/(x+1) - sqrt((t-t^2*x)/(x+1) + (t*x)^2/(x+1)^2);

if (c_1 > 0) && (c_2 < 0)
    c = c_1;
end

if (c_1 < 0) && (c_2 > 0)
    c = c_2;
end

% KORREKTUR
%c = 0.21089

%% collinsfilter capacitor calculation
C1 = (c/(w*Re)) * sqrt((t*(t-1)) / (t-c^2));
C2 = (1/(w*Re)) * sqrt((t*(t-1)) / (t-c^2));

%% print results
fprintf('Collinsfilter\n');
fprintf('  f  [kHz] = %.3f\n', f/1E3);
fprintf('  Re [Ohm] = %.3f\n', Re);
fprintf('  Ra [Ohm] = %.3f\n', Ra);
fprintf('  Ca [nF]  = %.3f\n', Ca*1E9);
fprintf('  L  [nH]  = %.3f\n', L*1E9);
fprintf('  t  [-]   = %.6f\n', t);
fprintf('  c  [-]   = %.6f\n', c);
fprintf('  C1 [nF]  = %.3f\n', C1*1E9);
fprintf('  C2 [pF]  = %.3f\n', C2*1E9);
fprintf('------\n');