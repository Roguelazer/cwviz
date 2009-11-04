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
			r = SVG::Rect.new("#{i}cm", "1cm", "0.5cm", "4cm")
			r.fill = "red"
			r.stroke = "blue"
			r.stroke_width = "0.1em"
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
end
