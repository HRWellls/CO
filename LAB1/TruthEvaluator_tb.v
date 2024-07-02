`timescale 1ns / 1ps
module TruthEvaluator_tb;
    reg clk;
    reg in;
    wire out;
TruthEvaluator m0(
    .clk(clk),
    .in(in),
    .out(out)
);
always #10 clk=~clk;
initial begin
    clk=0;
    in=0;
    #100;

    in=1;
    #100;

    in=0;
    #100;

    in=1;
    #100;

    $stop;
end
endmodule
