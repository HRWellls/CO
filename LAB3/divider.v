`timescale 1ns / 1ps
module divider(
    input clk,
    input rst,
    input start,
    input [31:0] dividend,
    input [31:0] divisor,
    output reg divide_zero,
    output reg finish,
    output reg [31:0] res,
    output reg [31:0] rem
);

// 内部变量定义
reg [63:0] divident_temp;
reg [31:0] divisor_temp;
reg [5:0] count;

wire [31:0] temp;
wire [31:0] res_temp;
wire [31:0] rem_temp;

assign temp = divident_temp[63:32] - divisor_temp;
assign res_temp = divident_temp[31:0] ; // 输出商
assign rem_temp = divident_temp[63:32] >> 1; // 输出余数

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // 复位所有输出和内部变量
        divide_zero <= 0;
        finish <= 0;
        res <= 0;
        rem <= 0;
        divident_temp <= 0;
        count <= 0;
    end 

    else if (start) begin
        if (divisor == 0) begin
            // 如果除数为0，则设置divide_zero为高位，结束计算
            divide_zero <= 1;
            finish <= 1;
        end 

        else begin
            // 初始化计算
            divide_zero <= 0;
            finish <= 0;
            divident_temp <= {32'b0,dividend}; // 扩展被除数以便于计算
            divisor_temp <= divisor;
            count <= 32; // 设置计数器为32，因为需要处理32位的数据
        end

    end 

    else if (count >= 0 && ~finish) begin
        if(count==32)begin
            divident_temp <= divident_temp << 1;
        end

        // 执行除法操作


        if (temp[31] == 1) begin
            divident_temp <= divident_temp << 1;
        end 
        
        else begin
            divident_temp <= ( { temp,divident_temp[31:0] } << 1 ) + 1;            
        end

        count <= count - 1; // 更新计数器
        if (count == 0) begin
            // 计算完成
            finish <= 1;
        end
    end
        res <= res_temp;
        rem <= rem_temp;
end

endmodule
