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
        @sc = Circuit.new_from_verilog(File.join($DATA_BASE, "simple_mods.v"))
    end

    def test_modules_count
        assert_equal(2, @sc.modules.size)
    end

    def test_inputs_outputs
        assert_equal(['x'], @sc.module("First").inputs)
        assert_equal([], @sc.module("First").outputs)
        assert_equal(['y'], @sc.module("Second").inputs)
        assert_equal(['z'], @sc.module("Second").outputs)
    end
end
