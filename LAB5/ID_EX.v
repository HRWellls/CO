`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/29 20:36:12
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input wire clk,
    input wire rst,
    input wire [31:0] input_pc,
    input wire [31:0] input_inst,

    input wire [1:0] input_jump,
    input wire [2:0] input_mem_read,
    input wire input_branch,
    input wire [1:0] input_mem_to_reg,
    input wire [1:0] input_mem_write,
    input wire input_alu_src,
    input wire input_aui,
    input wire input_reg_write,


    input wire [31:0] input_rd1,
    input wire [31:0] input_rd2,
    input wire [3:0] input_alu_operation,
    input wire [5:0] inpu_write_reg,
    input wire [31:0] input_imm,

    //output
    output wire [31:0] output_pc,
    output wire [31:0] output_inst,
    output wire [1:0] output_jump,
    output wire [2:0] output_mem_read,
    output wire output_branch,
    output wire [1:0] output_mem_to_reg,
    output wire [1:0] output_mem_write,
    output wire output_alu_src,
    output wire output_aui,
    output wire output_reg_write,
    
    output wire [31:0] output_rd1,
    output wire [31:0] output_rd2,
    output wire [3:0] output_alu_operation,
    output wire [5:0] output_write_reg,
    output wire [31:0] output_imm

    );

//regs
reg [31:0] temp_pc;
reg [31:0] temp_inst;
reg [1:0] temp_jump;
reg [2:0] temp_mem_read;
reg temp_branch;
reg [1:0] temp_mem_to_reg;
reg [1:0] temp_mem_write;
reg temp_alu_src;
reg temp_aui;
reg temp_reg_write;

reg [31:0] temp_rd1;
reg [31:0] temp_rd2;
reg [3:0] temp_alu_operation;
reg [5:0] temp_write_reg;
reg [31:0] temp_imm;

assign output_pc = temp_pc;
assign output_inst = temp_inst;
assign output_jump = temp_jump;
assign output_mem_read = temp_mem_read;
assign output_branch = temp_branch;
assign output_mem_to_reg = temp_mem_to_reg;
assign output_mem_write = temp_mem_write;
assign output_alu_src = temp_alu_src;
assign output_aui = temp_aui;
assign output_reg_write = temp_reg_write;
assign output_rd1 = temp_rd1;
assign output_rd2 = temp_rd2;
assign output_alu_operation = temp_alu_operation;
assign output_write_reg = temp_write_reg;
assign output_imm = temp_imm;

//update regs
always @(posedge clk or posedge rst) begin
    if(rst)begin
      //reset all registers
        temp_pc <= 32'b0;
        temp_inst <= 32'b0;
        temp_jump <= 2'b0;
        temp_mem_read <= 3'b0;
        temp_branch <= 1'b0;
        temp_mem_to_reg <= 2'b0;
        temp_mem_write <= 2'b0;
        temp_alu_src <= 1'b0;
        temp_aui <= 1'b0;
        temp_reg_write <= 1'b0;
        temp_rd1 <= 32'b0;
        temp_rd2 <= 32'b0;
        temp_alu_operation <= 4'b0;
        temp_write_reg <= 6'b0;
        temp_imm <= 32'b0;

    end
    else begin
        temp_pc <= input_pc;
        temp_inst <= input_inst;
        temp_jump <= input_jump;
        temp_mem_read <= input_mem_read;
        temp_branch <= input_branch;
        temp_mem_to_reg <= input_mem_to_reg;
        temp_mem_write <= input_mem_write;
        temp_alu_src <= input_alu_src;
        temp_aui <= input_aui;
        temp_reg_write <= input_reg_write;
        temp_rd1 <= input_rd1;
        temp_rd2 <= input_rd2;
        temp_alu_operation <= input_alu_operation;
        temp_write_reg <= inpu_write_reg;
        temp_imm <= input_imm;
    end
end
endmodule
