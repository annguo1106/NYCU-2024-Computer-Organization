module SingleCycleCPU (
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

// m_pc
wire [31:0] pc;
// m_pc_adder
wire [31:0] pc_adder;
// m_InstMem
wire [31:0] inst;
// m_regIFID
wire [31:0] IFID_inst;
wire IFID_func7;
wire [2:0] IFID_func3;
wire [4:0] IFID_rs1;
wire [4:0] IFID_rs2;
wire [4:0] IFID_rd;
// m_control
wire control_ALUSrc;
wire [1:0] control_ALUOp;
wire control_memwrite;
wire control_memRead;
wire control_regwrite;
wire control_memtoReg;
// m_Register
wire [31:0] readData1;
wire [31:0] readData2;
// m_immGen
wire [31:0] imm;
// m_regIDEX
wire IDEX_memwrite;
wire IDEX_memRead;
wire IDEX_regwrite;
wire IDEX_memtoReg;
wire [2:0] IDEX_funct3;
wire IDEX_funct7;
wire IDEX_ALUsrc;
wire [31:0] IDEX_readdata1, IDEX_readdata2, IDEX_imm;
wire [1:0] IDEX_ALUOp;
wire [4:0] IDEX_rd;
// m_mux_alu_b
wire [31:0] mux_alu_b;
// m_ALUCtrl
wire [3:0] ALUCtrl;
// m_ALU
wire [31:0] ALU_out;
// m_regEXMEM
wire EXMEM_memwrite;
wire EXMEM_memRead;
wire EXMEM_regwrite;
wire EXMEM_memtoReg;
wire [31:0] EXMEM_ALU;
wire [31:0] EXMEM_writeData;
wire [4:0] EXMEM_rd;
// m_DataMem
wire [31:0] dataMem;
// m_regMEMWB
wire MEMWB_regwrite;
wire MEMWB_memtoReg;
wire [31:0] MEMWB_ALU;
wire [31:0] MEMWB_mem;
wire [4:0] MEMWB_rd;
// m_mux_regwrite
wire [31:0] mux_regwrite;


PC m_PC(
    // input
    .clk(clk),
    .rst(start),
    .pc_i(pc_adder),
    // output
    .pc_o(pc)
);

Adder m_pc_adder(
    // input
    .a(pc),
    .b(32'd4),
    // output
    .sum(pc_adder)
);

InstructionMemory m_InstMem(
    // input
    .readAddr(pc),
    // output
    .inst(inst)
);

regIFID m_regIFID(
    // input
    .clk(clk),
    .inst_i(inst),
    // output
    .inst_o(IFID_inst),
    .func3(IFID_func3),
    .func7(IFID_func7),
    .rs1(IFID_rs1),
    .rs2(IFID_rs2),
    .rd(IFID_rd)
);

Control m_Control(
    // input
    .opcode(IFID_inst[6:0]),
    // output
    .ALUSrc(control_ALUSrc),
    .ALUOp(control_ALUOp),
    .memWrite(control_memwrite),
    .memRead(control_memRead),
    .regWrite(control_regwrite),
    .memtoReg(control_memtoReg)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    // input
    .clk(clk),
    .rst(start),
    .regWrite(MEMWB_regwrite),  // enable
    .readReg1(IFID_rs1),
    .readReg2(IFID_rs2),
    .writeReg(MEMWB_rd),  // destination
    .writeData(mux_regwrite),  // data to write in reg
    // output
    .readData1(readData1),
    .readData2(readData2)
);

ImmGen m_ImmGen(
    .inst(IFID_inst),
    .imm(imm)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

regIDEX m_regIDEX(
    // input
    .clk(clk),
    .ALUSrc_i(control_ALUSrc),
    .ALUOp_i(control_ALUOp),
    .memWrite_i(control_memwrite),
    .memRead_i(control_memRead),
    .regWrite_i(control_regwrite),
    .memtoReg_i(control_memtoReg),
    .readdata1_i(readData1),
    .readdata2_i(readData2),
    .imm_i(imm),
    .func7_i(IFID_func7),
    .func3_i(IFID_func3),
    .rd_i(IFID_rd),
    // output
    .memWrite_o(IDEX_memwrite),
    .memRead_o(IDEX_memRead),
    .regWrite_o(IDEX_regwrite),
    .memtoReg_o(IDEX_memtoReg),
    .func7_o(IDEX_funct7),
    .func3_o(IDEX_funct3),
    .ALUSrc_o(IDEX_ALUsrc),
    .readdata1_o(IDEX_readdata1),
    .readdata2_o(IDEX_readdata2),
    .imm_o(IDEX_imm),
    .ALUOp_o(IDEX_ALUOp),
    .rd_o(IDEX_rd)
);

Mux2to1 #(.size(32)) m_mux_alu_b(
    .sel(IDEX_ALUsrc),
    .s0(IDEX_readdata2),
    .s1(IDEX_imm),
    .out(mux_alu_b)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(IDEX_ALUOp),
    .funct7(IDEX_funct7),
    .funct3(IDEX_funct3),
    .ALUCtl(ALUCtrl)
);

ALU m_ALU(
    .ALUctl(ALUCtrl),
    .A(IDEX_readdata1),
    .B(mux_alu_b),
    .ALUOut(ALU_out)
);

regEXMEM m_regEXMEM(
    // input
    .clk(clk),
    .memWrite_i(IDEX_memwrite),
    .memRead_i(IDEX_memRead),
    .regWrite_i(IDEX_regwrite),
    .memtoReg_i(IDEX_memtoReg),
    .ALU_i(ALU_out),
    .writeData_i(IDEX_readdata2),
    .rd_i(IDEX_rd),
    // output
    .memWrite_o(EXMEM_memwrite),
    .memRead_o(EXMEM_memRead),
    .regWrite_o(EXMEM_regwrite),
    .memtoReg_o(EXMEM_memtoReg),
    .ALU_o(EXMEM_ALU),
    .writeData_o(EXMEM_writeData),
    .rd_o(EXMEM_rd)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(EXMEM_memwrite),
    .memRead(EXMEM_memRead),
    .address(EXMEM_ALU),
    .writeData(EXMEM_writeData),
    // output
    .readData(dataMem)
);

regMEMWB m_regMEMWB(
    // input
    .clk(clk),
    .regWrite_i(EXMEM_regwrite),
    .memtoReg_i(EXMEM_memtoReg),
    .ALU_i(EXMEM_ALU),
    .mem_i(dataMem),
    .rd_i(EXMEM_rd),
    // output
    .regWrite_o(MEMWB_regwrite),
    .memtoReg_o(MEMWB_memtoReg),
    .ALU_o(MEMWB_ALU),
    .mem_o(MEMWB_mem),
    .rd_o(MEMWB_rd)
);

Mux2to1 #(.size(32)) m_mux_regWrite(
    .sel(MEMWB_memtoReg),
    .s0(MEMWB_ALU),
    .s1(MEMWB_mem),
    .out(mux_regwrite)
);

endmodule
