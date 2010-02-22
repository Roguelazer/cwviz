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
require 'util.rb'

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
        @latest_time = -1.0
        @slowest_time = -1.0
    end

    # Annotate a circuit with scot information. Currently, only does
    # relative delays using output information
    #
    # circuit:: A circuit module to annotate
    # absolute_delay:: Use absolute instead of relative delay (e.g., use
    # the actual processing time taken per-element instead of the signal
    # time. Confusing terminology, I know)
    def annotate(circuit, absolute_delay=false)
        circuit.each { |element|
            latest_time = -1.0
            earliest_time = 1.0/0 # Infinity. Should be a builtin, but isn't.
            element.each_input { |arg|
                if (Util.looks_like_number?(arg))
                    # Don't bother looking for rise/fall times of numbers...
                    next
                end
                if @sp.elements.has_key?(arg)
                    t = @sp.elements[arg]["Tlatest"]
                if (t < earliest_time)
                        earliest_time = t
                    end
                elsif (e = @sp.elements.find { |k,v|  v["orig_name"] == arg })
                    t = e[1]["Tlatest"]
                    if (t < earliest_time)
                        earliest_time = t
                    end
                else
                    puts "Could not find arg #{arg} for element #{element.name}"
                    next
                end
            }
            element.each_output { |arg|
                if (Util.looks_like_number?(arg))
                    # Don't bother looking for rise/fall times of numbers...
                    next
                end
                if @sp.elements.has_key?(arg)
                    t = @sp.elements[arg]["Tlatest"]
                    if (t > latest_time)
                        latest_time = t
                    end
                elsif (e = @sp.elements.find { |k,v|  v["orig_name"] == arg })
                    t = e[1]["Tlatest"]
                    if (t > latest_time)
                        latest_time = t
                    end
                else
                    puts "Could not find arg #{arg} for element #{element.name}"
                    next
                end
            }
            if (earliest_time  == (1.0/0))
                earliest_time = latest_time
            end
            element.props["Tout"] = latest_time
            element.props["Tin"] = earliest_time
            element.props["Tdelta"] = latest_time - earliest_time
        }
        circuit.each { |element|
            if (element.props["Tdelta"] > @slowest_time)
                @slowest_time = element.props["Tdelta"]
            end
            if (element.props["Tout"] > @latest_time)
                @latest_time = element.props["Tout"]
            end
            if (element.props["Tin"] > @latest_time)
                @latest_time = element.props["Tin"]
            end
        }
        puts "Slowest time was #{@slowest_time}; latest time was #{@latest_time}" if $verbose
        # Actually annotate the opts
        circuit.each { |element|
            if absolute_delay
                element.opts["fill"] = HeatColor.color_string(element.props["Tdelta"] / @slowest_time)
            else
                element.opts["fill"] = HeatColor.color_string(element.props["Tout"] / @latest_time)
            end
        }
    end
end
