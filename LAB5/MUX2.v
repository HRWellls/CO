`timescale 1ns / 1ps

module MUX2(
    input [1:0] Jump,
    input [31:0] from_pc_branch,
    input [31:0] from_jal,
    input [31:0] from_jalr,

    output [31:0] next_pc
    );

reg [31:0] temp;
assign next_pc=temp;

// reg [1:0] jump_reg;

// initial begin
//     jump_reg=2'b00;
// end

// always @(Jump)begin
//     jump_reg=Jump;
// end

    always @(*)begin
        case(Jump)
            2'd0:temp=from_pc_branch;
            2'd1:temp=from_jal;
            2'd2:temp=from_jalr;
        endcase
    end

endmodule
