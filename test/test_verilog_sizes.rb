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

require "verilog_sizes"

class TestVerilogSizes < Test::Unit::TestCase
    def test_simple
        vs = VerilogSizes.new(File.join($DATA_BASE, "simple_sizes.v"))
        vs.load_sizes_from_verilog()
        assert_equal(32, vs.sizes["buffer"])
        assert_equal(48, vs.sizes["magic"])
    end

    def test_primary
        vs = VerilogSizes.new(File.join($DATA_BASE, "sizes.v"))
        vs.load_sizes_from_verilog()
        assert_equal(160, vs.sizes["fullAdd_xc"])
    end
end
