`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 21:50:00
// Design Name: 
// Module Name: MUX1
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


module MUX1(
    input [1:0] MemtoReg,
    input [31:0] from_memory,
    input [31:0] from_alu,
    input [31:0] from_pc,
    input [31:0] from_imm,

    output [31:0] reg_write_data
    );
reg [31:0] temp;
assign reg_write_data=temp;
    always @(*)begin
        case(MemtoReg)
            2'd0:temp=from_alu;
            2'd1:temp=from_memory;
            2'd2:temp=from_pc;
            2'd3:temp=from_imm;
        endcase 
    end
endmodule
