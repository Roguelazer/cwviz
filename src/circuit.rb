#!/usr/bin/ruby
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

require "circuit_element.rb"
require "verilog_parser.rb"

# This class represents a complete circuit
class Circuit
    include Enumerable
    # The circuit name
    attr_reader :name

    # Constructor
    def initialize
        @elements = Array.new()
        @name = ""
        @bounding_box = nil
    end

    # Get the number of circuit elements
    def num_elements
        return @elements.size
    end

    # The bounding box of this circuit. One end is always
    # (0,0).
    #
    # Returns a Hash containing values for "x" and "y"
    def bounding_box
        if @bounding_box.nil?
            compute_extents
        end
        return @bounding_box
    end

    # Compute the extents of the bounding box of the circuit
    def compute_extents
        max_x = 0
        max_y = 0
        @elements.each { |e|
            if (e.x + 80 > max_x)
                max_x = e.x + 80
            end
            if (e.y + 200 > max_y)
                max_y = e.y + 200
            end
        }
        @bounding_box = {"x" => max_x, "y" => max_y }
    end

    # Iterate over each circuit element
    def each(&block)
        @elements.each{ |e|
            yield e
        }
    end

    # Create a new Circuit object from a Verilog file
    #
    # Arguments:
    # file_path:: A string containing the path to the file
    # root_module:: The name of the root module to visualize. If nil, will
    # visualize whatever module is defined first.
    #
    # Returns:
    # A new, initialized circuit
    def self.new_from_verilog(file_path, root_module=nil)
        c = Circuit.new()
        c.load_verilog_file(file_path, root_module)
        return c
    end

    # Load a file into the current Circuit
    #
    # Arguments:
    # file_path:: A string containing the path to the file to load
    # root_mod:: The name of the root module to visualize. If nil, will
    #   visualize whatever module is defined first.
    def load_verilog_file(file_path, root_mod=nil)
        $stderr.puts "Beginning parse phase" if $verbose
        parser = VlParser.new()
        ast = parser.parse_file(file_path)
        if (ast.nil?)
            raise RuntimeError.new("Could not parse file at #{file_path}; " + 
                                   "error was #{parser.failure_reason()}")
        end
        $stderr.puts "Finished parse phase" if $verbose
        mod = ast.modules[0]
        $stderr.puts "Using module #{mod.module_name}" if $verbose
        if (!root_mod.nil?)
            mod = ast.modules.find { |m| 
                m.module_name == root_mod
            }
        end
        @name = mod.module_name
        $stderr.puts "Constructing circuit" if $verbose
        mod.statements.each { |statement|
            if (statement.statement_kind == :instantiation)
                @elements.push(CircuitElement.new(statement.type,
                                                  statement.x, statement.y,
                                                  statement.name,
                                                  statement.name_full))
            end
        }
        $stderr.puts "Circuit constructed" if $verbose
    end

    private :compute_extents
end
