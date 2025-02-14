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
wire [31:0] pc_o;
// m_Adder
wire [31:0] sum;
// m_InstMen
wire [31:0] inst;
// m_Control
wire PCsel, RegWrite, MemRead, MemWrite, ALUSrc_A, ALUSrc_B;
wire [1:0] MemtoReg;
wire [2:0] ALUOp;
// m_Register
wire [31:0] readData1;
wire [31:0] readData2;
// m_branchCMP
wire BrEq, BrLT;
// m_ImmGen
wire [31:0] imm_out;
// m_Mux_PC
wire [31:0] mux_pc_out;
// m_Mux_A
wire [31:0] mux_A_out;
// m_Mux_B
wire [31:0] mux_B_out;
// m_ALUCtrl
wire [3:0] ALUCtrl;
// m_ALU
wire [31:0] ALU_out;
// m_DataMemory
wire [31:0] read_data;
// m_Mux_regW
wire [31:0] mux_reg_out;


PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(mux_pc_out),
    .pc_o(pc_o)
);

Adder m_Adder(
    .a(pc_o),
    .b(32'd4),
    .sum(sum)
);

InstructionMemory m_InstMem(
    .readAddr(pc_o),
    .inst(inst)
);

Control m_Control(
    .opcode(inst[6:0]),
    .func3(inst[14:12]),
    .BrEq(BrEq),
    .BrLT(BrLT),
    .PCsel(PCsel),
    .memRead(MemRead),
    .memtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .memWrite(MemWrite),
    .ALUSrc_A(ALUSrc_A),
    .ALUSrc_B(ALUSrc_B),
    .regWrite(RegWrite)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(RegWrite),
    .readReg1(inst[19:15]),
    .readReg2(inst[24:20]),
    .writeReg(inst[11:7]),
    .writeData(mux_reg_out),
    .readData1(readData1),
    .readData2(readData2)
);

BranchCMP m_branchCMP(
    .A(readData1),
    .B(readData2),
    .BrEq(BrEq),
    .BrLT(BrLT)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen(
    .inst(inst[31:0]),
    .imm(imm_out)
);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(PCsel),
    .s0(sum),
    .s1(ALU_out),
    .out(mux_pc_out)
);

Mux2to1 #(.size(32)) m_Mux_A(
    .sel(ALUSrc_A),
    .s0(readData1),
    .s1(pc_o),
    .out(mux_A_out)
);

Mux2to1 #(.size(32)) m_Mux_B(
    .sel(ALUSrc_B),
    .s0(readData2),
    .s1(imm_out),
    .out(mux_B_out)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp[2:0]),
    .funct7(inst[30]),
    .funct3(inst[14:12]),
    .ALUCtl(ALUCtrl)
);

ALU m_ALU(
    .ALUctl(ALUCtrl),
    .A(mux_A_out),
    .B(mux_B_out),
    .ALUOut(ALU_out)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(MemWrite),
    .memRead(MemRead),
    .address(ALU_out),
    .writeData(readData2),
    .readData(read_data)
);

Mux3to1 #(.size(32)) m_Mux_regW(
    .sel(MemtoReg),
    .s0(read_data),
    .s1(ALU_out),
    .s2(sum),
    .out(mux_reg_out)
);

endmodule
