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
require 'singleton'

# Basic SVG document
class SVG
    # Generates element IDs for SVG objects
    class IDGenerator
        include Singleton
        def initialize
            reset()
        end

        def self.reset()
            self.instance().reset()
        end

        def reset
            @counters = Hash.new()
            @counter_len = 6
            @prefix = "id"
            @counters[@prefix] = 0
        end

        def next
            @counters[@prefix] += 1
            return ("%s%0.#{@counter_len}d" % [@prefix, @counters[@prefix]])
        end

        def self.next()
            return self.instance().next()
        end

        def next_with_prefix(p)
            old_prefix = @prefix
            self.prefix=p
            retval = self.next()
            self.prefix=old_prefix
            return retval
        end

        def self.next_with_prefix(p)
            return self.instance().next_with_prefix(p)
        end

        def prefix=(p)
            @prefix = p
            unless @counters.has_key?(p)
                @counters[p] = 0
            end
        end

        def self.prefix=(p)
            return self.instance().prefix=p
        end
    end

    class Object
        attr_accessor :fill, :stroke, :stroke_width, :scale

        def initialize(options)
            @fill = options[:fill] || "#cccccc"
            @stroke = options[:stroke] || "0"
            @stroke_width = options[:stroke_width] || 0
            @scale = options[:scale] || false
            @scale_factor = 0.9
            @id = options[:id] || :auto_generate
            if (@id == :auto_generate)
                @id_prefix = options[:id_prefix] || "id"
            end
        end

        # Add the correct ID, obeying the id and id_prefix settings, to an
        # XML::Node
        def add_id(node)
            if (@id == :auto_generate)
                node["id"] = IDGenerator.next_with_prefix(@id_prefix)
            else
                node["id"] = @id
            end
            return node
        end

        # Wrap a node in a scaling <g>. Return the new, wrapped node
        def scale(node)
            wrapper = XML::Node.new("g")
            xtrans = @x.to_f * (1.0-@scale_factor) + ((1.0-@scale_factor)/2.0) * @width
            ytrans = @y.to_f * (1.0-@scale_factor) + ((1.0-@scale_factor)/2.0) * @height
            scaler = "scale(#{@scale_factor})"
            translater = "translate(#{xtrans}, #{ytrans})"
            wrapper["transform"] = scaler + " " + translater
            wrapper << node
            return wrapper
        end

        def get_style
            return "fill:#{@fill};fill-opacity:1;stroke:#{@stroke};stroke-width:#{@stroke_width};"
        end
    end

    class Rect < SVG::Object
        attr_reader :x, :y, :width, :height

        def initialize(x, y, width, height, options = {})
            @x = x
            @y = y
            @width = width
            @height = height
            # Set defaults for id prefix and other parametsr
            defaults = {
                :id_prefix => "rect",
                :fill => "#cccccc",
                :stroke => "black",
                :stroke_width => 1
            }
            defaults.each { |key,value|
                unless options.has_key?(key)
                    options[key] = value
                end
            }
            super(options)
        end

        def xml
            e = XML::Node.new("rect")
            e["x"] = @x.to_s
            e["y"] = @y.to_s
            e["width"] = @width.to_s
            e["height"] = @height.to_s
            e["style"] = get_style()
            add_id(e)
            if @scale
                e = scale(e)
            end
            return e
        end
    end

    class TextRect < SVG::Rect
        def initialize(x, y, width, height, name, options={})
            @name = name
            super(x, y, width, height, options)
        end

        def xml
            group = XML::Node.new("g")
            e = XML::Node.new("text")
            e["x"] = (@x + @width/2.0).to_s
            e["y"] = (@y + @height/2.0).to_s
            e["width"] = @width.to_s
            e["height"] = @height.to_s
            #e["style"] = get_style()
            e["text-anchor"] = "middle"
            e["alignment-baseline"] = "central"
            e << @name
            old_scale = @scale
            @scale = false
            group << super()
            group << e
            @scale = old_scale
            if @scale
                group = scale(group)
            end
            return group
        end
    end

    class Image < SVG::Object
        attr_reader :x, :y, :width, :height
        attr_reader :source

        def initialize(x, y, width, height, source, options={})
            @x = x
            @y = y
            @width = width
            @height = height
            @source = source
            @preserve_aspect_ratio = options[:preserve_aspect_ration] || false
            unless options.has_key?(:id_prefix)
                options[:id_prefix] = "image"
            end
            super(options)
        end

        def xml
            e = XML::Node.new("image")
            e["x"] = @x.to_s
            e["y"] = @y.to_s
            e["preserveAspectRatio"] = @preserve_aspect_ratio ? "xMidYMid" : "None"
            #e["viewBox"] = "0 0 #{@width} #{@height}"
            e["width"] = @width.to_s
            e["height"] = @height.to_s
            e["xlink:href"] = File.expand_path(@source.to_s)
            e["style"] = get_style()
            add_id(e)
            if (@scale)
                e = scale(e)
            end
            return e
        end
    end

    # Constructor
    def initialize(width=nil, height=nil)
        @width = width
        @height = height
        @elements = []
    end

    # Write out the SVG document to an IO
    def write(io)
        @xml = XML::Document.new(xml_version="1.0")
        @xml.root = XML::Node.new("svg")
        @xml.root["xmlns:svg"] = "http://www.w3.org/2000/svg"
        @xml.root["xmlns:xlink"] = "http://www.w3.org/1999/xlink"
        @xml.root["xmlns"] = "http://www.w3.org/2000/svg"
        @xml.root["version"] = "1.0"
        unless (@width.nil? or @height.nil? or (@width ==0 and @height == 0))
            @xml.root["width"] = @width.to_s
            @xml.root["height"] = @height.to_s
        end
        @elements.each { |e|
            @xml.root << e
        }
        io << @xml.to_s
    end

    # Add an element. Should be a SVG::Object descendant
    def add_element(node)
        @elements.push(node.xml)
    end
end
