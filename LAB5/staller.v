`timescale 1ns / 1ps

module staller(
    input [31:0] IF_ID_inst,

    input [31:0] ID_EX_inst,
    input ID_EX_stall,
    input [31:0] ID_EX_rd1,
    input [31:0] ID_EX_rd2,

    input [31:0] EX_MEM_inst,
    input EX_MEM_stall,

    input [31:0] MEM_WB_inst,

    output stall
);

wire control_hazard,data_hazard;
reg  control_hazard0,data_hazard0,data_hazard1;
assign control_hazard=control_hazard0 & (~ID_EX_stall);
assign data_hazard=(data_hazard0 & (~ID_EX_stall)) | (data_hazard1 & (~EX_MEM_stall));
assign stall = control_hazard | data_hazard;

//control hazard
always@(*)begin
    case(ID_EX_inst[6:0])
        7'b1100011: begin // B
                case (ID_EX_inst[14:12])
                    3'h0: begin
                        if (ID_EX_rd1 == ID_EX_rd2) begin
                            control_hazard0 = 1;
                        end else begin
                            control_hazard0 = 0;
                        end
                    end
                    3'h1: begin
                        if (ID_EX_rd1 != ID_EX_rd2) begin
                            control_hazard0 = 1;
                        end else begin
                            control_hazard0 = 0;
                        end
                    end
                    3'h4: begin
                        if ($signed(ID_EX_rd1) < $signed(ID_EX_rd2)) begin
                            control_hazard0 = 1;
                        end else begin
                            control_hazard0 = 0;
                        end
                    end
                    3'h5: begin
                        if ($signed(ID_EX_rd1) >= $signed(ID_EX_rd2)) begin
                            control_hazard0 = 1;
                        end else begin
                            control_hazard0 = 0;
                        end
                    end
                    3'h6: begin
                        if (ID_EX_rd1 < ID_EX_rd2) begin
                            control_hazard0 = 1;
                        end else begin
                            control_hazard0 = 0;
                        end
                    end
                    3'h7: begin
                        if (ID_EX_rd1 >= ID_EX_rd2) begin
                            control_hazard0 = 1;
                        end else begin
                            control_hazard0 = 0;
                        end
                    end
                endcase
            end
            7'b1101111: begin // jal
                control_hazard0 <= 1;
            end
            7'b1100111: begin // jalr
                control_hazard0 <= 1;
            end
            default: begin
                control_hazard0 <= 0;
            end
    endcase
end

//data hazard
always @(*) begin
    if(IF_ID_inst[19:15]==ID_EX_inst[11:7] | IF_ID_inst[24:20]==ID_EX_inst[11:7])begin
        if(ID_EX_inst[11:7]!=0)begin
            data_hazard0=1;
        end
        else begin
            data_hazard0=0;
        end
    end 
    else begin
        data_hazard0=0;
    end

    if(IF_ID_inst[19:15]==EX_MEM_inst[11:7] | IF_ID_inst[24:20]==EX_MEM_inst[11:7])begin
        if(EX_MEM_inst[11:7]!=0)begin
            data_hazard1=1;
        end
        else begin
            data_hazard1=0;
        end
    end 
    else begin
        data_hazard1=0;
    end
end
endmodule
