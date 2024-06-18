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
module FIR_Filter_Unit_TB;
//------------------------------------------------------------------------------

// Clock
reg Clk_100M = 0;
always #5 Clk_100M <= ~Clk_100M;
//------------------------------------------------------------------------------

// Reset
reg Reset = 1;
initial #10 Reset <= 0;
//------------------------------------------------------------------------------

reg [15:0]Input = 0;

initial begin
 #50000 Input <=  16'h6000;
 #50000 Input <= -16'h6000;
 #50000 Input <=  16'h0000;
 #50000 Input <=  16'h7FFF;
 #50000 Input <=  16'h8000;
end
//------------------------------------------------------------------------------

wire [15:0]Output;
wire       Output_Valid;

FIR_Filter_Unit #(0) FIR_Filter_Unit_Inst(
 Clk_100M, Reset,
 Input, Output, Output_Valid
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

