`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 21:50:45
// Design Name: 
// Module Name: MUX3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUX3(
    input Branch,
    input zero,
    input [31:0] ALU_result,
    input [2:0]  fun3,
    input [31:0] from_pc,
    input [31:0] from_branch,

    output[31:0] branch_pc
    );

reg [31:0] temp;
assign branch_pc=temp;

// reg branch_reg;
// reg zero_reg;
// reg [31:0] ALU_result_reg;
// reg [2:0] fun3_reg;

// initial begin
//     branch_reg=1'b0;
//     zero_reg=1'b0;
//     ALU_result_reg=32'b0;
//     fun3_reg=3'b0;
// end

// always @(Branch)begin
//     branch_reg=Branch;
// end
// always @(zero)begin
//     zero_reg=zero;
// end
// always @(ALU_result)begin
//     ALU_result_reg=ALU_result;
// end
// always @(fun3)begin
//     fun3_reg=fun3;
// end

    always @(*)begin
        case(Branch)
            1'b0:temp=from_pc;
            1'b1:
                begin
                    case(fun3)

                        3'd0://beq
                            begin
                                if(zero==1'b1)temp=from_branch;
                                else temp=from_pc;
                            end

                        3'd1://bne
                            begin
                                if(zero==1'b0)temp=from_branch;
                                else temp=from_pc;
                            end

                        3'd4,3'd6://blt,bltu
                            begin
                                if(ALU_result==1'b1)temp=from_branch;
                                else temp=from_pc;
                            end

                        3'd5,3'd7://bge,bgtu
                            begin
                                if(ALU_result==1'b0)temp=from_branch;
                                else temp=from_pc;
                            end

                    endcase
                end
        endcase
    end
endmodule
