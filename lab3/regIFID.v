module regIFID (
    input clk,
    input [31:0] inst_i,
    output reg [31:0] inst_o,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [2:0] func3,
    output reg func7
);

    // TODO: implement your program counter here
always @(posedge clk) begin
    inst_o <= inst_i;
    rs1 <= inst_i[19:15];
    rs2 <= inst_i[24:20];
    rd <= inst_i[11:7];
    func7 <= inst_i[30];
    func3 <= inst_i[14:12];
end

endmodule

