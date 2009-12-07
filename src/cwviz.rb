#!/usr/bin/ruby
# cwviz v0.2
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
# -v, --verbose
#   Be verbose

# Make sure that the default include path is correct
$:.push(File.dirname(__FILE__))

require 'circuit'
require 'svg_controller'

require 'getoptlong'
require 'rdoc/usage'

config_file="#{$RESOURCE_BASE}/config.yaml"
out_file=nil
real_out_file = nil
out_type=:svg
$verbose=false

opts = GetoptLong.new(
    [ '--help', '-h', GetoptLong::NO_ARGUMENT],
    [ '--out', '-o', GetoptLong::REQUIRED_ARGUMENT],
    [ '--config', '-c', GetoptLong::REQUIRED_ARGUMENT],
    [ '--verbose', '-v', GetoptLong::NO_ARGUMENT]
)

opts.each do |opt, arg|
    case opt
    when '--help'
        RDoc::usage
    when '--out'
        out_file = arg.to_s
        real_out_file = out_file
        extension = /\.(\w*)$/.match(out_file)[1]
        out_type = case extension
            when "svg" then :svg
            when "png" then :png
            when "pdf" then :pdf
            when "eps" then :eps
            else :converted
        end
        if out_type  != :svg
            out_file = out_file.sub(/\.#{extension}$/, ".svg")
        end
    when '--config'
        config_file = arg.to_s
    when '--verbose'
        $verbose = true
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
    case out_type
    when :svg
        $stderr.puts "No conversion necessary, keeping SVG" if $verbose
    when :png
        $stderr.puts "Beginning Inkscape conversion"
        `inkscape -z -e #{real_out_file} #{out_file}`
        File.delete(out_file)
        $stderr.puts "Conversion phase complete" if $verbose
    when :pdf
        # Inkscape on chips doesn't do direct-to-pdf, so have
        # to go through eps
        eps_out_file = out_file.sub(/\.svg/, ".eps")
        $stderr.puts "Beginning SVG->EPS conversion" if $verbose
        `inkscape -z -E #{eps_out_file} #{out_file}`
        File.delete(out_file)
        $stderr.puts "Beginning EPS->PDF conversion" if $verbose
        `ps2pdf -dEPSCrop #{eps_out_file} #{real_out_file}`
        File.delete(eps_out_file)
        $stderr.puts "Conversion phase complete" if $verbose
    when :eps
        $stderr.puts "Beginning Inkscape conversion" if $verbose
        `inkscape -z -E #{real_out_file} #{out_file}`
        File.delete(out_file)
        $stderr.puts "Conversion phase complete" if $verbose
    else
        $stderr.puts "Beginning SVG->other conversion phase" if $verbose
        `convert #{out_file} #{real_out_file}`
        File.delete(out_file)
        $stderr.puts "Conversion phase complete" if $verbose
    end
    $stderr.puts "Output written to #{real_out_file}" if $verbose
end
