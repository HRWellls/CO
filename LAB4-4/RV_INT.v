`timescale 1ns / 1ps

module RV_INT(
    input       clk,
    input       rst,
    input       INT0,            // 外部中断信号
    input [1:0] interr,          // 中断类型


    // input       l_access_fault,   // 数据访存不对齐
    // input       j_access_fault,   // 跳转地址不对齐
    input [31:0] current_pc,
    input [31:0] pc_next,         // 不发生意外的情况下 下一条 PC 值
    
    output       en,              // 用于控制寄存器堆、内存等器件的写使能
    output[31:0] pc,              // 将执行的指令 PC 值
    output [31:0] mepc_bypass_in,
    output [31:0] mcause_bypass_in,
    output [31:0] mtval_bypass_in,
    output [31:0] mstatus_bypass_in,  // 为mstatus添加旁路输入
    output [31:0] mtvec_bypass_in    // 为mtvec添加旁路输入
);

parameter PC_illegal = 32'h 00000004;
parameter PC_ecall = 32'h 00000008; 
parameter PC_hardware = 32'h0000000C;

reg en0;
assign en = en0;
reg [31:0] pc0;
assign pc = pc0;
reg [31:0] mepc,mcause,mtval,mstatus,mtvec;
assign mepc_bypass_in = mepc;
assign mcause_bypass_in = mcause;
assign mtval_bypass_in = mtval;
assign mstatus_bypass_in = mstatus;
assign mtvec_bypass_in = mtvec;


always @ (posedge clk or posedge rst or posedge INT0) begin

    // Reset
    if (rst) begin
        en0 <= 1;
        pc0 <= 32'h00000000;
        mepc <= 0;
        mcause <= 0;
        mtval <= 0;
        mstatus <= 0;
        mtvec <= 0;
    end

    // Hardware triggered interrupt
    else if (INT0) begin
        if (en0) begin // Just entered interrupt triggered by hardware
            pc0 <= PC_hardware;
            en0 <= 0;

            mepc <= current_pc;
            mcause <= 32'h1000000b;
            mtval <= current_pc;
            mstatus <= 0;
            mtvec <= 32'h00000000;
        end
    end

    // Interruption
    else begin
        if (interr == 2'b01 && en0) begin // Just entered illegal instruction triggered interrupt
            pc0 <= PC_illegal;
            en0 <= 0;

            mepc <= pc_next;
            mcause <= 32'h00000002;
            mtval <= current_pc;
            mstatus <= 0;
            mtvec <= 32'h000000000;
        end

        else if (interr == 2'b10 && en0) begin // Just entered ecall triggered interrupt
            pc0 <= PC_ecall;
            en0 <= 0;

            mepc <= pc_next;
            mcause <= 32'h10000003;
            mtval <= current_pc;
            mstatus <= 0;
            mtvec <= 32'h00000000;
        end

        else if (interr == 2'b11 && (!en0)) begin // Just entered mret triggered interrupt
            pc0 <= mepc;
            en0 <= 1;
        end
        
        else begin
            pc0 <= pc_next;
        end
    end
end



endmodule
