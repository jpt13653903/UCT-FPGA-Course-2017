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

module MyFirstProject(
 input        ADC_CLK_10,
 input        MAX10_CLK1_50,
 input        MAX10_CLK2_50,

 input  [ 1:0]Button_n,
 input  [ 9:0]Switch,
 output [ 9:0]LED,

 inout  [15:0]Arduino_IO,
 input        Arduino_Reset_n,

 output [12:0]OP_SDRAM_Address,
 output [ 1:0]OP_SDRAM_BA,
 output       OP_SDRAM_CAS_n,
 output       OP_SDRAM_CKE,
 output       OP_SDRAM_CS_n,
 inout  [15:0]BP_SDRAM_DQ,
 output [ 1:0]OP_SDRAM_DQM,
 output       OP_SDRAM_RAS_n,
 output       OP_SDRAM_WE_n,
 output       Clk_SDRAM
);

assign Arduino_IO = 16'hZZZZ;
//------------------------------------------------------------------------------

wire Clk_100M;
wire Clk_780k;
wire PLL_Locked;

wire Reset = (~PLL_Locked) | (~Button_n[0]);

reg        SDRAM_ChipSelect;
reg  [24:0]SDRAM_Address;
reg  [ 1:0]SDRAM_ByteEnable;
wire       SDRAM_WaitRequest;

reg  [15:0]SDRAM_WriteData;
reg        SDRAM_Write;

wire [15:0]SDRAM_ReadData;
wire       SDRAM_ReadDataValid;
reg        SDRAM_Read;

MyQsys MyQsys_Inst(
 .clk_clk                      (MAX10_CLK2_50),
 .reset_reset_n                (Button_n[0]  ),

 .clk_100m_clk                 (Clk_100M  ),
 .clk_780k_clk                 (Clk_780k  ),
 .pll_locked_export            (PLL_Locked),

 .sdram_ic_addr                (OP_SDRAM_Address),
 .sdram_ic_ba                  (OP_SDRAM_BA     ),
 .sdram_ic_cas_n               (OP_SDRAM_CAS_n  ),
 .sdram_ic_cke                 (OP_SDRAM_CKE    ),
 .sdram_ic_cs_n                (OP_SDRAM_CS_n   ),
 .sdram_ic_dq                  (BP_SDRAM_DQ     ),
 .sdram_ic_dqm                 (OP_SDRAM_DQM    ),
 .sdram_ic_ras_n               (OP_SDRAM_RAS_n  ),
 .sdram_ic_we_n                (OP_SDRAM_WE_n   ),
 .sdram_ic_clock_clk           (Clk_SDRAM       ),

 .sdram_interface_chipselect   ( SDRAM_ChipSelect   ),
 .sdram_interface_address      ( SDRAM_Address      ),
 .sdram_interface_byteenable_n (~SDRAM_ByteEnable   ),
 .sdram_interface_waitrequest  ( SDRAM_WaitRequest  ),

 .sdram_interface_writedata    ( SDRAM_WriteData    ),
 .sdram_interface_write_n      (~SDRAM_Write        ),

 .sdram_interface_readdata     ( SDRAM_ReadData     ),
 .sdram_interface_readdatavalid( SDRAM_ReadDataValid),
 .sdram_interface_read_n       (~SDRAM_Read         )
);
//------------------------------------------------------------------------------

wire       VirtualJTAG_Busy;

wire       VirtualJTAG_ChipSelect;
wire [24:0]VirtualJTAG_Address;
wire [ 1:0]VirtualJTAG_ByteEnable;
reg        VirtualJTAG_WaitRequest;

wire [15:0]VirtualJTAG_WriteData;
wire       VirtualJTAG_Write;

reg  [15:0]VirtualJTAG_ReadData;
reg        VirtualJTAG_ReadDataValid;
wire       VirtualJTAG_Read;

VirtualJTAG_MM_Write VirtualJTAG_MM_Write_Inst(
 .Clk                 (Clk_100M        ),
 .Reset               (Reset           ),
 .Busy                (VirtualJTAG_Busy),

 .Avalon_ChipEnable   (VirtualJTAG_ChipSelect ),
 .Avalon_Address      (VirtualJTAG_Address    ),
 .Avalon_ByteEnable   (VirtualJTAG_ByteEnable ),
 .Avalon_WaitRequest  (VirtualJTAG_WaitRequest),

 .Avalon_WriteData    (VirtualJTAG_WriteData),
 .Avalon_Write        (VirtualJTAG_Write    ),

 .Avalon_ReadData     (VirtualJTAG_ReadData     ),
 .Avalon_ReadDataValid(VirtualJTAG_ReadDataValid),
 .Avalon_Read         (VirtualJTAG_Read         )
);
//------------------------------------------------------------------------------

wire       Injection_ChipSelect;
wire [24:0]Injection_Address;
wire [ 1:0]Injection_ByteEnable;
reg        Injection_WaitRequest;

wire [15:0]Injection_WriteData;
wire       Injection_Write;

reg  [15:0]Injection_ReadData;
reg        Injection_ReadDataValid;
wire       Injection_Read;

wire [ 7:0]Injection_Output;
wire       Injection_Output_Valid;

Injection Injection_Inst(
 .Clk                 (Clk_100M         ),
 .Reset               (Reset | Switch[0]),

 .Avalon_ChipEnable   (Injection_ChipSelect ),
 .Avalon_Address      (Injection_Address    ),
 .Avalon_ByteEnable   (Injection_ByteEnable ),
 .Avalon_WaitRequest  (Injection_WaitRequest),

 .Avalon_WriteData    (Injection_WriteData),
 .Avalon_Write        (Injection_Write    ),

 .Avalon_ReadData     (Injection_ReadData     ),
 .Avalon_ReadDataValid(Injection_ReadDataValid),
 .Avalon_Read         (Injection_Read         ),

 .Output      (Injection_Output      ),
 .Output_Valid(Injection_Output_Valid)
);
//------------------------------------------------------------------------------

reg SDRAM_Switch;
always @(posedge Clk_100M) SDRAM_Switch <= Switch[0];

always @(*) begin
 if(SDRAM_Switch) begin
  SDRAM_ChipSelect = VirtualJTAG_ChipSelect;
  SDRAM_Address    = VirtualJTAG_Address;
  SDRAM_ByteEnable = VirtualJTAG_ByteEnable;
  SDRAM_WriteData  = VirtualJTAG_WriteData;
  SDRAM_Write      = VirtualJTAG_Write;
  SDRAM_Read       = VirtualJTAG_Read;

  VirtualJTAG_WaitRequest   = SDRAM_WaitRequest;
  VirtualJTAG_ReadData      = SDRAM_ReadData;
  VirtualJTAG_ReadDataValid = SDRAM_ReadDataValid;

  Injection_WaitRequest   = 1'b1;
  Injection_ReadData      = 0;
  Injection_ReadDataValid = 0;

 end else begin
  SDRAM_ChipSelect = Injection_ChipSelect;
  SDRAM_Address    = Injection_Address;
  SDRAM_ByteEnable = Injection_ByteEnable;
  SDRAM_WriteData  = Injection_WriteData;
  SDRAM_Write      = Injection_Write;
  SDRAM_Read       = Injection_Read;

  Injection_WaitRequest   = SDRAM_WaitRequest;
  Injection_ReadData      = SDRAM_ReadData;
  Injection_ReadDataValid = SDRAM_ReadDataValid;

  VirtualJTAG_WaitRequest   = 1'b1;
  VirtualJTAG_ReadData      = 0;
  VirtualJTAG_ReadDataValid = 0;
 end
end
//------------------------------------------------------------------------------

PWM PWM_Inst(
 Clk_100M, 
 Injection_Output_Valid ? Injection_Output : 8'h80,
 Arduino_IO[15]
);
//------------------------------------------------------------------------------

assign LED = {SDRAM_Address[24:17], VirtualJTAG_Busy, SDRAM_Switch};
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

