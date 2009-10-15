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
#
# This file is for serialization to SVG

require 'xml'

# Basic SVG document
class SVG
	class Object
		attr_accessor :fill, :stroke, :stroke_width
	end

	class Rect < SVG::Object
		def initialize(x, y, width, height)
			@x = x
			@y = y
			@width = width
			@height = height
		end

		def xml
			e = XML::Node.new("rect")
			e["x"] = @x
			e["y"] = @y
			e["width"] = @width
			e["height"] = @height
			e["fill"] = @fill
			e["stroke"] = @stroke
			e["stroke-width"] = @stroke_width
			return e
		end
	end

	# Constructor
	def initialize
		@elements = []
	end

	# Write out the SVG document to an IO
	def write(io)
		@xml = XML::Document.new(xml_version="1.0")
		@xml.root = XML::Node.new("svg")
		@xml.root["xmlns:svg"] = "http://www.w3.org/2000/svg"
		@xml.root["xmlns"] = "http://www.w3.org/2000/svg"
		@xml.root["version"] = "1.0"
		@elements.each { |e|
			@xml.root << e
		}
		io.print(@xml.to_s())
	end

	# Add an element. Should be a SVG::Object descendant
	def add_element(node)
		@elements.push(node.xml)
	end
end
