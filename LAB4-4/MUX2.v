`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 21:50:31
// Design Name: 
// Module Name: MUX2
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


module MUX2(
    input [1:0] Jump,
    input [31:0] from_pc_branch,
    input [31:0] from_jal,
    input [31:0] from_jalr,

    output [31:0] next_pc
    );




reg [31:0] temp;
assign next_pc=temp;

    always @(*)begin
        case(Jump)
            2'd0:temp=from_pc_branch;
            2'd1:temp=from_jal;
            2'd2:temp=from_jalr;
        endcase
    end

endmodule
