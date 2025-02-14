module PipelineCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

// variables
// m_mux_pc
wire [31:0] mux_pc_o;
// m_pc
wire [31:0] pc_o;
// m_pc_adder
wire [31:0] pc_adder_o;
// m_InstMem
wire [31:0] inst;
// m_mux_IFID
wire IFID_flush;
// m_regIFID
wire [31:0] IFID_pc_o;
wire [31:0] IFID_inst_o;
wire IFID_func7_o;
wire [2:0] IFID_func3_o;
wire [4:0] IFID_rs1_o;
wire [4:0] IFID_rs2_o;
wire [4:0] IFID_rd_o;
// m_IDcontrol
wire control_ALUSrc_A;
wire control_ALUSrc_B;
wire [1:0] control_ALUOp;
wire control_memwrite;
wire control_memRead;
wire control_regwrite;
wire [1:0] control_memtoReg;
wire use_rs1, use_rs2;
// m_mux_control
wire [8:0] mux_control_o;
// m_harzard_detection
wire harzard_pc_stall;
wire harzard_ifid_stall;
wire harzard_control_mux;
// m_Register
wire [31:0] readData1;
wire [31:0] readData2;
// m_immGen
wire [31:0] imm_out;
// m_mux_IDEX
wire IDEX_flush;
// m_regIDEX
wire IDEX_memwrite;
wire IDEX_memRead;
wire IDEX_regwrite;
wire [1:0] IDEX_memtoReg;
wire [2:0] IDEX_funct3;
wire IDEX_funct7;
wire [31:0] IDEX_readdata1;
wire [31:0] IDEX_readdata2;
wire [31:0] IDEX_imm;
wire [31:0] IDEX_pc_o;
wire IDEX_ALUSrc_A;
wire IDEX_ALUSrc_B;
wire [1:0] IDEX_ALUOp;
wire [4:0] IDEX_rs1;
wire [4:0] IDEX_rs2;
wire [4:0] IDEX_rd;
wire [6:0] IDEX_opcode;
// m_BranchCMP
wire BrEQ, BrLT;
// m_mux_farward_alu_a
wire [31:0] mux_forward_alu_a_o;
// m_mux_forward_alu_b
wire [31:0] mux_forward_alu_b_o;
// m_mux_alu_a
wire [31:0] mux_alu_a_o;
// m_mux_alu_b
wire [31:0] mux_alu_b_o;
// m_ALUCtrl
wire [3:0] ALUCtrl;
// m_ALU
wire [31:0] ALU_out;
// m_forwarding
wire [1:0] forward_A;
wire [1:0] forward_B;
// m_EXcontrol
wire PCsel, flush;
// m_regEXMEM
wire EXMEM_memwrite;
wire EXMEM_memRead;
wire EXMEM_regwrite;
wire [1:0] EXMEM_memtoReg;
wire [31:0] EXMEM_ALU;
wire [31:0] EXMEM_writeData;
wire [4:0] EXMEM_rd;
wire [31:0] EXMEM_pc_o;
// m_DataMem
wire [31:0] dataMem_o;
// m_regMEMWB
wire MEMWB_regwrite;
wire [1:0] MEMWB_memtoReg;
wire [31:0] MEMWB_ALU;
wire [31:0] MEMWB_mem;
wire [4:0] MEMWB_rd;
wire [31:0] MEMWB_pc_o;
// m_adder_regwrite
wire [31:0] regwrite_pcp4;
// m_mux_regwrite
wire [31:0] mux_regwrite_o;

Mux2to1 #(.size(32)) m_mux_pc(
    // input
    .sel(PCsel),  // from EXcontrol
    .s0(pc_adder_o),
    .s1(ALU_out),
    // output
    .out(mux_pc_o)
);

PC m_PC(
    // input
    .clk(clk),
    .rst(start),
    .stall(harzard_pc_stall),
    .pc_i(mux_pc_o),
    // output
    .pc_o(pc_o)
);

Adder m_pc_adder(
    // input
    .a(pc_o),
    .b(32'd4),
    // output
    .sum(pc_adder_o)
);

InstructionMemory m_InstMem(
    // input
    .readAddr(pc_o),
    // output
    .inst(inst)
);

Mux2to1 #(.size(1)) m_mux_IFID(
    .s0(1'b0),
    .s1(1'b1),
    .sel(flush),
    .out(IFID_flush)
);

regIFID m_regIFID(
    // input
    .clk(clk),
    .rst(start),
    .pc_i(pc_o),
    .inst_i(inst),
    .stall(harzard_ifid_stall),
    .flush(IFID_flush),
    // output
    .pc_o(IFID_pc_o),
    .inst_o(IFID_inst_o),
    .func3(IFID_func3_o),
    .func7(IFID_func7_o),
    .rs1(IFID_rs1_o),
    .rs2(IFID_rs2_o),
    .rd(IFID_rd_o)
);

IDControl m_IDControl(
    // input
    .opcode(IFID_inst_o[6:0]),
    // output
    .ALUSrc_A(control_ALUSrc_A),
    .ALUSrc_B(control_ALUSrc_B),
    .ALUOp(control_ALUOp),
    .memWrite(control_memwrite),
    .memRead(control_memRead),
    .regWrite(control_regwrite),
    .memtoReg(control_memtoReg),
    .use_rs1(use_rs1),
    .use_rs2(use_rs2)
);

Mux2to1 #(.size(9)) m_mux_control(
    // input
    .sel(harzard_control_mux),  // from harzard detection
    .s0({control_ALUSrc_A, control_ALUSrc_B, control_ALUOp, control_memwrite, control_memRead, control_regwrite, control_memtoReg}),
    .s1(9'b0),
    // output
    .out(mux_control_o)
);

HazardDetection m_harzard_detection(
    // input
    .use_rs1(use_rs1),
    .use_rs2(use_rs2),
    .rs1(IFID_rs1_o),
    .rs2(IFID_rs2_o),
    .IDEX_rd(IDEX_rd),
    .memRead(IDEX_memRead),
    // output
    .PC_stall(harzard_pc_stall),
    .IFID_stall(harzard_ifid_stall),
    .control_mux(harzard_control_mux)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    // input
    .clk(clk),
    .rst(start),
    .regWrite(MEMWB_regwrite),  // enable
    .readReg1(IFID_inst_o[19:15]),
    .readReg2(IFID_inst_o[24:20]),
    .writeReg(MEMWB_rd),  // destination
    .writeData(mux_regwrite_o),  // data to write in reg
    // output
    .readData1(readData1),
    .readData2(readData2)
);

ImmGen m_ImmGen(
    .inst(IFID_inst_o),
    .imm(imm_out)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

Mux2to1 #(.size(1)) m_mux_IDEX(
    .s0(1'b0),
    .s1(1'b1),
    .sel(flush),
    .out(IDEX_flush)
);

regIDEX m_regIDEX(
    // input
    .clk(clk),
    .rst(start),
    .flush(IDEX_flush),
    // .stall(harzard_ifid_stall),
    .ALUSrc_A_i(mux_control_o[8]),
    .ALUSrc_B_i(mux_control_o[7]),
    .ALUOp_i(mux_control_o[6:5]),
    .memWrite_i(mux_control_o[4]),
    .memRead_i(mux_control_o[3]),
    .regWrite_i(mux_control_o[2]),
    .memtoReg_i(mux_control_o[1:0]),
    .readdata1_i(readData1),
    .readdata2_i(readData2),
    .imm_i(imm_out),
    .func7_i(IFID_func7_o),
    .func3_i(IFID_func3_o),
    .rs1_i(IFID_rs1_o),
    .rs2_i(IFID_rs2_o),
    .rd_i(IFID_rd_o),
    .opcode_i(IFID_inst_o[6:0]),
    .pc_i(IFID_pc_o),
    // output
    .memWrite_o(IDEX_memwrite),
    .memRead_o(IDEX_memRead),
    .regWrite_o(IDEX_regwrite),
    .memtoReg_o(IDEX_memtoReg),
    .func7_o(IDEX_funct7),
    .func3_o(IDEX_funct3),
    .readdata1_o(IDEX_readdata1),
    .readdata2_o(IDEX_readdata2),
    .imm_o(IDEX_imm),
    .pc_o(IDEX_pc_o),
    .ALUSrc_A_o(IDEX_ALUSrc_A),
    .ALUSrc_B_o(IDEX_ALUSrc_B),
    .ALUOp_o(IDEX_ALUOp),
    .rs1_o(IDEX_rs1),
    .rs2_o(IDEX_rs2),
    .rd_o(IDEX_rd),
    .opcode_o(IDEX_opcode)
);

BranchCMP m_branchCMP(
    .A(mux_forward_alu_a_o),
    .B(mux_forward_alu_b_o),
    .BrEQ(BrEQ),
    .BrLT(BrLT)
);

Mux3to1 #(.size(32)) m_mux_forward_alu_a(
    .sel(forward_A),
    .s0(IDEX_readdata1),
    .s1(mux_regwrite_o),
    .s2(EXMEM_ALU),
    .out(mux_forward_alu_a_o)
);

Mux3to1 #(.size(32)) m_mux_forward_alu_b(
    .sel(forward_B),
    .s0(IDEX_readdata2),
    .s1(mux_regwrite_o),
    .s2(EXMEM_ALU),
    .out(mux_forward_alu_b_o)
);

Mux2to1 #(.size(32)) m_mux_alu_a(
    .sel(IDEX_ALUSrc_A),
    .s0(mux_forward_alu_a_o),
    .s1(IDEX_pc_o),
    .out(mux_alu_a_o)
);

Mux2to1 #(.size(32)) m_mux_alu_b(
    .sel(IDEX_ALUSrc_B),
    .s0(mux_forward_alu_b_o),
    .s1(IDEX_imm),
    .out(mux_alu_b_o)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(IDEX_ALUOp),
    .funct7(IDEX_funct7),
    .funct3(IDEX_funct3),
    .ALUCtl(ALUCtrl)
);

ALU m_ALU(
    .ALUctl(ALUCtrl),
    .A(mux_alu_a_o),
    .B(mux_alu_b_o),
    .ALUOut(ALU_out)
);

Forwarding m_forwarding(
    // input
    .rs1(IDEX_rs1),
    .rs2(IDEX_rs2),
    .EXMEM_writeReg(EXMEM_rd),  // address
    .MEMWB_writeReg(MEMWB_rd),
    .EXMEM_regwrite(EXMEM_regwrite),  // enable
    .MEMWB_regwrite(MEMWB_regwrite),
    // output
    .forward_A(forward_A),
    .forward_B(forward_B)
);

EXControl m_EXcontrol(
    // input
    .opcode(IDEX_opcode),
    .func3(IDEX_funct3),
    .BrEQ(BrEQ),
    .BrLT(BrLT),
    // output
    .PCsel(PCsel),
    .flush(flush)
);

regEXMEM m_regEXMEM(
    // input
    .clk(clk),
    .rst(start),
    .memWrite_i(IDEX_memwrite),
    .memRead_i(IDEX_memRead),
    .regWrite_i(IDEX_regwrite),
    .memtoReg_i(IDEX_memtoReg),
    .ALU_i(ALU_out),
    .writeData_i(mux_forward_alu_b_o),
    .rd_i(IDEX_rd),
    .pc_i(IDEX_pc_o),
    // output
    .memWrite_o(EXMEM_memwrite),
    .memRead_o(EXMEM_memRead),
    .regWrite_o(EXMEM_regwrite),
    .memtoReg_o(EXMEM_memtoReg),
    .ALU_o(EXMEM_ALU),
    .writeData_o(EXMEM_writeData),
    .rd_o(EXMEM_rd),
    .pc_o(EXMEM_pc_o)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(EXMEM_memwrite),
    .memRead(EXMEM_memRead),
    .address(EXMEM_ALU),
    .writeData(EXMEM_writeData),
    // output
    .readData(dataMem_o)
);

regMEMWB m_regMEMWB(
    // input
    .clk(clk),
    .rst(start),
    .regWrite_i(EXMEM_regwrite),
    .memtoReg_i(EXMEM_memtoReg),
    .ALU_i(EXMEM_ALU),
    .mem_i(dataMem_o),
    .rd_i(EXMEM_rd),
    .pc_i(EXMEM_pc_o),
    // output
    .regWrite_o(MEMWB_regwrite),
    .memtoReg_o(MEMWB_memtoReg),
    .ALU_o(MEMWB_ALU),
    .mem_o(MEMWB_mem),
    .rd_o(MEMWB_rd),
    .pc_o(MEMWB_pc_o)
);

Adder m_adder_regwrite(
    // input
    .a(MEMWB_pc_o),
    .b(32'd4),
    // output
    .sum(regwrite_pcp4)
);

Mux3to1 #(.size(32)) m_mux_regWrite(
    .sel(MEMWB_memtoReg),
    .s0(MEMWB_mem),
    .s1(MEMWB_ALU),
    .s2(regwrite_pcp4),
    .out(mux_regwrite_o)
);

endmodule
