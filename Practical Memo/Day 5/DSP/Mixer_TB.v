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
module Mixer_TB;
//------------------------------------------------------------------------------

// Clock
reg Clk_100M = 0;
always #5 Clk_100M <= ~Clk_100M;
//------------------------------------------------------------------------------

// Reset
reg Reset = 1;
initial #20 Reset <= 0;
//------------------------------------------------------------------------------

wire [8:0]Sin;
wire [8:0]Cos;

NCO NCO_Inst(
 Clk_100M, Reset, 
 32'h_028F_5C29, // 1 MHz
 Sin, Cos
);
//------------------------------------------------------------------------------

reg [7:0]Input = 8'h80;

always #1000 Input <= Input + 1'b1;

wire [15:0]I, Q;

Mixer DUT(
 Clk_100M,
 Input,
 Sin, Cos,
 I, Q
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

