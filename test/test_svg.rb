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

require "svg.rb"
require "test/unit"

# This script tests the SVG output module
class TestSVG < Test::Unit::TestCase
	def name
		"SVG Test Suite"
	end

	def test_simple
		s = SVG.new()
		1.upto(10) { |i|
			r = SVG::Rect.new("#{i}", "1", "0.5", "4")
			r.fill = "red"
			r.stroke = "blue"
			r.stroke_width = "0.1"
            r.scale = false
			s.add_element(r)
		}
        str = ""
		s.write(str)
        lines = str.split("\n")
        f = File.new("data/svg_test1.svg", "r")
        counter = 0
        f.each { |line|
            assert(line = lines[counter])
            counter += 1
        }
        assert_equal(counter, lines.size)
        f.close()
	end

    def test_id_generator
        SVG::IDGenerator.reset()
        i = SVG::IDGenerator.instance()
        assert_equal("id000001", i.next())
        assert_equal("id000002", SVG::IDGenerator.next())
        assert_equal("id000003", i.next())
        i.prefix = "rect"
        assert_equal("rect000001", i.next())
        assert_equal("rect000002", SVG::IDGenerator.next())
        SVG::IDGenerator.prefix="id"
        assert_equal("id000004", i.next())
        assert_equal("test000001", i.next_with_prefix("test"))
        assert_equal("test000002", SVG::IDGenerator.next_with_prefix("test"))
        assert_equal("id000005", i.next())
    end

    def test_rect
        r = SVG::Rect.new(1,2,3,4)
    end
end
