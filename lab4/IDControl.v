module IDControl (
    // inputs
    input [6:0] opcode,
    
    // outputs
    // ID stage
    // output reg PCsel, flush,
    // output reg pc_mux,  // if jalr -> pc = reg[rd] + imm | else: pc = pc + imm
                        // pc_mux is to select whether reg[rd] or pc 
                        // pc -> 0, reg[rd] -> 1 
    // EX stage
    output reg ALUSrc_A,  // tell ALU use imm or not
    output reg ALUSrc_B,  // tell ALU use PC or not -> unfinishedr
    output reg [1:0] ALUOp,  // tell ALU which type of inst is
    // M stage
    output reg memWrite,
    output reg memRead,
    // WB stage
    output reg regWrite,  // enable write to reg
    output reg [1:0] memtoReg,  // select which (mem/PC+4/ALU(branch)) to write to register
    // to harzard
    output reg use_rs1,
    output reg use_rs2
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
always @(*) begin
    case(opcode)
        7'b0110011: begin  // R-format
            ALUSrc_A = 1'b0;
            ALUSrc_B = 1'b0;
            memtoReg = 2'b01;
            regWrite = 1'b1;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b10;
            use_rs1 = 1'b1;
            use_rs2 = 1'b1;
        end
        7'b0010011: begin // I-format
            ALUSrc_A = 1'b0;
            ALUSrc_B = 1'b1;
            memtoReg = 2'b01;
            regWrite = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b0;
            ALUOp = 2'b11;
            use_rs1 = 1'b1;
            use_rs2 = 1'b0;
        end
        7'b0000011: begin  // lw
            ALUSrc_A = 1'b0;
            ALUSrc_B = 1'b1;
            memtoReg = 2'b00;
            regWrite = 1'b1;
            memRead = 1'b1;
            memWrite = 1'b0;
            ALUOp = 2'b00;
            use_rs1 = 1'b1;
            use_rs2 = 1'b0;
        end
        7'b0100011: begin  // sw
            ALUSrc_A = 1'b0;
            ALUSrc_B = 1'b1;
            memtoReg = 2'b00;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b1;
            ALUOp = 2'b00;
            use_rs1 = 1'b1;
            use_rs2 = 1'b1;
        end
        7'b1100011: begin  // B-format (branch)
            ALUSrc_A = 1'b1;
            ALUSrc_B = 1'b1;
            memtoReg = 2'b00;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b00;
            use_rs1 = 1'b1;
            use_rs2 = 1'b1;
        end
        7'b1101111: begin  // jal
            ALUSrc_A = 1'b1;
            ALUSrc_B = 1'b1;
            memtoReg = 2'b10;
            regWrite = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b0;
            ALUOp = 2'b00;
            use_rs1 = 1'b0;
            use_rs2 = 1'b0;
            end
        7'b1100111: begin  // jalr
            ALUSrc_A = 1'b0;
            ALUSrc_B = 1'b1;
            memtoReg = 2'b10;
            regWrite = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b0;
            ALUOp = 2'b00;
            use_rs1 = 1'b1;
            use_rs2 = 1'b0;
            end
        default: begin
            ALUSrc_A = 1'b0;
            ALUSrc_B = 1'b0;
            memtoReg = 2'b00;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b00;
            use_rs1 = 1'b1;
            use_rs2 = 1'b1;
        end
    endcase
end    

endmodule

