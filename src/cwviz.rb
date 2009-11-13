#!/usr/bin/ruby
# cwviz v0.1
#
# Copyright (C) 2009 James Brown.
#
# This file is part of CWVIZ.
#
# CWVIZ is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# CWVIZ is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with CWVIZ.  If not, see <http://www.gnu.org/licenses/>.
#
# == Synopsis
#
# cwviz: Visualize a gate-level circuit; in the future, will support
# including both timing and structural data
#
# == Usage
#
# cwviz [OPTION] ... verilog_file
#
# -h, --help:
#   Show this help
# -o f, --out f
#   Output to file f instead of to stdout
# -c f, --config f
#   Use f as the YAML configuration file

# Make sure that the default include path is correct
$:.push(File.dirname(__FILE__))

require 'circuit'
require 'svg_controller'

require 'getoptlong'
require 'rdoc/usage'

config_file="#{$RESOURCE_BASE}/config.yaml"
out_file=nil

opts = GetoptLong.new(
    [ '--help', '-h', GetoptLong::NO_ARGUMENT],
    [ '--out', '-o', GetoptLong::REQUIRED_ARGUMENT],
    [ '--config', '-c', GetoptLong::REQUIRED_ARGUMENT]
)

opts.each do |opt, arg|
    case opt
    when '--help'
        RDoc::usage
    when '--out'
        out_file = arg.to_s
    when '--config'
        config_file = arg.to_s
    end
end

if ARGV.length != 1
    puts "Incorrect number of arguments"
    RDoc::usage
end

vl_file = ARGV.shift
circuit = Circuit.new_from_verilog(vl_file)
controller = SVGController.new(config_file)
if out_file.nil?
    out = ""
else
    out = File.new(out_file, "w")
end
controller.draw_circuit(circuit, out)
if out_file.nil?
    puts out
else
    out.close
end
