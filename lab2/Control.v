module Control (
    input [6:0] opcode,
    input [2:0] func3,
    input BrEq, BrLT,
    output reg PCsel,
    output reg memRead,
    output reg [1:0] memtoReg,  // whether the mem/PC+4/ALU(branch) write to register
    output reg [2:0] ALUOp,  // tell ALU which type of inst is
    output reg memWrite,
    output reg ALUSrc_A,  // tell ALU use PC or regmem
    output reg ALUSrc_B,  // tell ALU use imm or not
    output reg regWrite
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
always @(opcode or func3) begin
    case(opcode)
        7'b0110011: begin  // R-format
            ALUSrc_A <= 1'b0;
            ALUSrc_B <= 1'b0;
            memtoReg <= 2'b01;
            regWrite <= 1'b1;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            PCsel <= 1'b0;
            ALUOp <= 3'b010;
        end
        7'b0010011: begin // I-format
            ALUSrc_A <= 1'b0;
            ALUSrc_B <= 1'b1;
            memtoReg <= 2'b01;
            regWrite <= 1'b1;
            memWrite <= 1'b0;
            memRead <= 1'b0;
            PCsel <= 1'b0;
            ALUOp <= 3'b011;
        end
        7'b0000011: begin  // lw
            ALUSrc_A <= 1'b0;
            ALUSrc_B <= 1'b1;
            memtoReg <= 2'b00;
            regWrite <= 1'b1;
            memRead <= 1'b1;
            memWrite <= 1'b0;
            PCsel <= 1'b0;
            ALUOp <= 3'b000;
        end
        7'b0100011: begin  // sw
            ALUSrc_A <= 1'b0;
            ALUSrc_B <= 1'b1;
            memtoReg <= 2'bxx;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b1;
            PCsel <= 1'b0;
            ALUOp <= 3'b000;
        end
        7'b1100011: begin  // B-format (branch)
            ALUSrc_A <= 1'b1;
            ALUSrc_B <= 1'b1;
            memtoReg <= 2'bxx;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            ALUOp <= 3'b001;
            case(func3)
                // beq
                3'b000: begin
                    case(BrEq)
                    1'b1: PCsel <= 1'b1;
                    1'b0: PCsel <= 1'b0;
                    endcase
                end
                // bne
                3'b001: begin
                    case(BrEq)
                    1'b0: PCsel <= 1'b1;
                    1'b1: PCsel <= 1'b0;
                    endcase
                end
                // blt
                3'b100: begin
                    case(BrLT)
                    1'b1: PCsel <= 1'b1;
                    1'b0: PCsel <= 1'b0;
                    endcase
                end
                // bge
                3'b101: begin
                    case(BrLT)
                    1'b0: PCsel <= 1'b1;
                    1'b1: PCsel <= 1'b0;
                    endcase
                end
                default: begin
                    PCsel <= 1'b0;
                end
            endcase
        end
        7'b1101111: begin  // jal
                ALUSrc_A <= 1'b1;
                ALUSrc_B <= 1'b1;
                memtoReg <= 2'b10;
                regWrite <= 1'b1;
                memWrite <= 1'b0;
                memRead <= 1'b1;
                PCsel <= 1'b1;
                ALUOp <= 3'b101;
            end
        7'b1100111: begin  // jalr
                ALUSrc_A <= 1'b0;
                ALUSrc_B <= 1'b1;
                memtoReg <= 2'b10;
                regWrite <= 1'b1;
                memWrite <= 1'b0;
                memRead <= 1'b1;
                PCsel <= 1'b1;
                ALUOp <= 3'b111;
            end
        default: begin
            ALUSrc_A <= 1'b0;
            ALUSrc_B <= 1'b0;
            memtoReg <= 2'b00;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            PCsel <= 1'b0;
            ALUOp <= 3'b000;
        end
    endcase
end    

endmodule

