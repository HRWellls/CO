`timescale 1ns / 1ps
module divider_tb();
    reg clk;
    reg rst;
    reg [31:0] dividend;
    reg [31:0] divisor;
    reg start;

    wire divide_zero;
    wire [31:0] res;
    wire [31:0] rem;
    wire finish;

    // 实例化被测模块
    divider u_div(
        .clk(clk),
        .rst(rst),
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .divide_zero(divide_zero),
        .res(res),
        .rem(rem),
        .finish(finish)
    );

    // 生成时钟信号
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 时钟周期为10ns
    end

    // 测试案例
    initial begin
        // 初始化测试环境
        rst = 1; start = 1; dividend = 2; divisor = 0;
        #10; // 等待一段时间以确保复位完成
        
        // 清除复位信号
        rst = 0;

        // 测试案例1：普通除法操作
        #10; dividend = 7; divisor = 2; start = 1;
        #10; start = 0; // 开始信号重置      
        #400; // 等待额外的时间确保所有信号都已更新

        // 测试案例2：除数为0的情况
        #10; dividend = 50; divisor = 13; start = 1;
        #10; start = 0; // 开始信号重置
        #400;



        //测试结束
        $finish;
    end

    // 可选：添加波形输出
    initial begin
        $dumpfile("divider_tb.vcd");
        $dumpvars(0, divider_tb);
    end

endmodule
