module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] inst,
    output reg signed [31:0] imm
);
    // ImmGen generate imm value base opcode

    wire [6:0] opcode = inst[6:0];
    always @(*) begin
        case(opcode)
            // TODO: implement your ImmGen here
            // Hint: follow the RV32I opcode map (table in spec) to set imm value
            // lw
            7'b0000011:
                imm = {{20{inst[31]}}, inst[31:20]};
            // sw
            7'b0100011:
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            // I foramt
            7'b0010011:
                imm = {{20{inst[31]}}, inst[31:20]};
            // R format and other
            default: imm = {32{1'b0}};
        endcase
    end

endmodule

