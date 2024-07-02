`timescale 1ns / 1ps
module mux_sim;
 reg [15:0] SW;
 wire [3:0] LED;
mux  mux1(
    .SW(SW),
    .LED(LED)
);
    
initial begin
    // Initialize Inputs
    SW = 0;
    // Wait 100 ns for global reset to finish
    #100;
      
    // Add stimulus here
    SW = 16'b0000000000001011; // SW[15:14]=00, expecting LED to show SW[3:0]
    #100; 
    SW = 16'b0100000011110000; // SW[15:14]=01, expecting LED to show SW[7:4]
    #100;   
    SW = 16'b1000_1110_1010_1010; // SW[15:14]=10, expecting LED to show SW[11:8]
    #100;  
    SW = 16'b1100_1111_1111_1111; // SW[15:14]=11, expecting LED to show 0000
    #100;   
    // Complete the simulation
    $finish;
end

endmodule