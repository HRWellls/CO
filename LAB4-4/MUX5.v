`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 21:51:23
// Design Name: 
// Module Name: MUX5
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


module MUX5(
    input ALUSrc,
    input [31:0] rd2,
    input [31:0] imm,

    output [31:0] alu2
);

reg[31:0]temp;
assign alu2=temp;

    always @(*)begin
        if(ALUSrc==1)temp=imm;
        else temp=rd2;
    end 

endmodule
