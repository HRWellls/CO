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
