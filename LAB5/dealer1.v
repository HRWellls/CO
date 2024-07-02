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

//process the input data according to the instruction (sd,sw,sh)
module dealer1(
    input wire [31:0] input_data_in,
    input wire [2:0] MemRead,
    input wire [31:0] Addr_out,

    output wire [31:0] output_data_in
    );

wire[1:0] w;
assign w=Addr_out%4;

reg [31:0] din0;
assign output_data_in=din0;

always @(*) begin
    case(MemRead)
        3'b001: //lb
            begin
                case(w) 
                    2'b00:begin
                        din0[7:0]<=input_data_in[7:0];
                        din0[31:8]<={24{input_data_in[7]}};
                    end
                    2'b01:begin
                        din0[7:0]<=input_data_in[15:8];
                        din0[31:8]<={24{input_data_in[15]}};
                    end
                    2'b10:begin
                        din0[7:0]<=input_data_in[23:16];
                        din0[31:8]<={24{input_data_in[23]}};
                    end
                    2'b11:begin
                        din0[7:0]<=input_data_in[31:24];
                        din0[31:8]<={24{input_data_in[31]}};
                    end
                endcase
            end
        3'b010: //lh
            begin
                case(w)
                    2'b00:begin
                        din0[15:0]<=input_data_in[15:0];
                        din0[31:16]<={16{input_data_in[15]}};
                    end
                    2'b01:begin
                        din0[15:0]<=input_data_in[23:8];
                        din0[31:16]<={16{input_data_in[23]}};
                    end
                    2'b10:begin
                        din0[15:0]<=input_data_in[31:16];
                        din0[31:16]<={16{input_data_in[31]}};
                    end
                endcase
            end
        3'b011: //lw
            din0<=input_data_in;
        3'b101: begin//lbu
            case(w)
                2'b00:begin
                    din0[7:0]<=input_data_in[7:0];
                    din0[31:8]<=0;
                end
                2'b01:begin
                    din0[7:0]<=input_data_in[15:8];
                    din0[31:8]<=0;
                end
                2'b10:begin
                    din0[7:0]<=input_data_in[23:16];
                    din0[31:8]<=0;
                end
                2'b11:begin
                    din0[7:0]<=input_data_in[31:24];
                    din0[31:8]<=0;
                end
            endcase
        end
        3'b110: begin//lhu
            case(w)
                2'b00:begin
                    din0[15:0]<=input_data_in[15:0];
                    din0[31:16]<=0;
                end
                2'b01:begin
                    din0[15:0]<=input_data_in[23:8];
                    din0[31:16]<=0;
                end
                2'b10:begin
                    din0[15:0]<=input_data_in[31:24];
                    din0[31:16]<=0;
                end
            endcase
        end
        default: din0<=0;
    endcase
end
endmodule
