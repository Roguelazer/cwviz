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

# Struct-like class to represent a single Scot element definition
class ScotElement
    attr_accessor :Trise, :Tfall, :WN, :WP
end

class ScotParser
    @@trise_signal_regexp = /^(?!X|mean|MEAN)([^\.\s]*)\.Trise\s+((?:\d|\.|e|-)+)/x
    @@tfall_signal_regexp = /^(?!X|mean|MEAN)([^\.\s]*)\.Tfall\s+((?:\d|\.|e|-)+)/x
    @@renaming_regexp = /^(.+)_(\d+)/

    attr_reader :elements, :latest_time

    def initialize
        @elements = Hash.new
        @latest_time = 0.0
    end

    # Parse a single file
    def parse(filename)
        f = File.open(filename, "r")
        lines = f.readlines()
        f.close()
        elements = Hash.new
        lines.each do |line|
            if (md = @@trise_signal_regexp.match(line))
                name = md[1]
                time = md[2].to_f
                if (md2 = @@renaming_regexp.match(md[1]))
                    name = md2[1] + "[" + md2[2] + "]"
                end
                if (not @elements.has_key?(name))
                    @elements[name] = Hash.new
                end
                @elements[name]["Trise"] = time
                if (time > @latest_time)
                    @latest_time = time
                end
            elsif (md = @@tfall_signal_regexp.match(line))
                name = md[1]
                time = md[2].to_f
                if (md2 = @@renaming_regexp.match(md[1]))
                    name = md2[1] + "[" + md2[2] + "]"
                end
                if (not @elements.has_key?(name))
                    @elements[name] = Hash.new
                end
                @elements[name]["Tfall"] = time
                if (time > @latest_time)
                    @latest_time = time
                end
            end
        end
    end

    def print_elements
        @elements.each { |k, v|
            puts "#{k}: rise=#{v['Trise']}, fall=#{v['Tfall']}"
        }
    end
end

s = ScotParser.new
s.parse(ARGV[0])
puts "Latest time was #{s.latest_time}"
