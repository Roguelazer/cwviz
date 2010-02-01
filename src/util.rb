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

# Utility functions. Included all over the place

class Util
    @@normal_number = Regexp.compile(/^\d+$/)
    @@base_number = Regexp.compile(/^(\d)*'(b|h)([01]*)$/)

    # Convert verilog representations of numbers to native Ruby ones
    def self.verilog_to_number(verilog)
        # Always ignore underscores
        verilog.sub!("_", "")
        if(verilog =~ @@normal_number)
            return verilog.to_i
        elsif(verilog =~ @@base_number)
            len = $1.to_i
            data = $3
            if (len != 0 and len < data.length)
                data.slice!(-len..-1)
            end
            base = (if $2 == 'b'
                'b'
            elsif $2 == 'h'
                'x'
            end)
            num = Integer('0' + base + data)
            return num
        end
        raise Error
    end
end
