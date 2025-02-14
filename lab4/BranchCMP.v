module BranchCMP (
    input signed [31:0] A,B,
    output reg BrEQ, BrLT
);

    // TODO: implement your ALU control here
assign BrEQ = (A == B)? 1'b1: 1'b0;
assign BrLT = (A < B)? 1'b1: 1'b0;

endmodule
