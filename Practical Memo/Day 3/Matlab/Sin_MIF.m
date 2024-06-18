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

n = 0:1023;
x = sin(n./1024 .* 2.*pi);
x = round((x + 1)/2 * (2^8-1));

figure; plot(x); grid on;
%% ------------------------------------------------------------------------

File = fopen('Sin.mif', 'wb');
 fprintf(File, '-- Generated from Sin_MIF.m\n');
 fprintf(File, '\n');
 fprintf(File, 'WIDTH =    8;\n');
 fprintf(File, 'DEPTH = 1024;\n');
 fprintf(File, '\n');
 fprintf(File, 'ADDRESS_RADIX = HEX;\n');
 fprintf(File, 'DATA_RADIX    = HEX;\n');
 fprintf(File, '\n');
 fprintf(File, 'CONTENT BEGIN\n');
 for n = 1:1024
  fprintf(File, ' %03X : %02X;\n', n-1, x(n));
 end
 fprintf(File, 'END;\n');
 fclose(File);
%% ------------------------------------------------------------------------
