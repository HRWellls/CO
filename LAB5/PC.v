`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 14:14:45
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input rst,
    input [31:0] D,

    output [31:0] Q
);

reg [31:0] next_pc;
assign Q=next_pc;

    always @(posedge clk or posedge rst) begin
        if(rst)next_pc<=32'b0;
        else next_pc<=D;
    end

endmodule
