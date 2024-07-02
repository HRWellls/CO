`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 21:51:10
// Design Name: 
// Module Name: MUX4
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


module MUX4(
    input aui,
    input [31:0] rd1,
    input [31:0] pc,

    output [31:0] alu1
    );

reg [31:0] temp;
assign alu1=temp;

    always @(*)begin
        if(aui==1)temp=pc;
        else temp=rd1;    
    end

endmodule
