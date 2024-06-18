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

module EnergyCounter(
 input        Clk,
 input        Reset,

 input  [ 4:0]WindowSize, // Real size = 2^WindowSize samples at 781.25 kSps

 input  [23:0]Input_I, // 2's Complement
 input  [23:0]Input_Q, // 2's Complement
 output [ 7:0]Output   // Unsigned log-scale
);
//------------------------------------------------------------------------------

reg [30:0]N;
reg [79:0]Sum;
reg [16:0]AveragePower;
reg [48:0]AveragePower_1;

always @(*) begin
 case(WindowSize)
  5'h00  : begin N = 31'h_0000_0000; AveragePower_1 = Sum[48: 0]; end
  5'h01  : begin N = 31'h_0000_0001; AveragePower_1 = Sum[49: 1]; end
  5'h02  : begin N = 31'h_0000_0003; AveragePower_1 = Sum[50: 2]; end
  5'h03  : begin N = 31'h_0000_0007; AveragePower_1 = Sum[51: 3]; end
  5'h04  : begin N = 31'h_0000_000F; AveragePower_1 = Sum[52: 4]; end
  5'h05  : begin N = 31'h_0000_001F; AveragePower_1 = Sum[53: 5]; end
  5'h06  : begin N = 31'h_0000_003F; AveragePower_1 = Sum[54: 6]; end
  5'h07  : begin N = 31'h_0000_007F; AveragePower_1 = Sum[55: 7]; end
  5'h08  : begin N = 31'h_0000_00FF; AveragePower_1 = Sum[56: 8]; end
  5'h09  : begin N = 31'h_0000_01FF; AveragePower_1 = Sum[57: 9]; end
  5'h0A  : begin N = 31'h_0000_03FF; AveragePower_1 = Sum[58:10]; end
  5'h0B  : begin N = 31'h_0000_07FF; AveragePower_1 = Sum[59:11]; end
  5'h0C  : begin N = 31'h_0000_0FFF; AveragePower_1 = Sum[60:12]; end
  5'h0D  : begin N = 31'h_0000_1FFF; AveragePower_1 = Sum[61:13]; end
  5'h0E  : begin N = 31'h_0000_3FFF; AveragePower_1 = Sum[62:14]; end
  5'h0F  : begin N = 31'h_0000_7FFF; AveragePower_1 = Sum[63:15]; end
  5'h10  : begin N = 31'h_0000_FFFF; AveragePower_1 = Sum[64:16]; end
  5'h11  : begin N = 31'h_0001_FFFF; AveragePower_1 = Sum[65:17]; end
  5'h12  : begin N = 31'h_0003_FFFF; AveragePower_1 = Sum[66:18]; end
  5'h13  : begin N = 31'h_0007_FFFF; AveragePower_1 = Sum[67:19]; end
  5'h14  : begin N = 31'h_000F_FFFF; AveragePower_1 = Sum[68:20]; end
  5'h15  : begin N = 31'h_001F_FFFF; AveragePower_1 = Sum[69:21]; end
  5'h16  : begin N = 31'h_003F_FFFF; AveragePower_1 = Sum[70:22]; end
  5'h17  : begin N = 31'h_007F_FFFF; AveragePower_1 = Sum[71:23]; end
  5'h18  : begin N = 31'h_00FF_FFFF; AveragePower_1 = Sum[72:24]; end
  5'h19  : begin N = 31'h_01FF_FFFF; AveragePower_1 = Sum[73:25]; end
  5'h1A  : begin N = 31'h_03FF_FFFF; AveragePower_1 = Sum[74:26]; end
  5'h1B  : begin N = 31'h_07FF_FFFF; AveragePower_1 = Sum[75:27]; end
  5'h1C  : begin N = 31'h_0FFF_FFFF; AveragePower_1 = Sum[76:28]; end
  5'h1D  : begin N = 31'h_1FFF_FFFF; AveragePower_1 = Sum[77:29]; end
  5'h1E  : begin N = 31'h_3FFF_FFFF; AveragePower_1 = Sum[78:30]; end
  5'h1F  : begin N = 31'h_7FFF_FFFF; AveragePower_1 = Sum[79:31]; end
  default: begin N = 31'h_7FFF_FFFF; AveragePower_1 = Sum[79:31]; end
 endcase
end
//------------------------------------------------------------------------------

reg       Local_Reset;
reg [31:0]Count;

wire [47:0]Power_I = $signed(Input_I) * $signed(Input_I);
wire [47:0]Power_Q = $signed(Input_Q) * $signed(Input_Q);
wire [48:0]Power   = {1'b0,  Power_I} + {1'b0,  Power_Q};

always @(posedge Clk) begin
 Local_Reset <= Reset;

 if(Local_Reset) begin
  Sum   <= 0;
  Count <= 0;

 end else begin
  if(Count >= N) begin
   Sum   <= Power;
   Count <= 0;

   if(|AveragePower_1[48:46]) AveragePower <= 17'h1FFFF;
   else                       AveragePower <= AveragePower_1[45:29];

  end else begin
   Sum   <= Sum   + Power;
   Count <= Count + 1'b1;
  end
 end
end
//------------------------------------------------------------------------------

altsyncram #(
 .operation_mode        ("ROM"   ),
 .intended_device_family("MAX 10"),

 .clock_enable_input_a  ("BYPASS"      ),
 .clock_enable_output_a ("BYPASS"      ),
 .numwords_a            (131072        ),
 .outdata_aclr_a        ("NONE"        ),
 .outdata_reg_a         ("UNREGISTERED"),
 .widthad_a             (17            ),
 .width_a               (8             ),
 .width_byteena_a       (1             ),
 .address_aclr_a        ("NONE"        ),

 .lpm_hint              ("ENABLE_RUNTIME_MOD=NO"),
 .lpm_type              ("altsyncram"           ),

 .init_file             ("../DSP/LogScale.mif")

)LogScale(
 .clock0        (Clk         ),
 .address_a     (AveragePower),
 .q_a           (Output      ),

 .aclr0         (1'b0),
 .aclr1         (1'b0),
 .address_b     (1'b1),
 .addressstall_a(1'b0),
 .addressstall_b(1'b0),
 .byteena_a     (1'b1),
 .byteena_b     (1'b1),
 .clock1        (1'b1),
 .clocken0      (1'b1),
 .clocken1      (1'b1),
 .clocken2      (1'b1),
 .clocken3      (1'b1),
 .rden_a        (1'b1),
 .rden_b        (1'b1),
 .wren_a        (1'b0),
 .wren_b        (1'b0)
);
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

