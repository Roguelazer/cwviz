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

require "util.rb"

# This class represents a single circuit element
class CircuitElement
    # The X-coordinate of the circuit element
    attr_reader :x

    # The Y-coordinate of the circuit element
    attr_reader :y

    # The type of the circuit element
    attr_reader :type

    # A reference to the object that defines this element, if known
    # Else, nil
    attr_accessor :type_definition

    # The name of this instance
    attr_reader :name

    # The full name of this instance
    attr_reader :name_full

    # The arguments to this circuit element
    attr_reader :arguments

    # A hash of options that will be passed to the drawing controller for
    # this circuit element
    attr_reader :opts

    # Constructor
    def initialize(type, x, y, name, name_full, args)
        @x = x.to_i
        @y = y.to_i
        @type = type
        @name = name
        @name_full = name_full
        @type_definition = nil

        @arguments = []
        @argio = nil
        args.each { |a|
            @arguments.push(a.content)
        }

        @opts = Hash.new
    end

    # Get the input/output status of the arguments
    def argio(n)
        if (@argio.nil?)
            compute_argio()
        end
        return @argio[n]
    end

    def compute_argio
        if @type_definition.nil?
            @argio = []
        end
        0.upto(@arguments.length) { |n|
            @argio.push(@type_definition.param_type(n))
        }
    end

    private :compute_argio
end
