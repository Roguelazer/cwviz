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

require "svg"
require "svg_controller"
require "circuit"
require "test/unit"

# This script tests the SVG output module
class TestSVG < Test::Unit::TestCase
	def name
		"SVG Controller Test Suite"
	end

	def test_configuration_load
        c = SVGController.new("data/example_config.yaml")
        assert_equal("png", c.circuit_images["nand2"].file_type)
        assert_equal("svg", c.circuit_images["csat"].file_type)
	end

    def test_empty_circuit
        c = SVGController.new("data/example_config.yaml")
        cir = Circuit.new
        io = ""
        c.draw_circuit(cir, io)
        svg = SVG.new
        io2 = ""
        svg.write(io2)
        assert_equal(io2, io)
    end

    def test_twobox
        c = SVGController.new("data/example_config.yaml")
        cir = Circuit.new_from_verilog("data/drawer_test_1.v")
        f = File.open("out/test_twobox.svg", "w")
        c.draw_circuit(cir, f)
        f.close()
    end

    def test_big
        c = SVGController.new("data/example_config.yaml")
        cir = Circuit.new_from_verilog("data/mult_arrayFlat_16_16.v")
        f = File.open("out/test_big.svg", "w")
        c.draw_circuit(cir, f)
        f.close()
    end
end
