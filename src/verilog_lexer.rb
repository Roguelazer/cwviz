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

# This class is a helper to do some simple lexing of the Verilog file.
# It doesn't actually tokenize (which is, of course, the main point of a
# lexer), but does strip comments and other things that are obnoxious to do
# in a push-down grammar
module VerilogLexer
    # Process a string
    #
    # Arguments:
    # str:: The string to process
    #
    # Returns:
    # The processed string
    def self.LexString(str)
        str = self.StripComments(str)
        str = self.NewlinesToSpaces(str)
        str = self.TabsToSpaces(str)
        str = self.StripTrailing(str)
        return str
    end

    def self.StripComments(str)
        str.gsub!(/\/\/[^\n]*/, "")
        str.gsub!(/\/\*([^\*]*)\*(\*|([^\*\/][^*]*\*))*\//, "")
        return str
    end

    def self.NewlinesToSpaces(str)
        str.gsub!("\n", " ")
        return str
    end

    def self.TabsToSpaces(str)
        str.gsub!("\t", " ")
        str.gsub!(/ +/, " ")
        return str
    end

    # Strip trailing whitespace
    def self.StripTrailing(str)
        str.gsub!(/\A\s*(\S.*\S)\s*\Z/m, '\1')
        return str
    end
end
