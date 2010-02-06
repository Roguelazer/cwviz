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

# This class represents a circuit subcell
class CircuitModule
    attr_reader :name

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

    # Determine whether the nth parameter is an input or an output
    #
    # Arguments:
    # n:: The index of the parameter. 0-based.
    #
    # Returns:
    # :input if it's an input
    # :output if it's an output
    # :unknown if it's unknown or out of range
    def param_type(n)
        if (n < 0 or n >= @param_array.length )
            return :unknown
        else
            return @param_types[@param_array[n]]
        end
    end

    # Get all of the input names
    def inputs
        inputs = []
        @param_types.each { |k,v|
            if v == :input
                inputs.push(k)
            end
        }
        return inputs
    end

    # Get all of the output names
    def outputs
        outputs = []
        @param_types.each { |k,v|
            if v == :output
                outputs.push(k)
            end
        }
        return outputs
    end

    # Iterate over each circuit element
    def each(&block)
        @elements.each{ |e|
            yield e
        }
    end

    # Get a circuit element by name
    def [](name)
        return @elements.find { |e|
            e.name == name
        }
    end

    # Constructor
    #
    # Arguments
    # ast:: The abstract syntax tree from Verilog
    def initialize(ast)
        @bounding_box = nil
        @name = ast.module_name
        @elements = Array.new()
        @param_types = Hash.new()
        @param_array = Array.new()
        ast.parameters.each { |p|
            @param_types[p.name] = p.type
            @param_array.push(p.name)
        }
        ast.statements.each { |statement|
            case statement.statement_kind
            when :instantiation
                @elements.push(CircuitElement.new(statement.type,
                                                  statement.x, statement.y,
                                                  statement.name,
                                                  statement.name_full,
                                                  statement.arguments))
            when :input
                name = statement.name
                if (!@param_types.has_key?(name))
                    $stderr.puts("Found an input label for a nonextant parameter %s" % name)
                else
                    @param_types[name] = :input
                end
            when :output
                name = statement.name
                if (!@param_types.has_key?(name))
                    $stderr.puts("Found an output label for a nonextant parameter %s" % name)
                else
                    @param_types[name] = :output
                end
            end
        }
    end

    # Convert to string
    def to_s
        return "{Verilog module #{@name} containing #{num_elements} elements}"
    end

    private :compute_extents
end
