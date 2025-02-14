module ALUCtrl (
    input [2:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    // TODO: implement your ALU control here
    // For testbench verifying, Do not modify input and output pin
    // Hint: using ALUOp, funct7, funct3 to select exact operation
always @(ALUOp or funct7 or funct3) begin
    // 4'b0000: and
    // 4'b0001: or
    // 4'b0010: add
    // 4'b0110: subtract
    // 4'b1000: slt 
    case(ALUOp)
        3'b000: ALUCtl <= 4'b0010;  // lw sw
        3'b001: ALUCtl <= 4'b0010;  // branch
        3'b010: begin  // R - type
            case(funct3)
                3'b000: begin
                    case(funct7) 
                        1'b0: ALUCtl <= 4'b0010;  // add
                        1'b1: ALUCtl <= 4'b0110;  // sub
                    endcase
                end
                3'b111: ALUCtl <= 4'b0000;  // and
                3'b110: ALUCtl <= 4'b0001;  // or
                3'b010: ALUCtl <= 4'b1000;  // slt
                default: ALUCtl <= 4'bxxxx;
            endcase
        end
        3'b011: begin  // I - type
            case(funct3)
                3'b000: ALUCtl <= 4'b0010;  // addi
                3'b111: ALUCtl <= 4'b0000;  // andi
                3'b110: ALUCtl <= 4'b0001;  // ori
                3'b010: ALUCtl <= 4'b1000;  // slti
                default: ALUCtl <= 4'bxxxx;
            endcase
        end
        3'b101: ALUCtl <= 4'b0010;  // jal
        3'b111: ALUCtl <= 4'b0010;  // jalr
        default: ALUCtl <= 4'bxxxx;
    endcase
end
endmodule

