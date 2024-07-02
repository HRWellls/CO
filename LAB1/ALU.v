`timescale 1ns / 1ps
module ALU (
  input [31:0]  A,
  input [31:0]  B,
  input [3:0]   ALU_operation,
  output[31:0]  res,
  output        zero
);//输入输出
reg [31:0] res0;
reg zero0;

always @(*) begin
    case (ALU_operation)//选择不同的操作
        4'd0: res0 = A+B;//加
        4'd1: res0 = A-B;//减
        4'd2: res0 = A<<B[4:0];//左移
        4'd3: res0 = ($signed(A)<$signed(B))?1:0;//有符号判断大小
        4'd4: res0 = ($unsigned(A)<$unsigned(B))?1:0;//无符号判断大小
        4'd5: res0 = A^B;//按位异或
        4'd6: res0 = A>>B[4:0];//右移
        4'd7: res0 = $signed(A)>>>B[4:0];//逻辑右移
        4'd8: res0 = A|B;//按位或
        4'd9: res0 = A&B;//按位与
        default: res0 = 0; 
    endcase
    if (res0 == 0)//检测是否为0值
        zero0 = 1;
    else zero0 = 0;
end
assign res = res0;
assign zero =zero0;
endmodule