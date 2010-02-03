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


class VerilogSizes
    # maximum number of iterations
    MAX_ITER=15

    attr_reader :sizes

    def initialize(filename)
        @filename = filename
        @sizes = Hash.new
    end

    def printl(list)
        print "["
        list.each { |item|
            print item
            print ", "
        }
        print "]"
    end

    # Yay for a little recursive-descent?
    #
    # <expr>     := <summand> - <expr> | <factor>
    # <factor>   := <multand> * <expr> | <aexp>
    # <aexp>     := <num> | size(name)
    def parse_expr(tokens)
        ret = parse_factor(tokens)
        parse = ret[0]
        rest = ret[1]
        if (rest.first == "+")
            factor_ret = parse_expr(rest.slice(1,rest.length-1))
            factor_parse = factor_ret[0]
            factor_rest = factor_ret[1]
            return [parse + factor_parse, factor_rest]
        elsif (rest.first == "-")
            factor_ret = parse_expr(rest.slice(1,rest.length-1))
            factor_parse = factor_ret[0]
            factor_rest = factor_ret[1]
            return [parse - factor_parse, factor_rest]
        else
            return ret
        end
    end

    def parse_factor(tokens)
        ret = parse_aexp(tokens)
        parse = ret[0]
        rest = ret[1]
        if (rest.first == "*")
            factor_ret = parse_factor(rest.slice(1,rest.length-1))
            factor_parse = factor_ret[0]
            factor_rest = factor_ret[1]
            return [parse * factor_parse, factor_rest]
        else
            return ret
        end
    end

    def parse_aexp(tokens)
        if (tokens.first =~ /size\((\w+)\)/)
            if @sizes[$1].nil?
                throw :failure
            end
            return [@sizes[$1], tokens.slice(1,tokens.length-1)]
        else
            return [tokens.first.to_i, tokens.slice(1,tokens.length-1)]
        end
    end

    def tokenize(string)
        delimiters = ['*', '+', '-']
        @tokens = []
        accumulator = ""
        string.each_char { |c|
            if (c =~ /\s/)
                next
            elsif (delimiters.include?(c))
                @tokens.push(accumulator)
                @tokens.push(c)
                accumulator = ""
            else
                accumulator += c
            end
        }
        @tokens.push(accumulator)
        return @tokens
    end

    def load_sizes_from_verilog()
        File.open(@filename, "r") { |f|
            # AAGH
            # This code is ugly
            # We need to iterate until we clear up all of the used names,
            # since they're not necessarily defined before used
            # UGLY
            # UGLY 
            # UGLY!
            iters = 0
            while(true)
                iters += 1
                complete = true
                f.rewind()
                f.each do |l|
                    if (l =~ /<\s*size\((\w+)\)\s*=\s*(\d+)\s*>/)
                        @sizes[$1] = $2.to_i
                    elsif (l =~ /<\s*size\((\w+)\)\s*=\s*([^\s][^>]+)\s*>/) 
                        name = $1
                        if (@sizes.has_key?(name))
                            next
                        end
                        catch :failure do
                            tokens = tokenize($2)
                            size = parse_expr(tokens)[0]
                            @sizes[name] = size
                        end
                        if(!@sizes.has_key?(name) or @sizes[name].nil?)
                            $stderr.puts "Can't resolve #{name}; trying again." if ($verbose)
                            $stderr.puts "In the future, I appreciate it if you define" if ($verbose)
                            $stderr.puts "things before you use them" if ($verbose)
                            complete = false
                            if (iters > MAX_ITER)
                                $stderr.puts "Could not resolve cell #{name} in verilog sizes; giving up"
                                @sizes.delete(name)
                                return
                            end
                        end
                    end
                end
                if (complete == true)
                    break
                end
            end
        }
    end
    
    private :parse_expr, :parse_factor, :parse_aexp, :tokenize
end
