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

Bottom = -50;

N = 2^17;
x = 1:N;

y = 10*log10(x/N);
figure; plot(x, y); grid on; xlim([min(x) max(x)]);

y = max(y, Bottom);
figure; plot(x, y); grid on; xlim([min(x) max(x)]);

y = y - Bottom;
y = y ./ max(y) * 255;
y = round(y);
figure; plot(x, y); grid on; xlim([min(x) max(x)]); ylim([min(y) max(y)]);
set(gca, 'xtick', 0:N/8:N);
set(gca, 'ytick', 0:32:256);
%% ------------------------------------------------------------------------

File = fopen('LogScale.mif', 'wb');
 fprintf(File, '-- Generated from LogScale.m\n');
 fprintf(File, '--   0 => %d dB_fs\n', Bottom);
 fprintf(File, '-- 255 =>   0 dB_fs\n');
 fprintf(File, '\n');
 fprintf(File, 'WIDTH =      8;\n');
 fprintf(File, 'DEPTH = %d;\n', N);
 fprintf(File, '\n');
 fprintf(File, 'ADDRESS_RADIX = HEX;\n');
 fprintf(File, 'DATA_RADIX    = HEX;\n');
 fprintf(File, '\n');
 fprintf(File, 'CONTENT BEGIN\n');
 for n = 1:N
  fprintf(File, ' %05X : %02X;\n', n-1, y(n));
 end
 fprintf(File, 'END;\n');
 fclose(File);
%% ------------------------------------------------------------------------
