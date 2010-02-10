module First (x);
    input x;

    wire z[4:0];
    and2 a00(z[1], z[2], z[3]);
    and2 a01(z[1], z[2], z[4]);
endmodule

module Second;
    wire y[4:0];
    and2 a00(y[1], y[2], y[3]);
    and2 a01(y[1], y[2], y[3]);
endmodule

module Third;
    wire x[4:0];
    buffer b0(x[0], x[1]);
    buffer b1(x[1], x[2]);
    buffer b2(x[2], x[3]);
    buffer b3(x[3], x[4]);
endmodule

module buffer(in, out);
    input in;
    output out;
endmodule

module and2(a, b, c);
    input a;
    input b;
    output c;
endmodule
