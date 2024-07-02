`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/31 19:45:02
// Design Name: 
// Module Name: MemRW_dealer
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


module MemRW_dealer(
    input wire [31:0] inst_in,
    input wire [31:0] Addr_out,

    output wire [3:0] MemRW
    );

reg [3:0] MemRW0;
assign MemRW=MemRW0;

wire[1:0] w;
assign w=Addr_out%4;

always @(*)begin
    if(inst_in[6:0]==7'b0100011)begin
        case(inst_in[14:12])
            3'b000://sb
                begin
                    case(w)
                        2'b00:MemRW0<=4'b0001;
                        2'b01:MemRW0<=4'b0010;
                        2'b10:MemRW0<=4'b0100;
                        2'b11:MemRW0<=4'b1000;
                    endcase
                end
            3'b001://sh
                begin
                    case(w)
                        2'b00:MemRW0<=4'b0011;
                        2'b01:MemRW0<=4'b0110;
                        2'b10:MemRW0<=4'b1100;
                    endcase
                end
            3'b010://sw
                begin
                    MemRW0<=4'b1111;
                end
            default:MemRW0<=4'b0000;
        endcase
    end
    else MemRW0<=4'b0000;
end

endmodule
