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

# Test utilities

require "util.rb"

class TestUtil < Test::Unit::TestCase
    def test_verilog_to_number
        assert_equal(1, Util.verilog_to_number("1"))
        assert_equal(1, Util.verilog_to_number("1'b1"))
        assert_equal(1, Util.verilog_to_number("1'h1"))
        assert_equal(1, Util.verilog_to_number("'b1"))
        assert_equal(1, Util.verilog_to_number("'h1"))
        assert_equal(10, Util.verilog_to_number("4'b1010"))
        assert_equal(2, Util.verilog_to_number("2'b1010"))
        assert_equal(105, Util.verilog_to_number("3'd105"))
    end
end
