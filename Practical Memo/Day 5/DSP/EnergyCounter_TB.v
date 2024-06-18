//==============================================================================
// Copyright (C) John-Philip Taylor
// jpt13653903@gmail.com
//
// This file is part of a library
//
// This file is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>
//==============================================================================

`timescale 1ns/1ns
module EnergyCounter_TB;
//------------------------------------------------------------------------------

// Clock
reg Clk_780k = 0;
always #640 Clk_780k <= ~Clk_780k;
//------------------------------------------------------------------------------

// Reset
reg Reset = 1;
initial #1000 Reset <= 0;
//------------------------------------------------------------------------------

reg  [23:0]Input_I = 24'h800000;
reg  [23:0]Input_Q = 24'h800000;

always #4300 Input_I <= Input_I + 10000;
always #8900 Input_Q <= Input_Q + 10000;
//------------------------------------------------------------------------------

wire [4:0]WindowSize = 4;
wire [7:0]Output;

EnergyCounter DUT(
 Clk_780k, Reset,
 WindowSize,
 Input_I, Input_Q, Output
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

