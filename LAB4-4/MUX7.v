`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 15:19:27
// Design Name: 
// Module Name: MUX7
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


module MUX7(
        input [1:0] choice,
        input [31:0] from_mux1,
        input [31:0] from_csr_regs,

        output [31:0] out
    );

reg [31:0 ] out0;
assign out = out0;

always @(*)begin
    if(choice == 2'b00)
        out0 = from_mux1;
    else
        out0 = from_csr_regs;
end
endmodule
