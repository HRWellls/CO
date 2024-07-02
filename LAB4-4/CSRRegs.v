`timescale 1ns / 1ps

module CSRRegs(
    input clk, rst,
    input [11:0] raddr, waddr,
    input [31:0] wdata,
    input [1:0] csr_wsc_mode,

    input expt_int,//旁路输出信号
    input [31:0] mepc_bypass_in,
    input [31:0] mcause_bypass_in,
    input [31:0] mtval_bypass_in,
    input [31:0] mstatus_bypass_in,  // 为mstatus添加旁路输入
    input [31:0] mtvec_bypass_in,    // 为mtvec添加旁路输入
    output [31:0] rdata,
    output [31:0] mstatus0, mtvec0, mcause0, mtval0, mepc0
);

    reg [31:0] rdata0;
    reg [31:0] mstatus, mtvec, mcause, mtval, mepc;
    assign rdata = rdata0;
    assign mstatus0 = mstatus;
    assign mtvec0 = mtvec;
    assign mcause0 = mcause;
    assign mtval0 = mtval;
    assign mepc0 = mepc;

    // CSR操作类型
    localparam CSR_W = 2'b01,  // csrrw
               CSR_S = 2'b10,  // csrrs
               CSR_C = 2'b11;  // csrrc

    // CSR读逻辑
    always @(*) begin
        case (raddr)
            12'h300: rdata0 = mstatus;
            12'h305: rdata0 = mtvec;
            12'h341: rdata0 = mepc;
            12'h342: rdata0 = mcause;
            12'h343: rdata0 = mtval;
            default: rdata0 = 32'b0;
        endcase
    end

    // CSR写逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mstatus <= 32'b0;
            mtvec <= 32'b0;
            mcause <= 32'b0;
            mtval <= 32'b0;
            mepc <= 32'b0;
        end else begin
            if (expt_int) begin
                mepc <= mepc_bypass_in;
                mcause <= mcause_bypass_in;
                mtval <= mtval_bypass_in;
                mstatus <= mstatus_bypass_in; // 使用旁路数据更新mstatus
                mtvec <= mtvec_bypass_in;    // 使用旁路数据更新mtvec
            end else if (csr_wsc_mode != 2'b00) begin
                case (waddr)
                    12'h300: begin
                        case (csr_wsc_mode)
                            CSR_W: mstatus <= wdata;
                            CSR_S: mstatus <= mstatus | wdata;
                            CSR_C: mstatus <= mstatus & ~wdata;
                        endcase
                    end
                    12'h305: begin
                        case (csr_wsc_mode)
                            CSR_W: mtvec <= wdata;
                            CSR_S: mtvec <= mtvec | wdata;
                            CSR_C: mtvec <= mtvec & ~wdata;
                        endcase
                    end
                    12'h341: begin
                        case (csr_wsc_mode)
                            CSR_W: mepc <= wdata;
                            CSR_S: mepc <= mepc | wdata;
                            CSR_C: mepc <= mepc & ~wdata;
                        endcase
                    end
                    12'h342: begin
                        case (csr_wsc_mode)
                            CSR_W: mcause <= wdata;
                            CSR_S: mcause <= mcause | wdata;
                            CSR_C: mcause <= mcause & ~wdata;
                        endcase
                    end
                    12'h343: begin
                        case (csr_wsc_mode)
                            CSR_W: mtval <= wdata;
                            CSR_S: mtval <= mtval | wdata;
                            CSR_C: mtval <= mtval & ~wdata;
                        endcase
                    end
                endcase
            end
        end
    end

endmodule
