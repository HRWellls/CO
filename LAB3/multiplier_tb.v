`timescale 1ns / 1ps

// 定义 multiplier_tb 模块，用于对乘法器进行仿真测试
module multiplier_tb;

  // 输入端口声明
  reg clk, start;      // 时钟信号和启动信号
  reg[31:0] A;         // 32 位输入值 A
  reg[31:0] B;         // 32 位输入值 B

  // 输出端口声明
  wire finish;         // 完成信号
  wire[63:0] res;      // 64 位输出结果

  // 实例化被测试的 multiplier 模块
  multiplier m0(.clk(clk), .start(start), .A(A), .B(B), .finish(finish), .res(res));

  // 初始化块，用于设置仿真环境和激励信号
  initial begin
    // 设置 VCD 文件名以及要记录的变量
    $dumpfile("multiplier_signed.vcd");
    $dumpvars(0, multiplier_tb);

    // 初始化输入信号
    clk = 0;
    start = 0;

    // 第一组测试用例
    #10;                // 等待 10 个时间单位
    A = 32'd1;          // 设置输入 A 为正数 1
    B = 32'd0;          // 设置输入 B 为零
    #10 start = 1;      // 启动计算
    #10 start = 0;      // 停止计算
    #200;               // 等待 200 个时间单位，观察结果

    // 第二组测试用例
    A = -32'd10;        // 设置输入 A 为负数 -10
    B = 32'd30;         // 设置输入 B 为正数 30
    #10 start = 1;      // 启动计算
    #10 start = 0;      // 停止计算
    #200;               // 等待 200 个时间单位，观察结果

    // 第三组测试用例
    A = 32'd66;         // 设置输入 A 为正数 66
    B = 32'd23;         // 设置输入 B 为正数 23
    #10 start = 1;      // 启动计算
    #10 start = 0;      // 停止计算
    #200;               // 等待 200 个时间单位，观察结果

    // 第四组测试用例
    A = -32'd6;         // 设置输入 A 为负数 -6
    B = 32'd30;         // 设置输入 B 为正数 30
    #10 start = 1;      // 启动计算
    #10 start = 0;      // 停止计算
    #300;               // 等待 300 个时间单位，观察结果

    $finish();          // 结束仿真
  end

  // 时钟生成
  always begin
    #2 clk = ~clk;      // 每 2 个时间单位反转一次时钟信号
  end
endmodule
