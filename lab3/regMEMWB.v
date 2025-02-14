module regMEMWB (
    // inputs 
    input clk,
    input regWrite_i,
    input memtoReg_i,

    // from mem
    input [31:0] ALU_i,
    input [31:0] mem_i,
    
    // 
    input [4:0] rd_i,

    // outputs
    output reg regWrite_o,
    output reg memtoReg_o,
    output reg [31:0] ALU_o,
    output reg [31:0] mem_o,
    output reg [4:0] rd_o
);

    // TODO: implement your program counter here
always @(posedge clk) begin
    regWrite_o <= regWrite_i;
    memtoReg_o <= memtoReg_i;
    ALU_o <= ALU_i;
    mem_o <= mem_i;
    rd_o <= rd_i;
end

endmodule

