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

module NCO(
 input Clk,
 input Reset,

 input  [31:0]Frequency,

 output [ 8:0]Sine,  // 2's complement
 output [ 8:0]Cosine // 2's complement
);
//------------------------------------------------------------------------------

reg       Local_Reset;
reg [31:0]Phase;

always @(posedge Clk) begin
 Local_Reset <= Reset;

 if(Local_Reset) Phase <= 0;
 else            Phase <= Phase + Frequency;
end
//------------------------------------------------------------------------------

wire [8:0]Sine_Offset;
wire [8:0]Cosine_Offset;

altsyncram #(
 .operation_mode           ("BIDIR_DUAL_PORT"),
 .maximum_depth            (1024             ),

 .width_a                  (9       ),
 .widthad_a                (12      ),
 .numwords_a               (4096    ),
 .outdata_reg_a            ("CLOCK0"),
 .outdata_aclr_a           ("NONE"  ),
 .width_byteena_a          (1       ),
 .clock_enable_input_a     ("BYPASS"),
 .clock_enable_output_a    ("BYPASS"),

 .width_b                  (9       ),
 .widthad_b                (12      ),
 .numwords_b               (4096    ),
 .indata_reg_b             ("CLOCK0"),
 .outdata_reg_b            ("CLOCK0"),
 .outdata_aclr_b           ("NONE"  ),
 .width_byteena_b          (1       ),
 .address_reg_b            ("CLOCK0"),
 .clock_enable_input_b     ("BYPASS"),
 .clock_enable_output_b    ("BYPASS"),
 .wrcontrol_wraddress_reg_b("CLOCK0"),

 .intended_device_family   ("MAX 10"    ),
 .lpm_type                 ("altsyncram"),
 .power_up_uninitialized   ("FALSE"     ),
 .ram_block_type           ("M9K"       ),

 .init_file                ("../DSP/NCO.mif")
 // Remember that this path must be valid from the simulation working directory

)Sine_ROM(
 .clock0   (Clk),

 .address_a(Phase[31:20]),
 .q_a      (Sine_Offset),
 .wren_a   (1'b0),

 .address_b(Phase[31:20] + 12'h400),
 .q_b      (Cosine_Offset),
 .wren_b   (1'b0)
);

assign Sine   = {  ~Sine_Offset[8],   Sine_Offset[7:0]};
assign Cosine = {~Cosine_Offset[8], Cosine_Offset[7:0]};
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

