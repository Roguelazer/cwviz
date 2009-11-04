module Box;
    wire w1;
    wire w2;
    Box b1_0_0(w1);
    Box b2_80_0(w2);
    nand2 a_160_160(w1, w2);
endmodule
