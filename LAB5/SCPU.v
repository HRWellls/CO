`timescale 1ns / 1ps

module SCPU(
    input MIO_ready,
    input clk,
    input rst,
    input [31:0] Data_in,
    input [31:0] inst_in,

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

    output wire [31:0] pc_if,
    output wire [31:0] inst_if,
    output wire [31:0] pc_id,
    output wire [31:0] inst_id,
    output wire [31:0] pc_ex,
    output wire memrw_ex,
    output wire memrw_mem,
    output wire [31:0] data_out_wb
);

assign pc_if=PC_out;
assign inst_if=inst_in;
assign pc_id=PC_IF_ID;
assign inst_id=inst_IF_ID;
assign pc_ex=PC_ID_EX;
assign memrw_ex=MemRW;
assign memrw_mem=MemRW;
assign data_out_wb=Data_out;


//IF_ID----------------------------------------------------------------------------------------------------------------
wire [31:0] PC_IF_ID;
wire [31:0] inst_IF_ID;
//

//Control_Unit----------------------------------------------------------------------------------------------------------------
wire [1:0] Jump;
wire [2:0] MemRead;
wire [1:0] MemWrite;
wire Branch;
wire [1:0] ALU_op;
wire [1:0]MemtoReg;
wire ALUSrc;
wire aui;
wire RegWrite;
//

//Regs----------------------------------------------------------------------------------------------------------------
//

//ALU_Control----------------------------------------------------------------------------------------------------------------
wire [3:0] ALU_operation;
//

//Imm_Gen----------------------------------------------------------------------------------------------------------------
wire [31:0] imm;
//

//ID_EX----------------------------------------------------------------------------------------------------------------
wire [31:0] PC_ID_EX;
wire [31:0] inst_ID_EX;
wire [1:0] jump_ID_EX;
wire [2:0] mem_read_ID_EX;
wire branch_ID_EX;
wire [1:0] mem_to_reg_ID_EX;
wire [1:0] mem_write_ID_EX;
wire alu_src_ID_EX;
wire aui_ID_EX;
wire reg_write_ID_EX;
wire [31:0] rd1_ID_EX;
wire [31:0] rd2_ID_EX;
wire [3:0] alu_operation_ID_EX;
wire [5:0] write_reg_ID_EX;
wire [31:0] imm_ID_EX;
//

//MUX1----------------------------------------------------------------------------------------------------------------
wire [31:0] write_data;
//

//MemRW_dealer----------------------------------------------------------------------------------------------------------------
//

//MUX4----------------------------------------------------------------------------------------------------------------
wire [31:0] alu1;
//

//MUX5----------------------------------------------------------------------------------------------------------------
wire [31:0] alu2;
//

//ALU----------------------------------------------------------------------------------------------------------------
wire [31:0] alu_result;
wire zero;
//

//MUX3----------------------------------------------------------------------------------------------------------------
wire [31:0] pc0;
wire [31:0] pc1;
wire [31:0] pc2;
wire [31:0] branch_pc;
assign pc0=PC_out+4;
assign pc1=pc_EX_MEM+4;
assign pc2=pc_EX_MEM+imm_EX_MEM;
//

//MUX2----------------------------------------------------------------------------------------------------------------
wire [31:0] next_pc;
//

//EX_MEM----------------------------------------------------------------------------------------------------------------
wire [31:0] pc_EX_MEM;
wire [1:0] jump_EX_MEM;
wire [2:0] mem_read_EX_MEM;
wire branch_EX_MEM;
wire [1:0] mem_to_reg_EX_MEM;
wire [1:0] mem_write_EX_MEM;
wire reg_write_EX_MEM;
wire zero_EX_MEM;
wire [31:0] alu_result_EX_MEM;
wire [31:0] inst_EX_MEM;
wire [31:0] rd2_EX_MEM;
wire [5:0] write_reg_EX_MEM;
wire [31:0] imm_EX_MEM;
assign Addr_out=alu_result_EX_MEM;
//

//dealer2----------------------------------------------------------------------------------------------------------------
//

//dealer1----------------------------------------------------------------------------------------------------------------
wire [31:0] din;
//

//MEM_WB----------------------------------------------------------------------------------------------------------------
wire [31:0] pc_plus_4_MEM_WB;
wire reg_write_MEM_WB;
wire [1:0] mem_to_reg_MEM_WB;
wire [31:0] alu_result_MEM_WB;
wire [31:0] imm_MEM_WB;
wire [5:0] write_reg_MEM_WB;
wire [31:0] data_in_MEM_WB;
//

IF_ID IF_ID_inst(
    .clk(clk),
    .rst(rst),
    .input_pc(PC_out),
    .input_inst(inst_in),
    .output_pc(PC_IF_ID),
    .output_inst(inst_IF_ID)
);

Control_Unit Control_Unit_inst(
    .opcode(inst_IF_ID[6:0]),
    .funct3(inst_IF_ID[14:12]),

    .ALUSrc(ALUSrc),
    .Jump(Jump),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .RegWrite(RegWrite),
    .ALU_op(ALU_op),
    .aui(aui)
);

Regs Regs_inst(
    .clk(clk),
    .rst(rst),
    .Rs1_addr(inst_IF_ID[19:15]),
    .Rs2_addr(inst_IF_ID[24:20]),
    .Wt_addr(write_reg_MEM_WB),
    .Wt_data(write_data),
    .RegWrite(reg_write_MEM_WB),

    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .Rs1_data(rs1_val),
    .Rs2_data(rs2_val),
    .reg_i_data(reg_i_data),
    .reg_wen(reg_wen),

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
    .Reg31(Reg31)
);

ALU_Ctrl ALU_Ctrl_inst(
    .opcode(inst_IF_ID[6:0]),
    .fun3(inst_IF_ID[14:12]),
    .fun7(inst_IF_ID[31:25]),
    .ALU_op(ALU_op),

    .ALU_operation(ALU_operation)
);

Imm_Gen Imm_Gen_inst(
    .instruction(inst_IF_ID),

    .imm(imm)
);

ID_EX ID_EX_inst(
    .clk(clk),
    .rst(rst),
    .input_pc(PC_IF_ID),
    .input_inst(inst_IF_ID),
    .input_jump(Jump),
    .input_mem_read(MemRead),
    .input_branch(Branch),
    .input_mem_to_reg(MemtoReg),
    .input_mem_write(MemWrite),
    .input_alu_src(ALUSrc),
    .input_aui(aui),
    .input_reg_write(RegWrite),
    .input_rd1(rs1_val),
    .input_rd2(rs2_val),
    .input_alu_operation(ALU_operation),
    .inpu_write_reg(inst_IF_ID[11:7]),
    .input_imm(imm),

    .output_pc(PC_ID_EX),
    .output_inst(inst_ID_EX),
    .output_jump(jump_ID_EX),
    .output_mem_read(mem_read_ID_EX),
    .output_branch(branch_ID_EX),
    .output_mem_to_reg(mem_to_reg_ID_EX),
    .output_mem_write(mem_write_ID_EX),
    .output_alu_src(alu_src_ID_EX),
    .output_aui(aui_ID_EX),
    .output_reg_write(reg_write_ID_EX),
    .output_rd1(rd1_ID_EX),
    .output_rd2(rd2_ID_EX),
    .output_alu_operation(alu_operation_ID_EX),
    .output_write_reg(write_reg_ID_EX),
    .output_imm(imm_ID_EX)
);

MUX4 MUX4_inst(
    .aui(aui_ID_EX),
    .rd1(rd1_ID_EX),
    .pc(PC_ID_EX),
    .alu1(alu1)
);

MUX5 MUX5_inst(
    .ALUSrc(alu_src_ID_EX),
    .rd2(rd2_ID_EX),
    .imm(imm_ID_EX),

    .alu2(alu2)
);

ALU ALU_inst(
    .ALU_operation(alu_operation_ID_EX),
    .A(alu1),
    .B(alu2),

    .res(alu_result),
    .zero(zero)
);

MUX3 MUX3_inst(
    .Branch(branch_EX_MEM),
    .zero(zero_EX_MEM),
    .fun3(inst_EX_MEM[14:12]),
    .from_pc(pc0),
    .from_branch(pc2),
    .ALU_result(alu_result_EX_MEM),

    .branch_pc(branch_pc)
);

MUX2 MUX2_inst(
    .Jump(jump_EX_MEM),
    .from_pc_branch(branch_pc),
    .from_jal(pc2), 
    .from_jalr(alu_result_EX_MEM),

    .next_pc(next_pc)
);

EX_MEM EX_MEM_inst(
    .clk(clk),
    .rst(rst),
    .input_pc(PC_ID_EX),
    .input_jump(jump_ID_EX),
    .input_mem_read(mem_read_ID_EX),
    .input_branch(branch_ID_EX),
    .input_mem_to_reg(mem_to_reg_ID_EX),
    .input_mem_write(mem_write_ID_EX),
    .input_reg_write(reg_write_ID_EX),
    .input_zero(zero),
    .input_alu_result(alu_result),
    .input_inst(inst_ID_EX),
    .input_rd2(rd2_ID_EX),
    .input_write_reg(write_reg_ID_EX),
    .input_imm(imm_ID_EX),

    .output_pc(pc_EX_MEM),
    .output_jump(jump_EX_MEM),
    .output_mem_read(mem_read_EX_MEM),
    .output_branch(branch_EX_MEM),
    .output_mem_to_reg(mem_to_reg_EX_MEM),
    .output_mem_write(mem_write_EX_MEM),
    .output_reg_write(reg_write_EX_MEM),
    .output_zero(zero_EX_MEM),
    .output_alu_result(alu_result_EX_MEM),
    .output_inst(inst_EX_MEM),
    .output_rd2(rd2_EX_MEM),
    .output_write_reg(write_reg_EX_MEM),
    .output_imm(imm_EX_MEM)
);

dealer2 dealer2_inst(
    .Addr_out(Addr_out),
    .MemWrite(mem_write_EX_MEM),
    .rs2_val(rd2_EX_MEM),

    .output_data_out(Data_out)
);

dealer1 dealer1_inst(
    .input_data_in(Data_in),
    .MemRead(mem_read_EX_MEM),
    .Addr_out(Addr_out),

    .output_data_in(din)
);

MemRW_dealer MemRW_dealer_inst(
    .inst_in(inst_EX_MEM),
    .Addr_out(Addr_out),
    .MemRW(MemRW)
);

MEM_WB MEM_WB_inst(
    .clk(clk),
    .rst(rst),
    .input_pc_plus_4(pc1),
    .input_reg_write(reg_write_EX_MEM),
    .input_mem_to_reg(mem_to_reg_EX_MEM),
    .input_alu_result(alu_result_EX_MEM),
    .input_imm(imm_EX_MEM),
    .input_write_reg(write_reg_EX_MEM),
    .input_data_in(din),

    .output_pc_plus_4(pc_plus_4_MEM_WB),
    .output_reg_write(reg_write_MEM_WB),
    .output_mem_to_reg(mem_to_reg_MEM_WB),
    .output_alu_result(alu_result_MEM_WB),
    .output_imm(imm_MEM_WB),
    .output_write_reg(write_reg_MEM_WB),
    .output_data_in(data_in_MEM_WB)
);

MUX1 MUX1_inst(
    .MemtoReg(mem_to_reg_MEM_WB),
    .from_alu(alu_result_MEM_WB),
    .from_memory(data_in_MEM_WB),
    .from_pc(pc_plus_4_MEM_WB),
    .from_imm(imm_MEM_WB),

    .reg_write_data(write_data)
);

PC PC_inst(
    .clk(clk),
    .rst(rst),
    .D(next_pc),

    .Q(PC_out)
);
endmodule