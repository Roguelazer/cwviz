module First (x);
    input x;
    CSA CSA_10_0(x);
    CSA CSA_0_10(x);
endmodule

module Second (y, z);
    input y;
    output z;

    CSA CSA_10_0(x);
    CSA CSA_80_0(x);
    CSA CSA_160_0(x);
endmodule
