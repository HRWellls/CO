`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 13:48:53
// Design Name: 
// Module Name: ALU_Ctrl
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


module ALU_Ctrl(
    input [6:0] opcode,
    input [1:0] ALU_op,
    input [2:0] fun3,
    input [6:0] fun7,

    output [3:0] ALU_operation
    );

reg [3:0] ALU_operation0;
assign ALU_operation=ALU_operation0;
    always @ (*) begin
        case(ALU_op)
            2'b00:ALU_operation0=4'b0000;//如果是ld/sd/auipc操作，直接做ADD
            2'b01://如果是branch类操作
                case(fun3)
                    3'd0,3'd1:ALU_operation0=4'd1;//sub->beq/bne
                    3'd4,3'd5:ALU_operation0=4'd3;//slt->blt/bge
                    3'd6,3'd7:ALU_operation0=4'd4;//sltu->bltu/bgeu
                endcase
            2'b10:
                case(fun3)
                    3'd0:
                        if(opcode==7'b0110011 && fun7[5]==1'b1)begin
                            ALU_operation0=4'd1;//SUB
                        end
                        else begin
                            ALU_operation0=4'd0;
                        end
                    3'd1:ALU_operation0=4'd2;//SLL
                    3'd2:ALU_operation0=4'd3;//SLT
                    3'd3:ALU_operation0=4'd4;//SLTU
                    3'd4:ALU_operation0=4'd5;//XOR
                    3'd5:
                        case(fun7[5])
                            1'b0:ALU_operation0=4'd6;//SRL
                            1'b1:ALU_operation0=4'd7;//SRA
                        endcase
                    3'd6:ALU_operation0=4'd8;//OR
                    3'd7:ALU_operation0=4'd9;//AND
                endcase
        endcase
    end

endmodule
