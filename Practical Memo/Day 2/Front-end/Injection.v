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

module Injection(
 input            Clk,
 input            Reset,

 output           Avalon_ChipEnable,
 output reg [24:0]Avalon_Address,
 output     [ 1:0]Avalon_ByteEnable,
 input            Avalon_WaitRequest,

 output     [15:0]Avalon_WriteData,
 output           Avalon_Write,

 input      [15:0]Avalon_ReadData,
 input            Avalon_ReadDataValid,
 output reg       Avalon_Read,

 output [7:0]Output,
 output reg  Output_Valid
);
//------------------------------------------------------------------------------

assign Avalon_ChipEnable = 1'b1;
assign Avalon_ByteEnable = 2'b11;
assign Avalon_WriteData  = 0;
assign Avalon_Write      = 0;
//------------------------------------------------------------------------------

reg [8:0]WrAddress;
reg [9:0]RdAddress;

InjectFIFO_RAM InjectFIFO_RAM_Inst(
 .clock    (Clk),

 .wraddress(WrAddress           ),
 .data     (Avalon_ReadData     ),
 .wren     (Avalon_ReadDataValid),

 .rdaddress(RdAddress),
 .q        (Output   )
);
//------------------------------------------------------------------------------

reg Reset_1; // Reset the SDRAM to BRAM path
reg Reset_2; // Reset the BRAM to injection path

reg [10:0]Enable; // Temporary counter to inject slowly (48.8 kSps)

always @(posedge Clk) begin
 Reset_1 <= Reset;

 if(Reset_1) begin
  Avalon_Address <= 25'h1FF_FFFF;
  Avalon_Read    <= 0;
  WrAddress      <= 0;
  Reset_2        <= 1'b1;
//------------------------------------------------------------------------------

 end else begin
  if(~Avalon_WaitRequest) begin
   if(
    ((Avalon_Address[8:0] - RdAddress[9:1]) < 9'h1FF) ||
    (Reset_2 && &Avalon_Address) // Forces the first word to read
   ) begin
    Avalon_Address <= Avalon_Address + 1'b1;
    Avalon_Read    <= 1'b1;
   end else begin
    Avalon_Read    <= 1'b0;
   end
  end

  // Increment the write address with every valid write
  if(Avalon_ReadDataValid) WrAddress <= WrAddress + 1'b1;

  // Release the injection when the FIFO is healthy
  if(WrAddress[8]) Reset_2 <= 1'b0;
 end
//------------------------------------------------------------------------------

 Enable <= Enable + 1'b1;

 if(Reset_2) begin
  RdAddress    <= 0;
  Output_Valid <= 0;
 
 end else if(&Enable) begin
  RdAddress    <= RdAddress + 1'b1;
  Output_Valid <= 1'b1;
 end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

