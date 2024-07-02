`timescale 1ns / 1ps

module TruthEvaluator(
    input clk,
    input in,
    output out
);

//4 states need 2 bits
reg [1:0] curr_state ;
reg [1:0] next_state ;

// State definition
  localparam 
    Q1 = 2'b00,
    Q2 = 2'b01,
    Q3 = 2'b10,
    Q4 = 2'b11;
    //4 states
    initial begin
        curr_state = Q1;
        next_state = Q1;
    end

// First segment: state transfer
  always @(posedge clk) begin
        curr_state <= next_state ;
  end

// Sencond segment: transfer condition
    always @(*) begin
        case(curr_state)
            Q1: next_state = (in == 1'b0) ? Q2 : Q1;
            Q2: next_state = (in == 1'b0) ? Q3 : Q1;
            Q3: next_state = (in == 1'b0) ? Q4 : Q2;
            Q4: next_state = (in == 1'b0) ? Q4 : Q3;
            default: next_state = Q1;
        endcase
    end

// Third segment: output
  assign out = (Q1 == curr_state) || (Q2 == curr_state);
endmodule