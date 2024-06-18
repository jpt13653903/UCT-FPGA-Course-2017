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
 input  [9:0]Switch,
 output [9:0]LED
);
//------------------------------------------------------------------------------

wire [9:0]Source;

altsource_probe #(
 .instance_id            ("Prb1"),
 .sld_auto_instance_index("YES"),
 .probe_width            (10),
 .source_width           (10)
)SourcesAndProbes_inst(
 .source_ena(1'b1),
 .source    (Source),
 .probe     (Switch)
);
//------------------------------------------------------------------------------

assign LED = Switch ^ Source;
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

