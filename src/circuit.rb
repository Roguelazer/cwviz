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

# This class represents a complete circuit
class Circuit
    # Elements is a list of circuit elements
    @elements

    # Constructor
    def init
        @elements = Array.new()
    end

    # Create a new Circuit object from a Verilog file
    #
    # Arguments:
    # file_path:: A string containing the path to the file
    #
    # Returns:
    # A new, initialized circuit
    def self.init_from_verilog(file_path)
        c = Circuit.new()
        c.load_verilog_file(file_path)
    end

    # Load a file into the current Circuit
    #
    # Arguments:
    # file_path:: A string containing the path to the file to load
    # root_mod:: The name of the root module to visualize. If nil, will
    #   visualize whatever module is defined first.
    def load_verilog_file(file_path, root_mod=nil)
        File.open(file_path, "r") do |f|
            f.lines.each do |l|

            end
        end
    end
end
