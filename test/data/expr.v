module m(input x, output y);
    assign y = ~x;
    wire q;
    assign q = y & x;
    wire z;
    assign z = (y & x) | q;
endmodule
