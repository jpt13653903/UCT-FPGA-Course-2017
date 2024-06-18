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

Data = uint8(2^7 * ones(1, 2^26));
ExportData(Data, '50% DC');
%% -----------------------------------------------------------------------------

Data = uint8(0:(2^8-1));
Data = repmat(Data, 1, 2^26/length(Data));
ExportData(Data, 'Sawtooth');
%% -----------------------------------------------------------------------------

% 440 Hz when played at 390 kSps
fs = 100e6/2^8;
t = (0:2^26-1)/fs;
Data = sin(2*pi*440*t);
Data = uint8(round((Data/2+0.5)*(2^8-1)));
ExportData(Data, '440 Hz Sine (390 kSps)');
%% -----------------------------------------------------------------------------

% 440 Hz when played at 48 kSps
fs = 100e6/2^8/8;
t = (0:2^26-1)/fs;
Data = sin(2*pi*440*t);
Data = uint8(round((Data/2+0.5)*(2^8-1)));
ExportData(Data, '440 Hz Sine (48.8 kSps)');
%% -----------------------------------------------------------------------------

% % Song at 48.8 kSps
% [x, x_fs] = audioread('Song.mp3'); x = mean(x, 2);
% x_t = (0:length(x)-1)/x_fs;
% fs = 100e6/2^11; % 48.8 kSps
% t = (0:2^26-1)/fs;
% Data = interp1(x_t, x, t);
% Data(find(isnan(Data))) = 0;
% Data = Data / max(abs(Data));
% Data = uint8(round((Data/2+0.5)*(2^8-1)));
% ExportData(Data, 'Song (48.8 kSps)');
%% -----------------------------------------------------------------------------
