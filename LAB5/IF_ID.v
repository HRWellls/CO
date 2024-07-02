//write a register to implement the IF_ID pipeline register
`timescale 1ns / 1ps

module IF_ID(
    input wire clk,
    input wire rst,
    input wire [31:0] input_pc,
    input wire [31:0] input_inst,

    output wire [31:0] output_pc,
    output wire [31:0] output_inst
    );

reg [31:0] temp_pc;
reg [31:0] temp_inst;

assign output_pc = temp_pc;
assign output_inst = temp_inst;

always @(posedge clk or posedge rst) begin
    if(rst)begin
        temp_pc <= 32'b0;
        temp_inst <= 32'b0;
    end
    else begin
        temp_pc <= input_pc;
        temp_inst <= input_inst;
    end
end

endmodule
