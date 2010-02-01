module First (x);
    input x;
    CSA csa1_0_10(x);
    CSA csa2_10_0(1'b0);
endmodule

module Second (y, z);
    input y;
    output z;

    CSA CSA_10_0(x);
    CSA CSA_80_0(x);
    CSA CSA_160_0(x);
endmodule

module CSA(item);
    input item;

    // Do nothing! Woo!
endmodule
