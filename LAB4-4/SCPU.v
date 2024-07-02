`timescale 1ns / 1ps

module SCPU(
    input MIO_ready,
    input clk,
    input rst,
    input [31:0] Data_in,
    input [31:0] inst_in,
    input INT0,//the hardware interrupt signal

    output CPU_MIO,
    output [3:0]  MemRW,
    output [31:0] Addr_out,
    output [31:0] Data_out,
    output [31:0] PC_out,

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
    output [31:0] rs1_val,
    output [31:0] rs2_val,
    output [31:0] reg_i_data,
    output reg_wen,

    output [31:0] mstatus,
    output [31:0] mtvec,
    output [31:0] mcause,
    output [31:0] mtval,
    output [31:0] mepc

);

//RV_INT
wire en;//the signal of normal interrupt
wire [31:0] mepc_bypass_in0,mcause_bypass_in0,mtval_bypass_in0,mstatus_bypass_in0,mtvec_bypass_in0;

//CSRRegs
wire [31:0] write_data_from_mux6,data_from_csr;

//MUX7
wire [31:0] final_write_data;

reg [3:0] MemRW0;
assign MemRW=MemRW0;

wire [1:0] interr;

//Control_Unit
wire [1:0] Jump;
wire [2:0] MemRead;
wire [1:0] MemWrite;
wire Branch;
wire [1:0] ALU_op;
wire [1:0]MemtoReg;
wire ALUSrc;
wire aui;
wire RegWrite;
wire [2:0] csr_wsc_mode;

//ALU_Ctrl
wire [3:0] ALU_operation;

//RegFiles
wire [31:0] write_data;//the line to write data into the regs

//ALU
wire zero;//if the result of alu is 0
wire [31:0] alu1 , alu2 ,ALU_result;// the 2 source of the alu and the result
assign Addr_out=ALU_result;

wire[1:0] w;
assign w=Addr_out%4;

//Imm_Gen
wire [31:0] imm;

//PC
wire [31:0] pc;
wire [31:0] pc1;
wire [31:0] pc2;
assign pc=PC_out;
assign pc1=pc+4;
assign pc2=pc+imm;

//MUX3
wire [31:0] branch_pc;

//MUX2  
wire [31:0] next_pc;

wire [31:0] din;
reg  [31:0] din0,dout0;

always @(*) begin
    case(MemRead)
        3'b001: //lb
            begin
                case(w) 
                    2'b00:begin
                        din0[7:0]<=Data_in[7:0];
                        din0[31:8]<={24{Data_in[7]}};
                    end
                    2'b01:begin
                        din0[7:0]<=Data_in[15:8];
                        din0[31:8]<={24{Data_in[15]}};
                    end
                    2'b10:begin
                        din0[7:0]<=Data_in[23:16];
                        din0[31:8]<={24{Data_in[23]}};
                    end
                    2'b11:begin
                        din0[7:0]<=Data_in[31:24];
                        din0[31:8]<={24{Data_in[31]}};
                    end
                endcase
            end
        3'b010: //lh
            begin
                case(w)
                    2'b00:begin
                        din0[15:0]<=Data_in[15:0];
                        din0[31:16]<={16{Data_in[15]}};
                    end
                    2'b01:begin
                        din0[15:0]<=Data_in[23:8];
                        din0[31:16]<={16{Data_in[23]}};
                    end
                    2'b10:begin
                        din0[15:0]<=Data_in[31:16];
                        din0[31:16]<={16{Data_in[31]}};
                    end
                endcase
            end
        3'b011: //lw
            din0<=Data_in;
        3'b101: begin//lbu
            case(w)
                2'b00:begin
                    din0[7:0]<=Data_in[7:0];
                    din0[31:8]<=0;
                end
                2'b01:begin
                    din0[7:0]<=Data_in[15:8];
                    din0[31:8]<=0;
                end
                2'b10:begin
                    din0[7:0]<=Data_in[23:16];
                    din0[31:8]<=0;
                end
                2'b11:begin
                    din0[7:0]<=Data_in[31:24];
                    din0[31:8]<=0;
                end
            endcase
        end
        3'b110: begin//lhu
            case(w)
                2'b00:begin
                    din0[15:0]<=Data_in[15:0];
                    din0[31:16]<=0;
                end
                2'b01:begin
                    din0[15:0]<=Data_in[23:8];
                    din0[31:16]<=0;
                end
                2'b10:begin
                    din0[15:0]<=Data_in[31:24];
                    din0[31:16]<=0;
                end
            endcase
        end
        default: din0<=0;
    endcase
end

always @(*)begin
    case(MemWrite)
        2'b01: //sb
            begin
                case(w)
                    2'b00:begin
                        dout0[7:0]<=rs2_val[7:0];
                        dout0[31:8]<=0;
                    end
                    2'b01:begin
                        dout0[15:8]<=rs2_val[7:0];
                        dout0[31:16]<=0;
                        dout0[7:0]<=0;
                    end
                    2'b10:begin
                        dout0[23:16]<=rs2_val[7:0];
                        dout0[31:24]<=0;
                        dout0[15:0]<=0;
                    end
                    2'b11:begin
                        dout0[31:24]<=rs2_val[7:0];
                        dout0[23:0]<=0;
                    end
                endcase
            end
        2'b10: //sh
            begin
              case(w)
                2'b00:begin
                    dout0[15:0]<=rs2_val[15:0];
                    dout0[31:16]<=0;
                end
                2'b01:begin
                    dout0[23:8]<=rs2_val[15:0];
                    dout0[31:24]<=0;
                    dout0[7:0]<=0;
                end
                2'b10:begin
                    dout0[31:16]<=rs2_val[15:0];
                    dout0[15:0]<=0;
                end
                endcase 
            end
        2'b11: //sw
            dout0<=rs2_val;        
        default: dout0<=0;
    endcase
end

always @(*)begin
    if(inst_in[6:0]==7'b0100011)begin
        case(inst_in[14:12])
            3'b000://sb
                begin
                    case(w)
                        2'b00:MemRW0<=4'b0001;
                        2'b01:MemRW0<=4'b0010;
                        2'b10:MemRW0<=4'b0100;
                        2'b11:MemRW0<=4'b1000;
                    endcase
                end
            3'b001://sh
                begin
                    case(w)
                        2'b00:MemRW0<=4'b0011;
                        2'b01:MemRW0<=4'b0110;
                        2'b10:MemRW0<=4'b1100;
                    endcase
                end
            3'b010://sw
                begin
                    MemRW0<=4'b1111;
                end
            default:MemRW0<=4'b0000;
        endcase
    end
    else MemRW0<=4'b0000;
end



assign din=din0;
assign Data_out=dout0;

Regs Regs(
    .clk(clk),
    .rst(rst),
    .Rs1_addr(inst_in[19:15]),
    .Rs2_addr(inst_in[24:20]),
    .Wt_addr(inst_in[11:7]),
    .Wt_data(final_write_data),
    .RegWrite(RegWrite),



    .Reg00(Reg00),
    .Reg01(Reg01),
    .Reg02(Reg02),
    .Reg03(Reg03),
    .Reg04(Reg04),
    .Reg05(Reg05),
    .Reg06(Reg06),
    .Reg07(Reg07),
    .Reg08(Reg08),
    .Reg09(Reg09),
    .Reg10(Reg10),
    .Reg11(Reg11),
    .Reg12(Reg12),
    .Reg13(Reg13),
    .Reg14(Reg14),
    .Reg15(Reg15),
    .Reg16(Reg16),
    .Reg17(Reg17),
    .Reg18(Reg18),
    .Reg19(Reg19),
    .Reg20(Reg20),
    .Reg21(Reg21),
    .Reg22(Reg22),
    .Reg23(Reg23),
    .Reg24(Reg24),
    .Reg25(Reg25),
    .Reg26(Reg26),
    .Reg27(Reg27),
    .Reg28(Reg28),
    .Reg29(Reg29),
    .Reg30(Reg30),
    .Reg31(Reg31),

    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .Rs1_data(rs1_val),
    .Rs2_data(rs2_val),
    .reg_i_data(reg_i_data),
    .reg_wen(reg_wen)


);

ALU ALU(
    .A(alu1),
    .B(alu2),
    .ALU_operation(ALU_operation),

    .res(ALU_result),
    .zero(zero)
);

Control_Unit Control_Unit(
    .opcode(inst_in[6:0]),
    .funct3(inst_in[14:12]),
    .funct12(inst_in[31:20]),
    .csr_kind(inst_in[14:12]),

    .ALUSrc(ALUSrc),
    .Jump(Jump),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .RegWrite(RegWrite),
    .ALU_op(ALU_op),
    .aui(aui),
    .interr(interr),
    .csr_wsc_mode(csr_wsc_mode)
);


ALU_Ctrl ALU_Ctrl(
    .opcode(inst_in[6:0]),
    .ALU_op(ALU_op),
    .fun3(inst_in[14:12]),
    .fun7(inst_in[31:25]),

    .ALU_operation(ALU_operation)
);

Imm_Gen Imm_Gen(
    .instruction(inst_in),

    .imm(imm)
);

MUX1 MUX1(
    .MemtoReg(MemtoReg),
    .from_alu(ALU_result),
    .from_imm(imm),
    .from_memory(din),
    .from_pc(pc1),

    .reg_write_data(write_data)
);

MUX2 MUX2(
    .Jump(Jump),
    .from_pc_branch(branch_pc),
    .from_jal(pc2),
    .from_jalr(ALU_result),

    .next_pc(next_pc)
);

RV_INT RV_INT(
    .clk(clk),
    .rst(rst),
    .INT0(INT0),
    .interr(interr),

    

    .current_pc(pc),
    .pc_next(next_pc),

    .en(en),
    .pc(PC_out),
    .mepc_bypass_in(mepc_bypass_in0),
    .mcause_bypass_in(mcause_bypass_in0),
    .mtval_bypass_in(mtval_bypass_in0),
    .mstatus_bypass_in(mstatus_bypass_in0),
    .mtvec_bypass_in(mtvec_bypass_in0)
);

CSRRegs CSRRegs(
    .clk(clk),
    .rst(rst),
    .raddr(inst_in[31:20]),
    .waddr(inst_in[31:20]),
    .wdata(write_data_from_mux6),
    .csr_wsc_mode(csr_wsc_mode),

    .expt_int(!en),
    .mepc_bypass_in(mepc_bypass_in0),
    .mcause_bypass_in(mcause_bypass_in0),
    .mtval_bypass_in(mtval_bypass_in0),
    .mstatus_bypass_in(mstatus_bypass_in0),
    .mtvec_bypass_in(mtvec_bypass_in0),

    .rdata(data_from_csr),
    .mstatus0(mstatus),
    .mtvec0(mtvec),
    .mcause0(mcause),
    .mtval0(mtval),
    .mepc0(mepc)
);

MUX6 MUX6(
    .choice(inst_in[14]),
    .imm(imm),
    .reg_data(rs1_val),

    .out(write_data_from_mux6)
);

MUX7 MUX7(
    .choice(csr_wsc_mode),
    .from_mux1(write_data),
    .from_csr_regs(data_from_csr),

    .out(final_write_data)
);

MUX3 MUX3(
    .Branch(Branch),
    .zero(zero),
    .fun3(inst_in[14:12]),
    .from_pc(pc1),
    .from_branch(pc2),
    .ALU_result(ALU_result),

    .branch_pc(branch_pc)
);

MUX4 MUX4(
    .aui(aui),
    .rd1(rs1_val),
    .pc(pc),

    .alu1(alu1)
);

MUX5 MUX5(
    .ALUSrc(ALUSrc),
    .rd2(rs2_val),
    .imm(imm),

    .alu2(alu2)
);


endmodule




