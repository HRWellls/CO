`timescale 1ns / 1ps
module ALU_tb;
reg [31:0]  A, B;
reg [3:0]   ALU_operation;
wire[31:0]  res;
wire        zero;
ALU ALU_u(
    .A(A),
    .B(B),
    .ALU_operation(ALU_operation),
    .res(res),
    .zero(zero)
);

initial begin
    A=32'hA5A5A5A5;
    B=32'h5A5A5A5A;
    ALU_operation =4'b1001;
    #100;
    ALU_operation =4'b1000;
    #100;
    ALU_operation =4'b0111;
    #100;
    ALU_operation =4'b0110;
    #100;
    ALU_operation =4'b0101;
    #100;
    ALU_operation =4'b0100;
    #100;
    ALU_operation =4'b0011;
    #100;
    ALU_operation =4'b0010;
    #100;
    ALU_operation =4'b0001;
    #100;
    ALU_operation =4'b0000;
    #100;
    A=32'h01234567;
    B=32'h76543210;
    ALU_operation =4'b0111;
    #100;

    // Additional boundary tests
    // Test with all zeros
    ALU_operation =4'b0000;//add
    A = 32'b0;
    B = 32'b0;
    #100;

    // Test with all ones
    ALU_operation =4'b1001;//and
    // Test with maximum values
    A = 32'hFFFFFFFF;
    B = 32'hFFFFFFFF;
    #100;

    // Test with minimum values
    A = 32'h80000000; // -2^31
    B = 32'h80000000; // -2^31
    #100;

    // Test overflow in addition
    ALU_operation =4'b0000;//add
    A = 32'h7FFFFFFF; // 2^31 - 1
    B = 32'h00000001; // 1
    #100;

    // Test underflow in subtraction
    ALU_operation =4'b0001;//substract
    A = 32'h80000000; // -2^31
    B = 32'h00000001; // 1
    #100;

    $stop;
end
endmodule