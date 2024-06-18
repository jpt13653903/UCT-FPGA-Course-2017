//==============================================================================
// Copyright (C) John-Philip Taylor
// jpt13653903@gmail.com
//
// This file is part of the FPGA Masters Course
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

module FIR_Filter(
 input        Clk,
 input        Reset,

 input      [15:0]Input, // 2's Complement
 output reg [15:0]Output // 2's Complement
);
//------------------------------------------------------------------------------

wire [15:0]Unit_Output[7:0];
wire [ 7:0]Unit_Output_Valid;

genvar g;
generate
 for(g = 0; g < 8; g = g + 1) begin: Gen_Filter
  FIR_Filter_Unit #(128*g) FIR_Filter_Unit_Inst(
   Clk, Reset,
   Input, Unit_Output[g], Unit_Output_Valid[g]
  );
 end
endgenerate
//------------------------------------------------------------------------------

always @(posedge Clk) begin
 case(Unit_Output_Valid)
  8'b00000001: Output <= Unit_Output[0];
  8'b00000010: Output <= Unit_Output[1];
  8'b00000100: Output <= Unit_Output[2];
  8'b00001000: Output <= Unit_Output[3];
  8'b00010000: Output <= Unit_Output[4];
  8'b00100000: Output <= Unit_Output[5];
  8'b01000000: Output <= Unit_Output[6];
  8'b10000000: Output <= Unit_Output[7];
  default:;
 endcase
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

