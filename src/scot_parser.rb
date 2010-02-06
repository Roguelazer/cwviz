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
    @@trise_regexp = /^(?!X|mean|MEAN)([^\.\s]*)\.Trise\s+((?:\d|\.|e|-)+)/x

    # Parse a single file
    def self.parse(filename)
        f = File.open(filename, "r")
        lines = f.readlines()
        f.close()
        elements = Hash.new
        lines.each do |line|
            if (md = @@trise_regexp.match(line))
                puts "Element = %s" % md[1]
                puts "Rise time = %f" % md[2].to_f
            end
        end
    end
end

ScotParser.parse(ARGV[0])
