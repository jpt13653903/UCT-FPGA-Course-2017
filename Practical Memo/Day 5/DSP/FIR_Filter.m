%===============================================================================
% Copyright (C) John-Philip Taylor
% jpt13653903@gmail.com
%
% This file is part of the FPGA Masters Course
%
% This file is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>
%=============================================================================== 

close all
fclose all
clear all
clc

format compact
format long eng
%% ------------------------------------------------------------------------

fs = 100e6;
f0 = 390e3;
N  = 1024;

f = linspace(0, fs, N+1); f = f(1:N);
H = (f < f0) + (f > (fs-f0));

figure;
plot(f/1e6, H);
grid on;
xlabel('f [MHz]');
ylabel('H');
%% ------------------------------------------------------------------------

h = real(fftshift(ifft(H)));

figure;
plot(h);
grid on;
xlabel('n [samples]');
ylabel('h');
%% ------------------------------------------------------------------------

n = 1:N;
w = (sin((pi.*n)/(N-1))).^2;
h = h.*w;
h = h ./ sum(h);

figure;
plot(h);
grid on;
xlabel('n [samples]');
ylabel('h*w');
%% ------------------------------------------------------------------------

H = abs(fft(h, 2^16));

figure;
semilogx([f0 f0], [-400 50], 'g'); hold on;
semilogx([781.25 781.25]*1e3, [-400 50], 'r'); hold on;
semilogx(linspace(0, fs, 2^16), 20*log(H), 'b');
grid on;
xlabel('f [Hz]');
ylabel('H');
xlim([0, fs/2]);
%% ------------------------------------------------------------------------

Scale = 2^7;
bits  = 18;
h = round(h .* Scale .* 2^(bits-1)) + 2^(bits-1);

figure;
plot([1 N], [1 1]*2^(bits-1), 'g'); hold on;
plot([1 N], [1 1]*(2^bits-1), 'r'); hold on;
plot(h);
grid on;
xlabel('n [samples]');
ylabel('h*w');
%% ------------------------------------------------------------------------

File = fopen('FIR_Filter.mif', 'wb');
 fprintf(File, '-- Generated from FIR_Filter.m\n');
 fprintf(File, '-- f0 => %g kHz\n', f0/1e3);
 fprintf(File, '-- Offset-binary format\n');
 fprintf(File, '\n');
 fprintf(File, 'WIDTH = %d;\n', bits);
 fprintf(File, 'DEPTH = %d;\n', N);
 fprintf(File, '\n');
 fprintf(File, 'ADDRESS_RADIX = HEX;\n');
 fprintf(File, 'DATA_RADIX    = HEX;\n');
 fprintf(File, '\n');
 fprintf(File, 'CONTENT BEGIN\n');
 for n = 1:N
  fprintf(File, ' %03X : %05X;\n', n-1, h(n));
 end
 fprintf(File, 'END;\n');
 fclose(File);
%% ------------------------------------------------------------------------
