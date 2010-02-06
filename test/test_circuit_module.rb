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

# This script tests the basics of Circuit Modules

require "circuit.rb"
require "circuit_module.rb"
require "circuit_element.rb"

class TestCircuitModule < Test::Unit::TestCase
    def setup
        @sc = Circuit.new_from_verilog(File.join($DATA_BASE, "simple_mods.v"))
        @ct = Circuit.new_from_verilog(File.join($DATA_BASE, "coords.v"))
        @first = @sc.module("First")
        @second = @sc.module("Second")
        @third = @sc.module("Third")
    end

    def test_inputs_outputs
        assert_equal(['x'], @first.inputs)
        assert_equal([], @first.outputs)
        assert_equal(['y'], @second.inputs)
        assert_equal(['z'], @second.outputs)
    end

    def test_positional_io
        assert_equal(:input, @second.param_type(0))
        assert_equal(:output, @second.param_type(1))
        assert_equal(:input, @first.param_type(0))
        assert_equal(:unknown, @first.param_type(1))
    end

    def test_instantiations
        assert_equal(2, @first.num_elements)
        assert_equal(3, @second.num_elements)
        assert_equal(4, @third.num_elements)
    end

    def test_bounding_box
        first = @ct.module("Coord_Test")
        second = @ct.module("Second")

        coord = second.bounding_box
        assert_equal(2, coord.size, "There should be an 'x' and a 'y'")
        assert(coord.has_key?("x"))
        assert(coord.has_key?("y"))
        assert_equal(240, coord["x"])
        assert_equal(200, coord["y"])

        coord = first.bounding_box
        assert_equal(90, coord["x"])
        assert_equal(210, coord["y"])
    end

    def test_connections
        @first.each { |element|
            assert_instance_of(CircuitModule, element.type_definition)
            assert_equal("CSA", element.type_definition.name)
        }
    end

    def test_select
        assert_not_nil(@first["csa1"])
        assert_nil(@first["cas1"])
        assert_not_nil(@first["csa2"])
    end

    def test_arguments
        @first.each { |element|
            if (element.name == "csa1")
                assert_equal(["x"], element.arguments)
            elsif (element.name == "csa2")
                assert_equal(["1'b0"], element.arguments)
            end
        }
        assert_equal(3, @third["a00"].arguments.length)
        assert_equal(3, @third["a01"].arguments.length)
        assert_equal(3, @third["a02"].arguments.length)
        assert_equal(3, @third["a03"].arguments.length)
        assert_equal(:input, @third["a00"].argio(0))
        assert_equal(:input, @third["a00"].argio(1))
        assert_equal(:output, @third["a00"].argio(2))
    end
end
