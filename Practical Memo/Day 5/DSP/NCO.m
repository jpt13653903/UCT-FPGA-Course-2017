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

N = 2^12;
n = 0:(N-1);
x = sin(n./N .* 2.*pi);
x = round((x + 1)/2 * (2^9-1));

figure; plot(x); grid on;
%% ------------------------------------------------------------------------

File = fopen('NCO.mif', 'wb');
 fprintf(File, '-- Generated from NCO.m\n');
 fprintf(File, '\n');
 fprintf(File, 'WIDTH =    9;\n');
 fprintf(File, 'DEPTH = %d;\n', N);
 fprintf(File, '\n');
 fprintf(File, 'ADDRESS_RADIX = HEX;\n');
 fprintf(File, 'DATA_RADIX    = HEX;\n');
 fprintf(File, '\n');
 fprintf(File, 'CONTENT BEGIN\n');
 for n = 1:N
  fprintf(File, ' %03X : %03X;\n', n-1, x(n));
 end
 fprintf(File, 'END;\n');
 fclose(File);
%% ------------------------------------------------------------------------
