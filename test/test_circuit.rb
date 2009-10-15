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

# This script tests the basics of Circuit

require "circuit.rb"
require "circuit_element.rb"

class TestCircuit < Test::Unit::TestCase
    def setup
        @c = Circuit.new_from_verilog(File.join($DATA_BASE, "coords.v"))
        @second = Circuit.new_from_verilog(File.join($DATA_BASE, "coords.v"), "Second")
    end

    def test_load
        assert_equal(2, @c.num_elements)
        assert_equal("Coord_Test", @c.name)
    end

    def test_load_specific
        assert_equal(3, @second.num_elements)
        assert_equal("Second", @second.name)
    end

    def test_bounding_box
        coord = @second.bounding_box
        assert_equal(2, coord.count, "There should be an 'x' and a 'y'")
        assert(coord.has_key?("x"))
        assert(coord.has_key?("y"))
        assert_equal(160, coord["x"])
        assert_equal(0, coord["y"])

        coord = @c.bounding_box
        assert_equal(10, coord["x"])
        assert_equal(10, coord["y"])
    end
end
