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
    wire y[4:0];

endmodule

module buffer(in, out);
    input in;
    output out;
endmodule;

module and2(a, b, c);
    input a;
    input b;
    output c;
endmodule
