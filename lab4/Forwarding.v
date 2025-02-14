module Forwarding(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] EXMEM_writeReg,  // address
    input [4:0] MEMWB_writeReg,
    input EXMEM_regwrite,  // enable
    input MEMWB_regwrite,
    // output
    output reg [1:0] forward_A,
    output reg [1:0] forward_B
);

always @(*) begin
    // EX harzard
    forward_A = 2'b00;
    forward_B = 2'b00;
    if(EXMEM_regwrite && EXMEM_writeReg != 0 && (EXMEM_writeReg == rs1)) begin
        forward_A = 2'b10;
    end
    if(EXMEM_regwrite && (EXMEM_writeReg != 0) && (EXMEM_writeReg == rs2)) begin
        forward_B = 2'b10;
    end

    // MEM harzard
    if(MEMWB_regwrite && (MEMWB_writeReg != 0) && (forward_A != 2'b10) && (MEMWB_writeReg == rs1)) begin
        forward_A = 2'b01;
    end
    if (MEMWB_regwrite && (MEMWB_writeReg != 0) && (forward_B != 2'b10) && (MEMWB_writeReg == rs2)) begin
        forward_B = 2'b01;
    end
end

endmodule
