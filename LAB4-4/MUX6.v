`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 15:15:24
// Design Name: 
// Module Name: MUX6
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


module MUX6(
        input choice,
        input [31:0] imm,
        input [31:0] reg_data,

        output [31:0] out
    );

reg [31:0 ] out0;
assign out = out0;

always @(*)begin
    case(choice)
        1'b1: out0 = imm;
        1'b0: out0 = reg_data;
    endcase
end

endmodule
