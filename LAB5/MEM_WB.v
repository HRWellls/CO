`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/29 20:37:31
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
input wire clk,
input wire rst,
input wire [31:0] input_pc_plus_4,
input wire input_reg_write,
input wire [1:0] input_mem_to_reg,
input wire [31:0] input_alu_result,
input wire [31:0] input_imm,
input wire [5:0] input_write_reg,
input wire [31:0] input_data_in,

output wire [31:0] output_pc_plus_4,
output wire output_reg_write,
output wire [1:0] output_mem_to_reg,
output wire [31:0] output_alu_result,
output wire [31:0] output_imm,
output wire [5:0] output_write_reg,
output wire [31:0] output_data_in

    );

//regs
reg [31:0] temp_pc_plus_4;
reg temp_reg_write;
reg [1:0] temp_mem_to_reg;
reg [31:0] temp_alu_result;
reg [31:0] temp_imm;
reg [5:0] temp_write_reg;
reg [31:0] temp_data_in;

//assigns
assign output_pc_plus_4 = temp_pc_plus_4;
assign output_reg_write = temp_reg_write;
assign output_mem_to_reg = temp_mem_to_reg;
assign output_alu_result = temp_alu_result;
assign output_imm = temp_imm;
assign output_write_reg = temp_write_reg;
assign output_data_in = temp_data_in;

//always block
always @(posedge clk or posedge rst) begin
    if(rst)begin
        temp_pc_plus_4 <= 32'b0;
        temp_reg_write <= 1'b0;
        temp_mem_to_reg <= 2'b00;
        temp_alu_result <= 32'b0;
        temp_imm <= 32'b0;
        temp_write_reg <= 6'b0;
        temp_data_in <= 32'b0;
    end
    else begin
        temp_pc_plus_4 <= input_pc_plus_4;
        temp_reg_write <= input_reg_write;
        temp_mem_to_reg <= input_mem_to_reg;
        temp_alu_result <= input_alu_result;
        temp_imm <= input_imm;
        temp_write_reg <= input_write_reg;
        temp_data_in <= input_data_in;
    end
end

endmodule
