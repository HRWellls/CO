`timescale 1ns / 1ps

module Control_Unit(
    input [6:0] opcode,
    input [2:0] funct3,

    output ALUSrc,//0->use rs2 ; 1->use imm
    output [1:0] Jump,//00->PC+4/Branch ; 01->jal ; 10->jalr //this is the last mux before PC
    output Branch,
    output [2:0] MemRead, //001->lb ; 010->lh ; 011->lw ; 101->lbu ; 110->lhu
    output [1:0] MemtoReg,//00->ALU_result ; 01->Memory ; 10->PC+4 ; 11->imm
    output [1:0] MemWrite,//01->sb ; 10->sh ; 11->sw
    output RegWrite,
    output [1:0] ALU_op,//00->ld/sd/auipc ; 01->beq ; 10->R_type
    output aui//1->auipc ; 0->others
    );

    
    
reg ALUSrc0,RegWrite0,Branch0,aui0;
reg[1:0]  Jump0,ALU_op0,MemtoReg0,MemWrite0;
reg[2:0]  MemRead0;

assign RegWrite=RegWrite0;
assign MemRead=MemRead0;
assign MemWrite=MemWrite0;
assign Branch=Branch0;
assign aui=aui0;
assign Jump=Jump0;
assign ALU_op=ALU_op0;
assign ALUSrc=ALUSrc0;
assign MemtoReg=MemtoReg0;


always @ (*) begin
    case(opcode)
        7'b0110011://R add
            begin
                ALUSrc0=0;
                MemtoReg0=2'b00;
                RegWrite0=1;
                MemRead0=3'b0;
                MemWrite0=2'b0;
                Branch0=0;
                Jump0=2'b00;
                ALU_op0=2'b10;
                aui0=0;
            end

        7'b0010011://I  addi
            begin
                ALUSrc0=1;
                MemtoReg0=2'b00;
                RegWrite0=1;
                MemRead0=3'b0;
                MemWrite0=2'b0;
                Branch0=0;
                Jump0=2'b00;
                ALU_op0=2'b10;
                aui0=0;
            end

        7'b0000011://I  ld
            begin
                ALUSrc0=1;
                MemtoReg0=2'b01;
                RegWrite0=1;
                // MemRead0=1;
                MemWrite0=2'b0;
                Branch0=0;
                Jump0=2'b00;
                ALU_op0=2'b00;    
                aui0=0;  
                case(funct3)
                    3'b000:MemRead0=3'b001;
                    3'b001:MemRead0=3'b010;
                    3'b010:MemRead0=3'b011;
                    3'b100:MemRead0=3'b101;
                    3'b101:MemRead0=3'b110;
                endcase          
            end

        7'b0100011://S sd
            begin
                ALUSrc0=1;
                RegWrite0=0;
                MemRead0=3'b0;
                Branch0=0;
                Jump0=2'b00;
                ALU_op0=2'b00;
                aui0=0;
                case(funct3)
                    3'b000:MemWrite0=2'b01;
                    3'b001:MemWrite0=2'b10;
                    3'b010:MemWrite0=2'b11;
                endcase
            end

        7'b1100011://B beq
            begin
                ALUSrc0=0;
                RegWrite0=0;
                MemRead0=3'b0;
                MemWrite0=2'b0;
                Branch0=1;
                Jump0=2'b00;
                ALU_op0=2'b01;
                aui0=0;
            end

        7'b1101111://J jal
            begin
                MemtoReg0=2'b10;
                RegWrite0=1;
                MemRead0=3'b0;
                MemWrite0=2'b0;
                Branch0=0;
                Jump0=2'b01;
                aui0=0;
            end

        7'b1100111://J jalr
            begin
                ALUSrc0=1;
                MemtoReg0=2'b10;
                RegWrite0=1;
                MemRead0=3'b0;
                MemWrite0=2'b0;
                Branch0=0;
                Jump0=2'b10;
                ALU_op0=2'b00;
                aui0=0;
            end            

        7'b0110111://U lui
            begin
                MemtoReg0=2'b11;
                RegWrite0=1;
                MemRead0=3'b0;
                MemWrite0=2'b0;
                Branch0=0;
                Jump0=2'b00;   
                aui0=0;           
            end

        7'b0010111:
            begin
                aui0=1;
                ALUSrc0=1;
                ALU_op0=2'b00;
                MemWrite0=2'b0;
                MemRead0=3'b0;
                Branch0=0;
                Jump0=2'b00;
                MemtoReg0=2'b00;
                RegWrite0=1;
            end
        
    endcase
end

endmodule
