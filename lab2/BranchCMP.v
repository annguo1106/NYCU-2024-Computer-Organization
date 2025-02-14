module BranchCMP (
    input signed [31:0] A,B,
    output reg BrEq, BrLT
);

    // TODO: implement your ALU control here
assign BrEq = (A == B)? 1'b1: 1'b0;
assign BrLT = (A < B)? 1'b1: 1'b0;

endmodule

