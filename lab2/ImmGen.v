module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] inst,
    output reg signed [31:0] imm
);
    // ImmGen generate imm value base opcode

    wire [6:0] opcode = inst[6:0];
    always @(opcode, inst) begin
        case(opcode)
            // TODO: implement your ImmGen here
            // Hint: follow the RV32I opcode map (table in spec) to set imm value
             // B format
            7'b1100011:
                imm <= {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            // lw
            7'b0000011:
                imm <= {{21{inst[31]}}, inst[30:20]};
            // sw
            7'b0100011:
                imm <= {{21{inst[31]}}, inst[30:25], inst[11:7]};
            // I foramt
            7'b0010011:
                imm <= {{21{inst[31]}}, inst[30:20]};
            // jal
            7'b1101111:
                imm <= {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            // jalr
            7'b1100111:
                imm <= {{20{inst[31]}}, inst[31:20]};
            // R format and other
            default: imm <= 0;
        endcase
    end

endmodule

