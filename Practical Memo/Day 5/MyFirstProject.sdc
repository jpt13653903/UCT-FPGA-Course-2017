# ==============================================================================
#  Copyright (C) John-Philip Taylor
#  jpt13653903@gmail.com
# 
#  This file is part of a library
# 
#  This file is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
# ==============================================================================

create_clock -period 100 [get_ports ADC_CLK_10]
create_clock -period  20 [get_ports MAX10_CLK1_50]
create_clock -period  20 [get_ports MAX10_CLK2_50]

derive_pll_clocks -create_base_clocks -use_net_name

create_generated_clock                                     \
 -source [get_pins {MyQsys_Inst|altpll_0|sd1|pll7|clk[1]}] \
         [get_ports Clk_SDRAM]
         
derive_clock_uncertainty
#-------------------------------------------------------------------------------

set_clock_groups -logically_exclusive    \
 -group [get_clocks altera_reserved_tck] \
 -group [get_clocks ADC_CLK_10]          \
 -group [get_clocks MAX10_CLK1_50]       \
 -group [get_clocks MAX10_CLK2_50]       \
 -group [get_clocks {Clk_SDRAM *altpll_0*}]
#-------------------------------------------------------------------------------

set_input_delay  -clock altera_reserved_tck 20 [get_ports {altera_reserved_tdi}]
set_input_delay  -clock altera_reserved_tck 20 [get_ports {altera_reserved_tms}]
set_output_delay -clock altera_reserved_tck 20 [get_ports {altera_reserved_tdo}]
#-------------------------------------------------------------------------------

set_false_path -from * -to   [get_ports LED*]
set_false_path -to   * -from [get_ports Button*]
set_false_path -to   * -from [get_ports Switch*]

set_false_path -from * -to   [get_ports Arduino*]
set_false_path -to   * -from [get_ports Arduino*]
#-------------------------------------------------------------------------------

set_output_delay -max -clock Clk_SDRAM  1.6 [get_ports OP_SDRAM*]
set_output_delay -min -clock Clk_SDRAM -0.9 [get_ports OP_SDRAM*]
set_output_delay -max -clock Clk_SDRAM  1.6 [get_ports BP_SDRAM*]
set_output_delay -min -clock Clk_SDRAM -0.9 [get_ports BP_SDRAM*]

set_multicycle_path                    \
 -from [get_clocks Clk_SDRAM]          \
 -to   [get_clocks {*altpll_0*clk[0]}] \
 -setup 2

set_input_delay -max -clock Clk_SDRAM 5.9 [get_ports BP_SDRAM*]
set_input_delay -min -clock Clk_SDRAM 3.0 [get_ports BP_SDRAM*]
#-------------------------------------------------------------------------------

