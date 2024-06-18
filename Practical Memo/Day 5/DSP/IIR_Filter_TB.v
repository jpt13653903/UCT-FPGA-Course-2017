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
module IIR_Filter_TB;
//------------------------------------------------------------------------------

// Clock
reg Clk_780k = 0;
always #640 Clk_780k <= ~Clk_780k;
//------------------------------------------------------------------------------

// Reset
reg Reset = 1;
initial #1000 Reset <= 0;
//------------------------------------------------------------------------------

reg [15:0]Input = 0;

initial begin
 #200000 Input <=  16'h1000;
 #200000 Input <= -16'h1000;
 #200000 Input <=  0;
 #200000 Input <=  16'h7FFF;
 #200000 Input <=  16'h8000;
end

//------------------------------------------------------------------------------

wire [23:0]Output;

IIR_Filter IIR_Filter_Inst(
 Clk_780k, Reset,
// 3'd0, // Pass-through
// 3'd1, //  10 Hz
// 3'd2, // 100 Hz
// 3'd3, //   1 kHz
 3'd4, //  10 kHz
// 3'd5, // 100 kHz

 Input,
 Output
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

