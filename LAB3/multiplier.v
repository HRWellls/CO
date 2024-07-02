`timescale 1ns / 1ps
module multiplier(
  input           clk,      // 时钟信号
  input           start,     // 开始运算
  input [31:0]    A,        // 两个 32-bit 输入值
  input [31:0]    B,
  output     reg     finish,   // 当结束计算时置 1，你可能需要将它改为 `output reg`
  output  reg   [63:0] res       // 64-bit 输出，你可能需要将它修改为 `output reg[63:0]`
);

  reg state; // 记录 multiplier 是不是正在进行运算
  reg[31:0] multiplicand; // 保存当前运算中的被乘数
  reg[4:0] cnt; // 记录当前计算已经经历了几个周期（运算与移位）

  wire[5:0] cnt_next = cnt + 6'b1;//计数器的迭代
  wire [31:0] temp= res [63:32] + multiplicand ;//每一次加法的运算结果

  reg [31:0] temp_a;//输入A
  reg [31:0] temp_b;//输入B
  wire [31:0] temp_result;//暂存结果
  reg sign = 0; // 记录当前运算的结果是否是负数

  initial begin//将寄存器都初始化为0
    res <= 0;
    state <= 0;
    finish <= 0;
    cnt <= 0;
    multiplicand <= 0;
  end

assign temp_result=~res+1;//负数取反最后的加1

  always @(posedge clk) begin
    if(~state && start ) begin//开始计算
      // Not Running
      sign <= (A[31] ^ B[31]);//判断正负

      if(A[31]==1)temp_a=(~A)+1;//负数则取反
      else temp_a=A;

      if(B[31]==1)temp_b=(~B)+1;//负数则取反
      else temp_b=B;

      multiplicand = temp_a;
      res[63:32] <=0 ;
      res[31:0]  <=temp_b ;
      state <= 1;
      finish <= 0;
      cnt <= 0;
    end 
    else if(state) begin
      // Running
      // 处理“一次”运算与移位
      cnt <= cnt_next;
      if(res[0]==1)begin
        res[63:32] = temp;//高位相加
      end
      res<=res>>1;//右移
    end

    
    if(cnt==31) begin
      // 迭代结束 得到结果
      cnt <= 0;
      finish <= 1;
      state <= 0;
      
      if(sign==1)begin//若结果为负数，最后取反加1
        res <= ~(res >> 1) + 1'b1;
      end else begin
        res <= res  >> 1;
      end
    end
  end
endmodule

