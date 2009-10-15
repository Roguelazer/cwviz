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

require 'treetop'
require 'verilog.rb' # The Treetop-generated parser
require 'verilog_lexer.rb'

class VlParser
    # Constructor
    def initialize
        @parser = VerilogParser.new()
    end

    # Parse a string.
    # Returns the parsed syntax tree
    def parse(str)
        lexed = VerilogLexer.LexString(str)
        res = @parser.parse(lexed)
        return res
    end

    # Parse a file
    # Returns the parsed syntax tree
    #
    # Arguments:
    # path:: The file path
    def parse_file(path)
        str = File.open(path, "r") { |f|
            f.readlines().join("\n")
        }
        parse(str)
    end

    # Get the reason for a failure
    def failure_reason
        @parser.failure_reason
    end
end
