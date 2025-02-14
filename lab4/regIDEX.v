module regIDEX (
    // inputs
    input clk, rst,
    input flush,
    // from control:
    // EX stage
    input ALUSrc_A_i,  // tell ALU use PC or not
    input ALUSrc_B_i,  // tell ALU use imm or not
    input [1:0] ALUOp_i,  // tell ALU which type of inst is
    // M stage
    input memWrite_i,
    input memRead_i,
    // WB stage
    input regWrite_i,  // enable write to reg
    input [1:0] memtoReg_i,  // select which (mem/PC+4/ALU(branch)) to write to register
    
    // from register
    input [31:0] readdata1_i,
    input [31:0] readdata2_i,
    input [31:0] imm_i,

    // from instruction
    input func7_i,
    input [2:0] func3_i,
    input [4:0] rs1_i, rs2_i, rd_i,
    input [6:0] opcode_i,

    input [31:0] pc_i,

    // outputs
    // control inst
    // M stage
    output reg memWrite_o,
    output reg memRead_o,
    // WB stage
    output reg regWrite_o,  // enable write to reg
    output reg [1:0] memtoReg_o,  // select which (mem/PC+4/ALU(branch)) to write to register
    // to ALUCtrl
    output reg func7_o,
    output reg [2:0]func3_o,
    // to ALU
    output reg [31:0] readdata1_o,
    output reg [31:0] readdata2_o,
    output reg [31:0] imm_o,
    output reg [31:0] pc_o,
    output reg ALUSrc_A_o,
    output reg ALUSrc_B_o,
    output reg [1:0] ALUOp_o,  // tell ALU which type of inst is

    // to forward
    output reg [4:0] rs1_o,
    output reg [4:0] rs2_o,
    output reg [4:0] rd_o,
    output reg [6:0] opcode_o

);


always @(posedge clk, negedge rst) begin
    if(flush) begin
        memWrite_o <= 1'b0;
        memRead_o <= 1'b0;
        regWrite_o <= 1'b0;
        memtoReg_o <= 2'b00;

        // to ALUCtrl
        func7_o <= 1'b0;
        func3_o <= 3'b0;

        // to ALU
        ALUOp_o <= 2'b10;
        ALUSrc_A_o <= 1'b0;
        ALUSrc_B_o <= 1'b0;
        readdata1_o <= 32'b0;
        readdata2_o <= 32'b0;
        imm_o <= 32'b0;
        pc_o <= 32'b0;

        // to forwarding unit
        rs1_o <= 5'b0;
        rs2_o <= 5'b0;
        rd_o <= 5'b0;

        // to EXcontrol (also func)
        opcode_o <= 7'b0110011;
    end
    if((!flush)) begin
        // for control inst
        memWrite_o <= memWrite_i;
        memRead_o <= memRead_i;
        regWrite_o <= regWrite_i;
        memtoReg_o <= memtoReg_i;

        // to ALUCtrl
        func7_o <= func7_i;
        func3_o <= func3_i;

        // to ALU
        ALUOp_o <= ALUOp_i;
        ALUSrc_A_o <= ALUSrc_A_i;
        ALUSrc_B_o <= ALUSrc_B_i;
        readdata1_o <=readdata1_i;
        readdata2_o <= readdata2_i;
        imm_o <= imm_i;
        pc_o <= pc_i;
        

        // to forwarding unit
        rs1_o <= rs1_i;
        rs2_o <= rs2_i;
        rd_o <= rd_i;

        // to EXcontrol (also func)
        opcode_o <= opcode_i;
    end
end

endmodule

