module regIFID (
    input clk, rst,
    input [31:0] pc_i,
    input [31:0] inst_i,
    input stall,
    input flush,
    output reg [31:0] pc_o,
    output reg [31:0] inst_o,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [2:0] func3,
    output reg func7
);

// TODO: implement your program counter here
always @(posedge clk, posedge rst) begin
    if(flush) begin
        pc_o <= 32'bx;  // don't care
        inst_o <= 32'b00000000000000000000000000110011;  // add zero, zero, zero
        rs1 <= 5'b0;
        rs2 <= 5'b0;
        rd <= 5'b0;
        func7 <= 1'b0;
        func3 <= 3'b0;
    end
    if((!flush) && (!stall)) begin
        pc_o <= pc_i;
        inst_o <= inst_i;
        rs1 <= inst_i[19:15];
        rs2 <= inst_i[24:20];
        rd <= inst_i[11:7];
        func7 <= inst_i[30];
        func3 <= inst_i[14:12];
    end
end

endmodule

