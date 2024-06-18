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

`timescale 1ns/1ps
module ADXL345_TB;
//------------------------------------------------------------------------------

// Clock
reg Clk_100M = 0;
always #5 Clk_100M <= ~Clk_100M;
//------------------------------------------------------------------------------

// Reset
reg Reset = 1;
initial #20 Reset <= 0;
//------------------------------------------------------------------------------

// DUT 
wire [15:0]X, Y, Z;
wire nCS, SClk, SDI;
reg  SDO = 0;

ADXL345 #(10) Accelerator(
 Clk_100M, Reset,
 X, Y, Z,
 nCS, SClk, SDI, SDO
);
//------------------------------------------------------------------------------

// Data Injection
integer   File, j;
reg [15:0]Data;

initial begin
 File = $fopen("../Peripherals/ADXL345_TB.dat", "rb");
 
 for(j = 0; j < 16; j = j + 1) @(negedge SClk);
 forever begin
  for(j = 0; j <  8; j = j + 1) @(negedge SClk);
  $fread(Data, File);
  for(j = 0; j < 16; j = j + 1) begin
   @(negedge SClk);
   #40 {SDO, Data[15:1]} <= Data;
  end
 end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

