module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,    // = inst[30]
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    // TODO: implement your ALU control here
    // For testbench verifying, Do not modify input and output pin
    // Hint: using ALUOp, funct7, funct3 to select exact operation
always @(ALUOp or funct7 or funct3) begin
    case(ALUOp)   // load
        2'b00: ALUCtl <= 4'b0010;  // lw sw
        2'b01: ALUCtl <= 4'b0110;  // branch
        2'b10: begin  // R - type
            case(funct3)
                3'b000: begin
                    case(funct7) 
                        1'b0: ALUCtl <= 4'b0010;  // add
                        1'b1: ALUCtl <= 4'b0110;  // sub
                    endcase
                end
                3'b111: ALUCtl <= 4'b0000;  // and
                3'b110: ALUCtl <= 4'b0001;  // or
                3'b010: ALUCtl <= 4'b1000;  // slt
                default: ALUCtl <= 4'bxxxx;
            endcase
        end
        2'b11: begin  // I - type
            case(funct3)
                3'b000: ALUCtl <= 4'b0010;  // addi
                3'b111: ALUCtl <= 4'b0000;  // andi
                3'b110: ALUCtl <= 4'b0001;  // ori
                3'b010: ALUCtl <= 4'b1000;  // slti
                default: ALUCtl <= 4'bxxxx;
            endcase
        end
        default: ALUCtl <= 4'bxxxx;
    endcase
    /*
    // and -> 4'b0000
    // or -> 4'b0001
    // add -> 4'b0010
    // subtract -> 4'b0110
    */
    // if(ALUOp == 2'b00) begin
    //     assign ALUCtl = 4'b0010;
    // end
    // else if(ALUOp[0] == 1) begin
    //     assign ALUCtl = 4'b0110;
    // end
    // else if(ALUOp[1] == 1) begin
    //     if(funct7 == 1) begin
    //         assign ALUCtl = 4'b0110;
    //     end
    //     else if(funct7 == 0) begin
    //         if(funct3 == 3'b000)begin
    //             assign ALUCtl = 4'b0010;
    //         end
    //         else if(funct3 == 3'b111)begin
    //             assign ALUCtl = 4'b0000;
    //         end
    //         else if(funct3 == 3'b110)begin
    //             assign ALUCtl = 4'b0001;
    //         end
    //         else assign ALUCtl = 4'b0000;
    //     end
    // end
    // else assign ALUCtl = 4'b0000;
end
endmodule

// if(ALUOp == 2'b00) begin
//         assign ALUCtl = 4'b0010;
//     end
//     else if(ALUOp[0] == 1) begin
//         assign ALUCtl = 4'b0110;
//     end
//     else if(ALUOp[1] == 1) begin
//         if(funct7 == 1) begin
//             assign ALUCtl = 4'b0110;
//         end
//         else if(funct7 == 0) begin
//             if(funct3 == 3'b000)begin
//                 assign ALUCtl = 4'b0010;
//             end
//             else if(funct3 == 3'b111)begin
//                 assign ALUCtl = 4'b0000;
//             end
//             else if(funct3 == 3'b110)begin
//                 assign ALUCtl = 4'b0001;
//             end
//         end
//     end

