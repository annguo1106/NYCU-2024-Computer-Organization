module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

// TODO: implement your ALU control here
// For testbench verifying, Do not modify input and output pin
// Hint: using ALUOp, funct7, funct3 to select exact operation
always @(*) begin
    // 4'b0000: and
    // 4'b0001: or
    // 4'b0010: add
    // 4'b0110: subtract
    // 4'b1000: slt 
    case(ALUOp)
        2'b10:
            case({funct7, funct3})
                4'b0_111: ALUCtl = 4'b0000;  // and
                4'b0_110: ALUCtl = 4'b0001;  // or
                4'b0_000: ALUCtl = 4'b0010;  // add
                4'b1_000: ALUCtl = 4'b0110;  // sub
                4'b0_010: ALUCtl = 4'b1000;  // slt
                default: ALUCtl = 4'b0010;  // add
            endcase
        2'b11:
            case({funct3})
                3'b111: ALUCtl = 4'b0000;  // andi
                3'b110: ALUCtl = 4'b0001;  // ori
                3'b000: ALUCtl = 4'b0010;  // addi
                3'b010: ALUCtl = 4'b1000;  // slti
                default: ALUCtl = 4'b0010;  // add
            endcase
        2'b00: ALUCtl = 4'b0010;  // add
        default: ALUCtl = 4'b0010;  // add
    endcase
end
endmodule

