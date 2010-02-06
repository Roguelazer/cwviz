#!/usr/bin/ruby
# Copyright (C) 2009-2010 James Brown.
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

require "set"
require "circuit_module.rb"
require "circuit_element.rb"
require "verilog_parser.rb"

# This class represents a complete circuit
class Circuit
    include Enumerable
    # The circuit name
    attr_reader :name

    # All of the modules
    attr_reader :modules

    # Constructor
    def initialize
        @modules = Array.new()
        @name = ""
    end

    # Iterate over each circuit module
    def each(&block)
        @modules.each{ |e|
            yield e
        }
    end

    # Get a module by name
    def module(name)
        return @modules.find { |mod|
            mod.name == name
        }
    end

    # Alias for module
    def [](name)
        return self.module(name)
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
        $stderr.puts "Constructing circuit" if $verbose
        ast.modules.each { |m|
            @modules.push(CircuitModule.new(m))
        }
        unfound_types = Set.new()
        # Do second phase to connect subcell definitions to instances
        @modules.each { |mod|
            mod.each { |element|
                element.type_definition = @modules.find { |m| 
                    element.type == m.name
                }
                if element.type_definition.nil?
                    unfound_types.add(element.type)
                end
            }
        }
        unfound_types.each { |t|
            $stderr.puts "No definition found for cell type %s" % t if $verbose
        }
        $stderr.puts "Circuit constructed" if $verbose
    end
end
