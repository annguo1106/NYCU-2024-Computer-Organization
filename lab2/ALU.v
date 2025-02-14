module ALU (
    input [3:0] ALUctl,
    input signed [31:0] A,B,
    output reg signed [31:0] ALUOut
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not (or you can change the design as you wish)

    // TODO: implement your ALU here
    // Hint: you can use operator to implement
    always @(ALUctl or A or B) begin
        case(ALUctl)
            // and
            4'b0000: ALUOut <= A & B;
            // or
            4'b0001: ALUOut <= A | B;
            // add
            4'b0010: ALUOut <= A + B;
            // subtract
            4'b0110: ALUOut <= A - B;
            // slt
            4'b1000: begin if(A < B) ALUOut <= 1; else ALUOut <= 0; end
            default: ALUOut <= A;
        endcase
    end
endmodule

