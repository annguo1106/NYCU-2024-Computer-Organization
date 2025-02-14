module EXControl (
    // inputs
    input [6:0] opcode,
    input [2:0] func3,
    input BrEQ, BrLT,
    // input stall,
    // input EXMEM_jump,
    // input MEMWB_jump,
    
    // outputs
    // ID stage
    output reg PCsel, flush //, IDEX_jump
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
always @(*) begin
    case(opcode)
        7'b1100011: begin  // B-format (branch)
            case(func3)
                3'b000: begin  // beq
                    // if(BrEQ && !EXMEM_jump && !MEMWB_jump && !stall) begin
                    //     PCsel = 1'b1;
                    //     flush = 1'b1;
                    //     IDEX_jump = 1'b1;
                    // end
                    // else begin
                    //     PCsel = 1'b0;
                    //     flush = 1'b1;
                    //     jump_IDEX = 1'b0;
                    // end
                    PCsel = BrEQ? 1'b1: 1'b0;
                end
                3'b001: begin  // bne
                    PCsel = BrEQ? 1'b0: 1'b1;
                end
                3'b100: begin  // blt
                    PCsel = BrLT? 1'b1: 1'b0;
                end
                3'b101: begin  // bge
                    PCsel = BrLT? 1'b0: 1'b1;
                end
                default: begin
                    PCsel = 1'b0;
                end
            endcase
            flush = PCsel;
        end
        7'b1101111: begin  // jal
            PCsel = 1'b1;
            flush = 1'b1;
            end
        7'b1100111: begin  // jalr
            PCsel = 1'b1;
            flush = 1'b1;
            end
        default: begin
            PCsel = 1'b0;
            flush = 1'b0;
        end
    endcase
end    

endmodule

