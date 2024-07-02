`timescale 1ns / 1ps

module mux (//
    input wire [15:0] SW,
    output reg [3:0] LED
);

always @(SW) begin
    case (SW[15:14])//根据SW[15:14]的不同取值决定选择MUX的哪项功能
        2'b00: LED <= SW[3:0];
        2'b01: LED <= SW[7:4];
        2'b10: LED <= SW[11:8];
        2'b11: LED <= 4'b0000;//取0
        default: LED <= 4'b0000; // Default case for safety
    endcase
end

endmodule