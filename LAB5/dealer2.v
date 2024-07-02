`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 21:08:44
// Design Name: 
// Module Name: dealer1
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

//process the output data according to the instruction (ld,lw,lh)
module dealer2(
    input wire [31:0] Addr_out,
    input wire [1:0] MemWrite,
    input wire [31:0] rs2_val,

    output wire [31:0] output_data_out
    );

wire [1:0] w;
assign w=Addr_out%4;

reg [31:0] dout0;
assign output_data_out=dout0;

always @(*)begin
    case(MemWrite)
        2'b01: //sb
            begin
                case(w)
                    2'b00:begin
                        dout0[7:0]<=rs2_val[7:0];
                        dout0[31:8]<=0;
                    end
                    2'b01:begin
                        dout0[15:8]<=rs2_val[7:0];
                        dout0[31:16]<=0;
                        dout0[7:0]<=0;
                    end
                    2'b10:begin
                        dout0[23:16]<=rs2_val[7:0];
                        dout0[31:24]<=0;
                        dout0[15:0]<=0;
                    end
                    2'b11:begin
                        dout0[31:24]<=rs2_val[7:0];
                        dout0[23:0]<=0;
                    end
                endcase
            end
        2'b10: //sh
            begin
              case(w)
                2'b00:begin
                    dout0[15:0]<=rs2_val[15:0];
                    dout0[31:16]<=0;
                end
                2'b01:begin
                    dout0[23:8]<=rs2_val[15:0];
                    dout0[31:24]<=0;
                    dout0[7:0]<=0;
                end
                2'b10:begin
                    dout0[31:16]<=rs2_val[15:0];
                    dout0[15:0]<=0;
                end
                endcase 
            end
        2'b11: //sw
            dout0<=rs2_val;        
        default: dout0<=0;
    endcase
end

endmodule
