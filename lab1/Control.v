module Control (
    input [6:0] opcode,
    output reg branch,
    output reg memRead,
    output reg memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite
);

// TODO: implement your Control here
// Hint: follow the Architecture (figure in spec) to set output signal
always @(opcode) begin
    case(opcode)
        7'b0110011: begin  // R-format
            ALUSrc <= 1'b0;
            memtoReg <= 1'b0;
            regWrite <= 1'b1;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            branch <= 1'b0;
            ALUOp <= 2'b10;
        end
        7'b0000011: begin  // id
            ALUSrc <= 1'b1;
            memtoReg <= 1'b1;
            regWrite <= 1'b1;
            memRead <= 1'b1;
            memWrite <= 1'b0;
            branch <= 1'b0;
            ALUOp <= 2'b00;
        end
        7'b0100011: begin  // sd
            ALUSrc <= 1'b1;
            memtoReg <= 1'bx;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b1;
            branch <= 1'b0;
            ALUOp <= 2'b00;
        end
        7'b1100011: begin  // beq
            ALUSrc <= 1'b0;
            memtoReg <= 1'bx;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            branch <= 1'b1;
            ALUOp <= 2'b01;
        end
        7'b0010011:  // I-type
            begin
                ALUSrc <= 1'b1;
                memtoReg <= 1'b0;
                regWrite <= 1'b1;
                memWrite <= 1'b0;
                memRead <= 1'b0;
                branch <= 1'b0;
                ALUOp <= 2'b11;
            end
        default: begin
            ALUSrc <= 1'b0;
            memtoReg <= 1'b0;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            branch <= 1'b0;
            ALUOp <= 2'b00;
        end
    endcase
end 
endmodule

