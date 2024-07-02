`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/29 20:37:05
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input wire clk,
    input wire rst,
    input wire [31:0] input_pc,
    input wire [1:0] input_jump,
    input wire [2:0] input_mem_read,
    input wire input_branch,
    input wire [1:0] input_mem_to_reg,
    input wire [1:0] input_mem_write,
    input wire input_reg_write,
    input wire input_zero,
    input wire [31:0] input_alu_result,
    input wire [31:0] input_inst,
    input wire [31:0] input_rd2,
    input wire [5:0] input_write_reg,
    input wire [31:0] input_imm,

    //output lines
    output wire [31:0] output_pc,
    output wire [1:0] output_jump,
    output wire [2:0] output_mem_read,
    output wire output_branch,
    output wire [1:0] output_mem_to_reg,
    output wire [1:0] output_mem_write,
    output wire output_reg_write,
    output wire output_zero,
    output wire [31:0] output_alu_result,
    output wire [31:0] output_inst,
    output wire [31:0] output_rd2,
    output wire [5:0] output_write_reg,
    output wire [31:0] output_imm
    );


//regs
reg [31:0] temp_pc;
reg [1:0] temp_jump;
reg [2:0] temp_mem_read;
reg temp_branch;
reg [1:0] temp_mem_to_reg;
reg [1:0] temp_mem_write;
reg temp_reg_write;
reg temp_zero;
reg [31:0] temp_alu_result;
reg [31:0] temp_inst;
reg [31:0] temp_rd2;
reg [5:0] temp_write_reg;
reg [31:0] temp_imm;

//assigns
assign output_pc = temp_pc;
assign output_inst = temp_inst;
assign output_jump = temp_jump;
assign output_mem_read = temp_mem_read;
assign output_branch = temp_branch;
assign output_mem_to_reg = temp_mem_to_reg;
assign output_mem_write = temp_mem_write;
assign output_reg_write = temp_reg_write;
assign output_zero = temp_zero;
assign output_alu_result = temp_alu_result;
assign output_rd2 = temp_rd2;
assign output_write_reg = temp_write_reg;
assign output_imm = temp_imm;

//always block
always@(posedge clk or posedge rst)begin
    if(rst)begin
        temp_pc <= 32'b0;
        temp_jump <= 2'b0;
        temp_mem_read <= 3'b0;
        temp_branch <= 1'b0;
        temp_mem_to_reg <= 2'b0;
        temp_mem_write <= 2'b0;
        temp_reg_write <= 1'b0;
        temp_zero <= 1'b0;
        temp_alu_result <= 32'b0;
        temp_inst <= 32'b0;
        temp_rd2 <= 32'b0;
        temp_write_reg <= 6'b0;
        temp_imm <= 32'b0;
    end
    else begin
        temp_pc <= input_pc;
        temp_jump <= input_jump;
        temp_mem_read <= input_mem_read;
        temp_branch <= input_branch;
        temp_mem_to_reg <= input_mem_to_reg;
        temp_mem_write <= input_mem_write;
        temp_reg_write <= input_reg_write;
        temp_zero <= input_zero;
        temp_alu_result <= input_alu_result;
        temp_inst <= input_inst;
        temp_rd2 <= input_rd2;
        temp_write_reg <= input_write_reg;
        temp_imm <= input_imm;
    end
end

endmodule
