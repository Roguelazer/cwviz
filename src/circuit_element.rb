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

# This class represents a single circuit element
class CircuitElement
    # The X-coordinate of the circuit element
    attr_reader :x

    # The Y-coordinate of the circuit element
    attr_reader :y

    # The type of the circuitelement
    attr_reader :type

    # Constructor
    def initialize(type, x, y)
        @x = x.to_i
        @y = y.to_i
        @type = type
    end
end
