module First (x);
    input x;

    wire z[8:0];
    and2 a00(z[1], z[2], z[3]);
    and2 a01(z[1], z[2], z[4]);
endmodule

module and2(a, b, c);
    input a;
    input b;
    output c;
endmodule
