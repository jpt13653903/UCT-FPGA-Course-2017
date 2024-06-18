%===============================================================================
% Copyright (C) John-Philip Taylor
% jpt13653903@gmail.com
%
% This file is part of DE10-Lite Virtual JTAG MM Writer
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

close all;
clear all;
fclose all;
clc;

format compact
format long eng
%% -----------------------------------------------------------------------------

% % 440 Hz when played at 100 MSps
% fs = 100e6;
% t = (0:2^26-1)/fs;
% Data = sin(2*pi*440*t);
% Data = uint8(round((Data/2+0.5)*(2^8-1)));
% ExportData(Data, '440 Hz Sine (100 MSps)');
% 
% % 60 kHz when played at 100 MSps
% fs = 100e6;
% t = (0:2^26-1)/fs;
% Data = sin(2*pi*60e3*t);
% Data = uint8(round((Data/2+0.5)*(2^8-1)));
% ExportData(Data, '60 kHz Sine (100 MSps)');

% 60 kHz square when played at 100 MSps
fs = 100e6;
t = (0:2^26-1)/fs;
Data = sin(2*pi*60e3*t);
Data = uint8(round((Data > 0) .* (2^8-1)));
ExportData(Data, '60 kHz Square (100 MSps)');

figure; plot(Data(1:10000)); grid on;
%% -----------------------------------------------------------------------------
