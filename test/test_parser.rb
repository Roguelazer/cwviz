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

# This script tests the Verilog parser

require "treetop"
require "verilog.rb"
require "verilog_lexer.rb"
require "verilog_parser.rb"

class TestParser < Test::Unit::TestCase
    def setup
        @simple_str = File.open(File.join($DATA_BASE, "simple_verilog.v"), "r") { |f|
            f.readlines().join("\n")
        }
        @comment_str = File.open(File.join($DATA_BASE, "comment_test.v"), "r") { |f|
            f.readlines().join("\n")
        }
    end

    def test_lex()
        str = VerilogLexer.LexString(@comment_str)
        assert_equal("module Test; wire x; endmodule", str)
        str = VerilogLexer.LexString(@simple_str)
        assert_equal("module Hello (input x, output [31:0] y); CSA CSA_0_3(x[1], y[2], z); endmodule", str)
    end

    def test_simple_parse()
        parser = VerilogParser.new()
        res = parser.parse(VerilogLexer.LexString(@simple_str))
        assert_not_nil(res, "Failure reason: #{parser.failure_reason()}")
    end

    def test_parser_aggregate()
        parser = VlParser.new()
        res = parser.parse(@simple_str)
        assert_equal(1, res.modules.count, "There's only one module in this file")
        mod = res.modules[0]
        assert_equal("Hello", mod.module_name.to_s)
        assert_equal(2, mod.parameters.count)
        assert_equal("input", mod.parameters[0].type)
        assert_equal("output", mod.parameters[1].type)
        assert(!mod.parameters[0].array?)
        assert(mod.parameters[1].array?)
        assert_equal("[31:0]", mod.parameters[1].size)
        assert_equal(1, mod.content.statements.count)
        statement = mod.content.statements[0]
        assert_equal(:instantiation, statement.statement_kind)
        assert_equal("CSA", statement.type)
        assert_equal("CSA_0_3", statement.name)
        assert_equal(3, statement.arguments.count)
        assert(!statement.arguments[0].is_number?)
        assert_equal("x", statement.arguments[0].variable_name)
        assert_equal("y", statement.arguments[1].variable_name)
        assert_equal("z", statement.arguments[2].variable_name)
        assert_not_nil(statement.arguments[0].index)
        assert_not_nil(statement.arguments[1].index)
        assert_nil(statement.arguments[2].index)
        assert_equal(1, statement.arguments[0].index)
        assert_equal(2, statement.arguments[1].index)
    end

end
