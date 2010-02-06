#!/usr/bin/ruby
# Copyright (C) 2009-2010 James Brown.
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

require 'scot_parser.rb'

# Turn a single spectrum in [0,1] into colors separated by warmth. 0 will be
# blue, 1 will be red
class HeatColor
    # Get an RGB color triple from a single float argument in [0..1]
    def self.color_triple(temp)
        return [(temp*255).to_i, 0, ((1-temp)*255).to_i]
    end

    # Get a color string suitable for use in SVG, etc. #rrggbb
    def self.color_string(temp)
        triple = self.color_triple(temp)
        return sprintf("#%02x%02x%02x", triple[0], triple[1], triple[2])
    end
end

class Scot
    attr_reader :latest_time

    def initialize(file_path)
        @sp = ScotParser.new
        @sp.parse(file_path)
        @latest_time = @sp.latest_time
    end

    # Annotate a circuit with scot information. Currently, only does
    # relative delays using output information
    #
    # circuit:: A circuit module to annotate
    def annotate(circuit)
        circuit.each { |element|
            latest_time = -1.0
            element.arguments.each { |arg|
                if @sp.elements.has_key?(arg)
                    # Normalize the times
                    t = @sp.elements[arg]["Tlatest"] / @latest_time
                    if (t > latest_time)
                        latest_time = t
                    end
                end
            }
            if (latest_time > 0)
                element.opts["fill"] = HeatColor.color_string(latest_time)
            end
        }
    end
end
