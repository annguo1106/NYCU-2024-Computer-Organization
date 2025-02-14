module ALU (
    input [3:0] ALUctl,
    input signed [31:0] A,B,
    output reg signed [31:0] ALUOut,
    output zero
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not (or you can change the design as you wish)

    
    // TODO: implement your ALU here
    // Hint: you can use operator to implement
    always @(ALUctl or A or B) begin
        case(ALUctl)
            // and
            4'b0000: begin zero <= 0; ALUOut <= A & B; end
            // or
            4'b0001: begin zero <= 0; ALUOut <= A | B; end
            // add
            4'b0010: begin zero <= 0; ALUOut <= A + B; end
            // subtract
            4'b0110: begin if(A == B) zero <= 1; else zero <= 0; ALUOut <= A - B; end
            4'b1000: begin if(A < B) ALUOut <= 1; else ALUOut <= 0; zero <= 0; end//slt
            default: begin zero <= 0; ALUOut <= A; end
        endcase
    end
endmodule
