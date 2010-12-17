cwviz is a tool for visualizing specially-annotated Verilog files. It allows
you to precisely control and visualize the layout of a circuit without having
to use actual circuit layout tools. It also allows annotating the
visualizations based on timing information from a few different sources.

Usage
-----
    cwviz [OPTION] ... verilog_file

	-h, --help:
	  Show this help
	-o f, --out f
	  Output to file f instead of to stdout
	-c f, --config f
	  Use f as the YAML configuration file
	-s f, --scot-file f
	  Use f as the SCOT timing file. Currently only supports
	  visualizing a *single* .out file
	-b, --absolute-delay
	  Use absolute scot delays (per-cell)
	-m name, --module-name name
	  Visualize module "name". Defaults to the first module in the file,
	  whatever that might be
	-a, --autosize
	  Automatically determine sizes by reading comments in the verilog
	  argument
	-l, --check-overlap
	  Check for overlap in cells
	-v, --verbose
	  Be verbose

Dependencies
------------
* Ruby 1.8 or greater (preferably 1.8.6 or greater)
* libxml-ruby 
* To output to non-svg files, cwviz requires imagemagick and inkscape (>=0.43).

License
-------
CWVIZ is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

CWVIZ is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with CWVIZ.  If not, see <http://www.gnu.org/licenses/>.
