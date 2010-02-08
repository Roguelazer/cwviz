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

require "svg_controller"
require "circuit"
require "test/unit"

# This test is for overlap detection code
class TestOverlap < Test::Unit::TestCase
    def name
        "Overlap detection test suite"
    end

    def test_basic
        s = SVGController.new(File.join($DATA_BASE, "example_config.yaml"))
        cir = Circuit.new_from_verilog(File.join($DATA_BASE, "overlap_test.v"))
        c = cir["HasOverlapsX"]
        o = s.check_overlap(c)
        assert_equal(1, o.length)
        assert_equal("mb1", o[0][0].name)
        assert_equal("mb2", o[0][1].name)
        c = cir["HasOverlapsY"]
        o = s.check_overlap(c)
        assert_equal(1, o.length)
        assert_equal("mb1", o[0][0].name)
        assert_equal("mb2", o[0][1].name)
    end

    def test_touching
        s = SVGController.new(File.join($DATA_BASE, "example_config.yaml"))
        c = Circuit.new_from_verilog(File.join($DATA_BASE, "overlap_test.v"))["HasNoOverlaps"]
        o = s.check_overlap(c)
        assert_equal(0, o.length);
    end

    def test_mixed
        s = SVGController.new(File.join($DATA_BASE, "example_config.yaml"))
        c = Circuit.new_from_verilog(File.join($DATA_BASE, "overlap_test.v"))["HasOverlapsAndNoOverlaps"]
        o = s.check_overlap(c)
        assert_equal(1, o.length);
        assert_equal("mb1", o[0][0].name)
        assert_equal("mb2", o[0][1].name)
    end

    def test_multi
        s = SVGController.new(File.join($DATA_BASE, "example_config.yaml"))
        c = Circuit.new_from_verilog(File.join($DATA_BASE, "overlap_test.v"))["MultiOverlap"]
        o = s.check_overlap(c)
        assert_equal(2, o.length)
        assert_equal("mb1", o[0][0].name)
        assert_equal("mb2", o[0][1].name)
        assert_equal("mb2", o[1][0].name)
        assert_equal("mb3", o[1][1].name)
    end
end
