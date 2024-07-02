`timescale 1ns / 1ns
module Regs_tb;
    reg clk;
    reg rst;
    reg [4:0] Rs1_addr; 
    reg [4:0] Rs2_addr; 
    reg [4:0] Wt_addr; 
    reg [31:0]Wt_data; 
    reg RegWrite; 
    wire [31:0] Rs1_data; 
    wire [31:0] Rs2_data;
    Regs Regs_U(
        .clk(clk),
        .rst(rst),
        .Rs1_addr(Rs1_addr),
        .Rs2_addr(Rs2_addr),
        .Wt_addr(Wt_addr),
        .Wt_data(Wt_data),
        .RegWrite(RegWrite),
        .Rs1_data(Rs1_data),
        .Rs2_data(Rs2_data)
    );
    always #10 clk = ~clk;

    initial begin
        //reset operation
        clk = 0;
        rst = 1;
        RegWrite = 0;
        Wt_data = 0;
        Wt_addr = 0;
        Rs1_addr = 0;
        Rs2_addr = 0;

        #50//write operation
        rst = 0;
        RegWrite = 1;
        Wt_addr = 5'b00101;
        Wt_data = 32'ha5a5a5a5;
        #50
        Wt_addr = 5'b01010;
        Wt_data = 32'h5a5a5a5a;

        #50//read operation
        RegWrite = 0;
        Rs1_addr = 5'b00101;
        Rs2_addr = 5'b01010;

        #50//boundary operation
        RegWrite = 1 ;
        Wt_addr = 5'b00000;
        Wt_data = 32'h11111111;
        #50
        Wt_addr = 5'b11111;
        Wt_data = 32'h22222222;
        #50
        Wt_addr = 5'b00101;
        Wt_data = 5'b11111;

        #50//again reset operation
        rst = 1;
        #50
        rst = 0;

        #50 $stop();
    end
endmodule