module PC (
    input clk,
    input rst,
    input stall,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

    // TODO: implement your program counter here
always @(posedge clk, negedge rst) begin
    if(!rst) begin pc_o <= 32'b0; end
    else begin 
        if(!stall) begin
            pc_o <= pc_i; 
        end
    end
end

endmodule
