module HazardDetection (
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] IDEX_rd,
    input memRead,
    input use_rs1, use_rs2,  // detect that is rs1 and rs2 needed in this current inst
    output reg PC_stall,
    output reg IFID_stall,
    output reg control_mux
);


always @(*) begin
    if(memRead && (IDEX_rd != 0) && ((use_rs1 && rs1 == IDEX_rd) || (use_rs2 && rs2 == IDEX_rd))) begin
        PC_stall = 1'b1;
        IFID_stall = 1'b1;
        control_mux = 1'b1;
    end
    else begin
        PC_stall = 1'b0;
        IFID_stall = 1'b0;
        control_mux = 1'b0;
    end
end

endmodule
