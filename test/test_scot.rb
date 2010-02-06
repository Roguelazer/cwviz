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

# This script tests the basics of Scot

require "scot.rb"
require "circuit.rb"

class TestScot < Test::Unit::TestCase
    def test_temp
        assert_equal([255,0,0], HeatColor.color_triple(1.0))
        assert_equal([0,0,255], HeatColor.color_triple(0.0))
        assert_equal("#ff0000", HeatColor.color_string(1.0))
        assert_equal("#0000ff", HeatColor.color_string(0.0))
        assert_equal("#7f007f", HeatColor.color_string(0.5))
    end

    def test_annotate
        circuit = Circuit.new_from_verilog(File.join($DATA_BASE, "simple_scot.v"))
        s = Scot.new(File.join($DATA_BASE, "simple_scot.out"))
        s.annotate(circuit["First"])
        assert_equal("#ff0000", circuit["First"]["a00"].opts["fill"])
        assert_equal("#7f007f", circuit["First"]["a01"].opts["fill"])
    end
end
