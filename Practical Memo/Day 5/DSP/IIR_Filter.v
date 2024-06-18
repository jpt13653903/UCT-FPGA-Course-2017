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

module IIR_Filter(
 input Clk,
 input Reset,

 input [2:0]Frequency_Select, // 1 -> 5 => 10, 100, 1k, 10 and 100k

 // 2's Complement input and outputs -- both are full-scale = [-1, 1)
 input      [15:0]Input,
 output reg [23:0]Output
);
//------------------------------------------------------------------------------

// Make these full-scale 1, so that the equation becomes y = A x + B y_1 + C y_2
reg [0:-32]A;
reg [0:-32]B;
reg [0:-32]C;

always @(*) begin
 case(Frequency_Select)
  3'd1: begin // 10 Hz
   A = 33'd____________28;
   B = 33'd_8_589_446_092;
   C = 33'd_4_294_478_824;
  end

  3'd2: begin // 100 Hz
   A = 33'd_________2_775;
   B = 33'd_8_585_049_594;
   C = 33'd_4_290_085_073;
  end

  3'd3: begin // 1 kHz
   A = 33'd_______274_663;
   B = 33'd_8_541_087_701;
   C = 33'd_4_246_395_068;
  end

  3'd4: begin // 10 kHz
   A = 33'd____24_799_428;
   B = 33'd_8_104_255_079;
   C = 33'd_3_834_087_211;
  end

  3'd5: begin // 100 kHz
   A = 33'd___997_792_625;
   B = 33'd_4_839_800_553;
   C = 33'd_1_542_625_882;
  end

  default: begin // Pass-through
   A = 33'h_1_0000_0000;
   B = 33'h___________0;
   C = 33'h___________0;
  end
 endcase
end
//------------------------------------------------------------------------------

reg Local_Reset;

reg [0:-15]x;
reg [0:-39]y_1;
reg [0:-39]y_2;

wire [1:-47]A_x;
wire [1:-71]B_y_1;
wire [1:-71]C_y_2;

Mult_Unsign_x_Sign #(33, 16) Mul1(A, x  , A_x  );
Mult_Unsign_x_Sign #(33, 40) Mul2(B, y_1, B_y_1);
Mult_Unsign_x_Sign #(33, 40) Mul3(C, y_2, C_y_2);

wire [1:-71]y = {A_x, 24'd0} + B_y_1 - C_y_2;

always @(posedge Clk) begin
 Local_Reset <= Reset;

 if(Local_Reset) begin
  x   <= 0;
  y_1 <= 0;
  y_2 <= 0;

 end else begin
  x <= Input;
  
  case(y[1:0])
   2'b10  : y_1 <= 40'h8000000000;
   2'b01  : y_1 <= 40'h7FFFFFFFFF;
   default: y_1 <= y[0:-39];
  endcase
  
  y_2 <= y_1;

  Output <= y_1[0:-23];
 end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

