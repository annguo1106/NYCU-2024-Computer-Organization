module Control (
    // inputs
    input [6:0] opcode,
    
    // outputs

    // EX stage
    output reg ALUSrc,  // tell ALU use imm or not
    output reg [1:0] ALUOp,  // tell ALU which type of inst is
    // M stage
    output reg memWrite,
    output reg memRead,
    // WB stage
    output reg regWrite,  // enable write to reg
    output reg memtoReg  // select which (mem/PC+4/ALU(branch)) to write to register
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
always @(*) begin
    case(opcode)
        7'b0110011: begin  // R-format
            ALUSrc = 1'b0;
            memtoReg = 1'b0;
            regWrite = 1'b1;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b10;
        end
        7'b0010011: begin // I-format
            ALUSrc = 1'b1;
            memtoReg = 1'b0;
            regWrite = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b0;
            ALUOp = 2'b11;
        end
        7'b0000011: begin  // lw
            ALUSrc = 1'b1;
            memtoReg = 1'b1;
            regWrite = 1'b1;
            memRead = 1'b1;
            memWrite = 1'b0;
            ALUOp = 2'b00;
        end
        7'b0100011: begin  // sw
            ALUSrc = 1'b1;
            memtoReg = 1'bx;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b1;
            ALUOp = 2'b00;
        end
        default: begin
            ALUSrc = 1'b0;
            memtoReg = 1'b0;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b00;
        end
    endcase
end    

endmodule

