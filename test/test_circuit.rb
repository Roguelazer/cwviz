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
    end

    def test_num_modules
        assert_equal(2, @c.modules.size)
    end

    def test_names
        assert_equal("Coord_Test", @c.modules[0].name)
        assert_equal("Second", @c.modules[1].name)
    end
end
