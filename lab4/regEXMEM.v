module regEXMEM (
    // inputs
    input clk, rst,
    // from control
    input memWrite_i,
    input memRead_i,
    // WB stage
    input regWrite_i,  // enable write to reg
    input [1:0] memtoReg_i,  // select which (mem/PC+4/ALU(branch)) to write to register
    
    // from ALU
    input [31:0] ALU_i,
    input [31:0] writeData_i, // lw -> read mem data address
    
    // from forwar
    input [4:0] rd_i,
    input [31:0] pc_i,

    // outputs
    // to control
    output reg memWrite_o,
    output reg memRead_o,
    output reg regWrite_o,
    output reg [1:0] memtoReg_o,

    // to data mem
    output reg [31:0] ALU_o,
    output reg [31:0] writeData_o,
    
    // 
    output reg [4:0] rd_o,
    output reg [31:0] pc_o
);

    // TODO: implement your program counter here
    always @(posedge clk, negedge rst) begin
        memWrite_o <= memWrite_i;
        memRead_o <= memRead_i;
        regWrite_o <= regWrite_i;
        memtoReg_o <= memtoReg_i;
        ALU_o <= ALU_i;
        writeData_o <= writeData_i;
        rd_o <= rd_i;
        pc_o <= pc_i;
    end

endmodule

