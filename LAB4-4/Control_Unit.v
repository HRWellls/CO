`timescale 1ns / 1ps

module Control_Unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [11:0] funct12,
    input [2:0] csr_kind,

    output ALUSrc,//0->use rs2 ; 1->use imm
    output [1:0] Jump,//00->PC+4/Branch ; 01->jal ; 10->jalr //this is the last mux before PC
    output Branch,
    output [2:0] MemRead, //001->lb ; 010->lh ; 011->lw ; 101->lbu ; 110->lhu
    output [1:0] MemtoReg,//00->ALU_result ; 01->Memory ; 10->PC+4 ; 11->imm
    output [1:0] MemWrite,//01->sb ; 10->sh ; 11->sw
    output RegWrite,
    output [1:0] ALU_op,//00->ld/sd/auipc ; 01->beq ; 10->R_type
    output aui,//1->auipc ; 0->others
    output [1:0] interr,//00:normal ;01: illegal ; 10: ecall ; 11:mret
    output [1:0] csr_wsc_mode//00-> not 3 kinds ; 01->cssrw ; 10->csrrs ; 11->csrrc
    );

    
    
reg ALUSrc0,RegWrite0,Branch0,aui0;
reg[1:0]  Jump0,ALU_op0,MemtoReg0,MemWrite0;
reg[2:0]  MemRead0;

reg [1:0] interr0;
reg [1:0] csr_wsc_mode0;

assign RegWrite=RegWrite0;
assign MemRead=MemRead0;
assign MemWrite=MemWrite0;
assign Branch=Branch0;
assign aui=aui0;
assign Jump=Jump0;
assign ALU_op=ALU_op0;
assign ALUSrc=ALUSrc0;
assign MemtoReg=MemtoReg0;
assign interr=interr0;
assign csr_wsc_mode=csr_wsc_mode0;


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
                interr0=2'b00;
                csr_wsc_mode0=2'b00;
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
                interr0=2'b00;
                csr_wsc_mode0=2'b00;
            end

        7'b0000011://I  ld
            begin
                case(funct3)
                    3'b000:begin
                        ALUSrc0=1;
                        MemtoReg0=2'b01;
                        RegWrite0=1;
                        MemWrite0=2'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;    
                        aui0=0; 
                        interr0=2'b00; 
                        csr_wsc_mode0=2'b00;
                        MemRead0=3'b001;
                    end
                    3'b001:begin
                        ALUSrc0=1;
                        MemtoReg0=2'b01;
                        RegWrite0=1;
                        MemWrite0=2'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;    
                        aui0=0; 
                        interr0=2'b00; 
                        csr_wsc_mode0=2'b00;
                        MemRead0=3'b010;
                    end
                    3'b010:begin
                        ALUSrc0=1;
                        MemtoReg0=2'b01;
                        RegWrite0=1;
                        MemWrite0=2'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;    
                        aui0=0; 
                        interr0=2'b00; 
                        csr_wsc_mode0=2'b00;
                        MemRead0=3'b011;
                    end
                    3'b100:begin
                        ALUSrc0=1;
                        MemtoReg0=2'b01;
                        RegWrite0=1;
                        MemWrite0=2'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;    
                        aui0=0; 
                        interr0=2'b00; 
                        csr_wsc_mode0=2'b00;
                        MemRead0=3'b101;
                    end
                    3'b101:begin
                        ALUSrc0=1;
                        MemtoReg0=2'b01;
                        RegWrite0=1;
                        MemWrite0=2'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;    
                        aui0=0; 
                        interr0=2'b00; 
                        csr_wsc_mode0=2'b00;
                        MemRead0=3'b110;
                    end
                    default:begin
                        ALUSrc0=0;
                        MemtoReg0=2'b00;
                        RegWrite0=0;
                        MemWrite0=2'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;    
                        aui0=0; 
                        interr0=2'b01; 
                        csr_wsc_mode0=2'b00;
                        MemRead0=3'b0;
                    end
                endcase          
            end

        7'b0100011://S sd
            begin
                case(funct3)
                    3'b000:begin
                        ALUSrc0=1;
                        RegWrite0=0;
                        MemRead0=3'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;
                        aui0=0;
                        interr0=2'b00;
                        csr_wsc_mode0=2'b00;
                        MemWrite0=2'b01;
                    end

                    3'b001:begin
                        ALUSrc0=1;
                        RegWrite0=0;
                        MemRead0=3'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;
                        aui0=0;
                        interr0=2'b00;
                        csr_wsc_mode0=2'b00;
                        MemWrite0=2'b10;
                    end

                    3'b010:begin
                        ALUSrc0=1;
                        RegWrite0=0;
                        MemRead0=3'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;
                        aui0=0;
                        interr0=2'b00;
                        csr_wsc_mode0=2'b00;
                        MemWrite0=2'b11;
                    end
                    default:begin
                        ALUSrc0=0;
                        RegWrite0=0;
                        MemRead0=3'b0;
                        Branch0=0;
                        Jump0=2'b00;
                        ALU_op0=2'b00;
                        aui0=0;
                        interr0=2'b01;
                        csr_wsc_mode0=2'b00;
                        MemWrite0=2'b0;
                    end
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
                interr0=2'b00;
                csr_wsc_mode0=2'b00;
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
                interr0=2'b00;
                csr_wsc_mode0=2'b00;
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
                interr0=2'b00;
                csr_wsc_mode0=2'b00;
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
                interr0=2'b00;   
                csr_wsc_mode0=2'b00;       
            end

        7'b0010111://auipc
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
                interr0=2'b00;
                csr_wsc_mode0=2'b00;
            end
        
        7'b1110011:// system call
            begin
                if(funct3==3'b000)begin
                    case(funct12)
                        12'h000: begin
                            ALUSrc0=0;
                            MemtoReg0=2'b00;
                            RegWrite0=0;
                            MemRead0=3'b0;
                            MemWrite0=2'b0;
                            Branch0=0;
                            Jump0=2'b00;
                            ALU_op0=2'b00;
                            aui0=0;
                            interr0=2'b10; // ecall
                            csr_wsc_mode0=2'b00;
                        end
                        12'h302: begin
                            interr0=2'b11; // mret
                            csr_wsc_mode0=2'b00;
                            ALUSrc0=0;
                            MemtoReg0=2'b00;
                            RegWrite0=0;
                            MemRead0=3'b0;
                            MemWrite0=2'b0;
                            Branch0=0;
                            Jump0=2'b00;
                            ALU_op0=2'b00;
                            aui0=0;
                        end
                    endcase
                end

                else begin
                    ALUSrc0=0;
                    MemtoReg0=2'b00;
                    RegWrite0=1;
                    MemRead0=3'b0;
                    MemWrite0=2'b0;
                    Branch0=0;
                    Jump0=2'b00;
                    ALU_op0=2'b00;
                    aui0=0;
                    interr0=2'b00; // csrr
                    case(csr_kind)
                        3'd1, 3'd5: csr_wsc_mode0=2'b01;
                        3'd2, 3'd6: csr_wsc_mode0=2'b10;
                        3'd3, 3'd7: csr_wsc_mode0=2'b11;
                        default: csr_wsc_mode0=2'b00;
                    endcase
                end
            end
        
        default:
            begin
                ALUSrc0=0;
                MemtoReg0=2'b00;
                RegWrite0=0;
                MemRead0=3'b0;
                MemWrite0=2'b0;
                Branch0=0;
                Jump0=2'b00;
                ALU_op0=2'b00;
                aui0=0;
                interr0=2'b01;//illeagal
                csr_wsc_mode0=2'b00;
            end
    endcase
end

endmodule
