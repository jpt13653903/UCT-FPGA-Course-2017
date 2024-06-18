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

module FIR_Filter_Unit #(
 parameter Phase = 0
)(
 input        Clk,
 input        Reset,

 input      [15:0]Input,  // 2's Complement
 output reg [15:0]Output, // 2's Complement
 output reg       Output_Valid
);
//------------------------------------------------------------------------------

reg  [ 9:  0]Coef_Adr;
wire [-6:-23]Coef_OB; // Offset-binary

altsyncram #(
 .operation_mode        ("ROM"   ),
 .intended_device_family("MAX 10"),

 .clock_enable_input_a  ("BYPASS"      ),
 .clock_enable_output_a ("BYPASS"      ),
 .numwords_a            (1024          ),
 .outdata_aclr_a        ("NONE"        ),
 .outdata_reg_a         ("UNREGISTERED"),
 .widthad_a             (10            ),
 .width_a               (18            ),
 .width_byteena_a       (1             ),
 .address_aclr_a        ("NONE"        ),

 .lpm_hint              ("ENABLE_RUNTIME_MOD=NO"),
 .lpm_type              ("altsyncram"           ),

 .init_file             ("../DSP/FIR_Filter.mif")

)Coefficients(
 .clock0        (Clk     ),
 .address_a     (Coef_Adr),
 .q_a           (Coef_OB ),

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

reg Local_Reset;

reg [-6:-23]Coef;
reg [-6:-39]Product;
reg [ 4:-39]Sum;

always @(posedge Clk) begin
  Local_Reset <= Reset;

  if(Local_Reset) Coef_Adr <= Phase;
  else            Coef_Adr <= Coef_Adr - 1'b1;

  Coef    <= {~Coef_OB[-6], Coef_OB[-7:-23]};
  Product <= $signed(Coef) * $signed(Input);

  if(Coef_Adr == 10'd1020) begin
   Sum <= {{10{Product[-6]}}, Product};
   if(Sum[4]) begin
    if(&Sum[3:0]) Output <= Sum[0:-15];
    else          Output <= 16'h8000;
   end else begin
    if(|Sum[3:0]) Output <= 16'h7FFF;
    else          Output <= Sum[0:-15];
   end
   Output_Valid <= 1'b1;
  end else begin
   Sum <= Sum + {{10{Product[-6]}}, Product};
   Output_Valid <= 1'b0;
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

