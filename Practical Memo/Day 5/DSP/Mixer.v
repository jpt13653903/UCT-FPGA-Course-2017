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

module Mixer(
 input Clk,

 // 2's complement input signal
 input  [7:0]Input,  

 // 2's complement components from NCO
 input  [8:0]Sine,   
 input  [8:0]Cosine,

 // 2's complement output
 output reg [15:0]I, 
 output reg [15:0]Q
);
//------------------------------------------------------------------------------

reg [16:0]I_Int;
reg [16:0]Q_Int;

always @(posedge Clk) begin
 I_Int <= $signed(Input) * $signed(Cosine);
 Q_Int <= $signed(Input) * $signed(Sine  );

 if(I_Int[16]) begin
  if(I_Int[15]) I <= I_Int[15:0];
  else          I <= 16'h8000;
 end else begin
  if(I_Int[15]) I <= 16'h7FFF;
  else          I <= I_Int[15:0];
 end

 if(Q_Int[16]) begin
  if(Q_Int[15]) Q <= Q_Int[15:0];
  else          Q <= 16'h8000;
 end else begin
  if(Q_Int[15]) Q <= 16'h7FFF;
  else          Q <= Q_Int[15:0];
 end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

