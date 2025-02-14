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
// m_Adder_1
wire [31:0] sum_1;
// m_InstMen
wire [31:0] inst;
// m_Control
wire Branch, MemRead,MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
// m_Register
wire [31:0] readData1;
wire [31:0] readData2;
// m_ImmGen
wire [31:0] imm_out;
// m_ShiftLeftOne
wire [31:0] shift_out;
// m_Adder_2
wire [31:0] sum_2;
// m_Mux_PC
wire pc_sel;
wire [31:0] mux_pc_out;
// m_Mux_ALU
wire [31:0] mux_alu_out;
// m_ALUCtrl
wire [3:0] ALUCtrl;
// m_ALU
wire [31:0] ALU_out;
wire zero;
// m_DataMemory
wire [31:0] read_data;
// m_Mux_WriteData
wire [31:0] mux_writeData;

assign pc_sel = Branch & zero;

PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(mux_pc_out),
    .pc_o(pc_o)
);

Adder m_Adder_1(
    .a(pc_o),
    .b(32'd4),
    .sum(sum_1)
);

InstructionMemory m_InstMem(
    .readAddr(pc_o),
    .inst(inst)
);

Control m_Control(
    .opcode(inst[6:0]),
    .branch(Branch),
    .memRead(MemRead),
    .memtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .memWrite(MemWrite),
    .ALUSrc(ALUSrc),
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
    .writeData(mux_writeData),
    .readData1(readData1),
    .readData2(readData2)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen(
    .inst(inst[31:0]),
    .imm(imm_out)
);

ShiftLeftOne m_ShiftLeftOne(
    .i(imm_out),
    .o(shift_out)
);

Adder m_Adder_2(
    .a(shift_out),
    .b(pc_o),
    .sum(sum_2)
);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(pc_sel),
    .s0(sum_1),
    .s1(sum_2),
    .out(mux_pc_out)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2),
    .s1(imm_out),
    .out(mux_alu_out)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(inst[30]),
    .funct3(inst[14:12]),
    .ALUCtl(ALUCtrl)
);

ALU m_ALU(
    .ALUctl(ALUCtrl),
    .A(readData1),
    .B(mux_alu_out),
    .ALUOut(ALU_out),
    .zero(zero)
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

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(MemtoReg),
    .s0(ALU_out),
    .s1(read_data),
    .out(mux_writeData)
);

endmodule
