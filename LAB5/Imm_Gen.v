`timescale 1ns / 1ps

module Imm_Gen(
    input [31:0] instruction,
    output [31:0] imm
    );

reg [31:0] imm0;
assign imm=imm0;

always @(*) begin
    case(instruction[6:0])

        7'b0010011://I type
            begin
                if(instruction[14:12] == 3'd1 || instruction[14:12] == 3'd5)begin
                    imm0[31:5]={27{instruction[31]}};
                    imm0[4:0]=instruction[24:20];
                end
                else begin
                    imm0[31:12]={20{instruction[31]}};
                    imm0[11:0]=instruction[31:20];
                end
            end

        7'b0000011,7'b1100111://I type
            begin
                imm0[31:12]={20{instruction[31]}};
                imm0[11:0]=instruction[31:20];
            end
        
        7'b0100011://S type
            begin
                imm0[31:12]={20{instruction[31]}};
                imm0[11:5]=instruction[31:25];
                imm0[4:0]=instruction[11:7];
            end

        7'b1100011://B type
            begin
                imm0[31:13]={19{instruction[31]}};
                imm0[12]=instruction[31];
                imm0[10:5]=instruction[30:25];
                imm0[4:1]=instruction[11:8];
                imm0[11]=instruction[7];
                imm0[0]=1'b0;
            end

        7'b1101111://J type
            begin
                imm0[20]=instruction[31];
                imm0[10:1]=instruction[30:21];
                imm0[11]=instruction[20];
                imm0[19:12]=instruction[19:12];
                imm0[31:21]={11{instruction[31]}};
                imm0[0]=1'b0;
            end

        7'b0110111,7'b0010111:
            begin
                imm0[31:12]=instruction[31:12];
                imm0[11:0]=12'b0000_0000_0000;
            end

    endcase

end
endmodule
