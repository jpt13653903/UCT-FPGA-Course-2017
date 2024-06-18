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

module Mult_Unsign_x_Sign #(
 parameter N_A = 18,
 parameter N_B = 18
)(
 input  [N_A-1:0]A, // Unsigned
 input  [N_B-1:0]B, // Signed (2's complement)

 output [N_A+N_B-1:0]Y
);
//------------------------------------------------------------------------------

wire          Sign  = B[N_B-1];
wire [N_B-1:0]Abs_B = Sign ? -B : B;

wire [N_A+N_B-1:0]Abs_Y = A * Abs_B;

assign Y = Sign ? -Abs_Y : Abs_Y;
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

