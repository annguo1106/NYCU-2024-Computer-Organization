module regIDEX (
    // inputs
    input clk,
    // from control:
    // EX stage
    input ALUSrc_i,  // tell ALU use imm or not
    input [1:0] ALUOp_i,  // tell ALU which type of inst is
    // M stage
    input memWrite_i,
    input memRead_i,
    // WB stage
    input regWrite_i,  // enable write to reg
    input memtoReg_i,  // select which (mem/PC+4/ALU(branch)) to write to register
    
    // from register
    input [31:0] readdata1_i,
    input [31:0] readdata2_i,
    input [31:0] imm_i,

    // from instruction
    input func7_i,
    input [2:0] func3_i,
    input [4:0] rd_i,
    // outputs
    // control inst
    // M stage
    output reg memWrite_o,
    output reg memRead_o,
    // WB stage
    output reg regWrite_o,  // enable write to reg
    output reg memtoReg_o,  // select which (mem/PC+4/ALU(branch)) to write to register
    // to ALUCtrl
    output reg ALUSrc_o,
    output reg func7_o,
    output reg [2:0] func3_o,
    // to ALU
    output reg [31:0] readdata1_o, readdata2_o, imm_o,
    output reg [1:0] ALUOp_o,  // tell ALU which type of inst is

    output reg [4:0] rd_o
);


always @(posedge clk) begin
    // for control inst
    memWrite_o <= memWrite_i;
    memRead_o <= memRead_i;
    regWrite_o <= regWrite_i;
    memtoReg_o <= memtoReg_i;

    // to ALUCtrl
    func7_o <= func7_i;
    func3_o <= func3_i;
    ALUSrc_o <= ALUSrc_i;

    // to ALU
    ALUOp_o <= ALUOp_i;
    readdata1_o <= readdata1_i;
    readdata2_o <= readdata2_i;
    imm_o <= imm_i;

    rd_o <= rd_i;

end

endmodule

