`timescale 1ns / 1ps
module Regs(
    input clk,
    input rst,
    input [4:0] Rs1_addr, 
    input [4:0] Rs2_addr, 
    input [4:0] Wt_addr, 
    input [31:0]Wt_data, 
    input RegWrite, 

    output [31:0] Reg00,
    output [31:0] Reg01,
    output [31:0] Reg02,
    output [31:0] Reg03,
    output [31:0] Reg04,
    output [31:0] Reg05,
    output [31:0] Reg06,
    output [31:0] Reg07,
    output [31:0] Reg08,
    output [31:0] Reg09,
    output [31:0] Reg10,
    output [31:0] Reg11,
    output [31:0] Reg12,
    output [31:0] Reg13,
    output [31:0] Reg14,
    output [31:0] Reg15,
    output [31:0] Reg16,
    output [31:0] Reg17,
    output [31:0] Reg18,
    output [31:0] Reg19,
    output [31:0] Reg20,
    output [31:0] Reg21,
    output [31:0] Reg22,
    output [31:0] Reg23,
    output [31:0] Reg24,
    output [31:0] Reg25,
    output [31:0] Reg26,
    output [31:0] Reg27,
    output [31:0] Reg28,
    output [31:0] Reg29,
    output [31:0] Reg30,
    output [31:0] Reg31,

    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [31:0] Rs1_data, 
    output [31:0] Rs2_data,
    output [31:0] reg_i_data,
    output reg_wen
);

integer i;
reg [31:0] register [31:0];//寄存器组
reg [31:0] rs1_d ;//两个中间寄存器
reg [31:0] rs2_d ;


always @(posedge clk or posedge rst ) begin
    if (rst) begin//如果rst信号为1，全部初始化为0
        rs1_d = 0 ;
        rs2_d = 0 ;
        for (i=0;i<=31;i=i+1)begin
            register[i]=0;
        end
    end

    else if (RegWrite) begin//如果regwrite信号为1，则执行写操作
       if(Wt_addr != 0)
       register[Wt_addr]=Wt_data;
    end 

    else begin//否则执行读操作
        rs1_d = register[Rs1_addr] ;
        rs2_d = register[Rs2_addr] ;
    end
end


assign rs1 = Rs1_addr;
assign rs2 = Rs2_addr;
assign rd = Wt_addr;
assign Rs1_data=register[Rs1_addr];
assign Rs2_data=register[Rs2_addr];
assign reg_i_data=register[Wt_addr];
assign reg_wen=RegWrite;

assign Reg00 = register [0];
assign Reg01 = register [1];
assign Reg02 = register [2];
assign Reg03 = register [3];
assign Reg04 = register [4];
assign Reg05 = register [5];
assign Reg06 = register [6];
assign Reg07 = register [7];
assign Reg08 = register [8];
assign Reg09 = register [9];
assign Reg10 = register [10];
assign Reg11 = register [11];
assign Reg12 = register [12];
assign Reg13 = register [13];
assign Reg14 = register [14];
assign Reg15 = register [15];
assign Reg16 = register [16];
assign Reg17 = register [17];
assign Reg18 = register [18];
assign Reg19 = register [19];
assign Reg20 = register [20];
assign Reg21 = register [21];
assign Reg22 = register [22];
assign Reg23 = register [23];
assign Reg24 = register [24];
assign Reg25 = register [25];
assign Reg26 = register [26];
assign Reg27 = register [27];
assign Reg28 = register [28];
assign Reg29 = register [29];
assign Reg30 = register [30];
assign Reg31 = register [31];
endmodule