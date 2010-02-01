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

require "circuit"
require "svg"
require "yaml"

$RESOURCE_BASE=File.join(File.dirname(__FILE__), "..", "resources")

# This class interfaces between the Circuit model and the SVG drawer
class SVGController
    attr_reader :circuit_images

    # The CircuitImage class represents a single circuit type's  image
    class CircuitImage
        attr_reader :file_type
        attr_reader :file_name
        attr_reader :width
        attr_reader :height

        # Initialize this CircuitImage
        #
        # Arguments:
        # file_type:: The file type (string)
        # file_name:: A relative path to the source file
        # width:: width of the circuit element (in lambda)
        # height:: height of the circuit element (in lambda)
        # type:: The string representing the type of this image (AND, etc.)
        # ci:: A hash of extra parameters
        def initialize(file_type, file_name, width, height, type, ci = {})
            @file_type = file_type.downcase()
            if (@file_type == "png" || @file_type == "svg")
                @file_name = File.join($RESOURCE_BASE, file_name)
            end
            @width = width
            @height = height
            @ci = ci
            @type = type
        end

        # Get the SVG to draw this CircuitImage
        #
        # Arguments:
        # x:: The x-coordinate to draw at
        # y:: The y-coordinate to draw at
        # ele:: The CircuitElement to draw
        def svg(x, y, ele)
            optmap = {
                "fill" => :fill,
                "stroke" => :stroke,
                "id" => :id,
                "stroke_width" => :stroke_width,
                "scale_mode" => :scale
            }
            options = {:scale => "constant"}
            optmap.each { |k, v|
                if @ci[k]
                    options[v] = @ci[k]
                end
            }
            options[:text] = case @ci["label"]
            when "type"
                @type
            when "name"
                ele.name
            when "name_full"
                ele.name_full
            else
                false
            end
            obj = case @file_type
            when "rect":
                SVG::Rect.new(x, y, @width, @height, options)
            when "png"
                SVG::Image.new(x, y, @width, @height, @file_name, options)
            when "svg"
                SVG::Image.new(x, y, @width, @height, @file_name, options)
            when "textrect"
                @ci["label"] = "type"
                SVG::Rect.new(x, y, @width, @height, options)
            end
            return obj
        end
    end

    # Construct the SVGController
    #
    # Arguments
    # file_name:: The path to a configuration file
    # autosize:: Either false or the path to a verilog file
    def initialize(file_name, autosize)
        load_from_yaml(YAML.load_file(file_name))
        if autosize != false
            vl = VerilogSizes.new(autosize)
            sizes = vl.load_sizes_from_verilog()
        end
    end

    # Load from a given YAML Object
    def load_from_yaml(yaml_obj)
        global_options = yaml_obj["defaults"] || {}
        @circuit_images = {}
        yaml_obj["circuit_images"].each { |ci|
            opts = global_options.merge(ci)
            imobj = CircuitImage.new(opts["image_type"], opts["image"],
                                    opts["width"], opts["height"], opts["type"],
                                    opts)
            @circuit_images[ci["type"].downcase()] = imobj
        }
        # If no default was provided, just draw an 80x80 Rect
        if not @circuit_images.has_key?("default")
            @circuit_images["default"] = CircuitImage.new("TextRect", "",
                                                          80, 80, "default")
        end
    end

    # Draw a circuit to an IO stream
    #
    # Arguments:
    # circuit:: The Circuit to draw
    # io: an IO object to draw to
    def draw_circuit(circuit, io)
        $stderr.puts "Beginning draw phase" if $verbose
        max_x = circuit.bounding_box["x"]
        max_y = circuit.bounding_box["y"]
        drawer = SVG.new(max_x, max_y)
        circuit.each { |circuit_element|
            im = nil
            if @circuit_images.has_key?(circuit_element.type.downcase())
                im = @circuit_images[circuit_element.type.downcase()]
            else
                im = @circuit_images["default"]
            end
            real_x = max_x - circuit_element.x - im.width
            real_y = circuit_element.y
            svg = im.svg(real_x, real_y, circuit_element)
            drawer.add_element(svg)
        }
        io = drawer.write(io)
        $stderr.puts "Finished draw phase" if $verbose
        return io
    end

    private :load_from_yaml, :load_sizes_from_verilog
end
