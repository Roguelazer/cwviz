module HasOverlapsY;
    wire x;
    medbox mb1_0_0(x);
    medbox mb2_0_40(x);
endmodule

module HasOverlapsX;
    wire x;
    medbox mb1_0_0(x);
    medbox mb2_40_0(x);
endmodule

module HasNoOverlaps;
    wire x;
    medbox mb1_0_0(x);
    medbox mb2_0_80(x);
    medbox mb3_80_0(x);
    medbox mb4_80_80(x);
endmodule

module HasOverlapsAndNoOverlaps;
    wire x;
    medbox mb1_0_0(x);
    medbox mb2_0_40(x);
    medbox mb3_120_120(x);
endmodule

module MultiOverlap;
    wire x;

    medbox mb1_0_0(x);
    medbox mb2_0_40(x);
    medbox mb3_0_80(x);
endmodule
