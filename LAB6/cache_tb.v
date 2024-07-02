`timescale 1ns / 1ps

module cache_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [127:0] from_mem_data;
    reg [31:0] from_cpu_data;
    reg [31:0] addr;
    reg [1:0] request;
    reg ready_mem;

    // Outputs
    wire [127:0] to_mem_data;
    wire [31:0] to_cpu_data;
    wire Mem_request;
    wire finish;

    // Instantiate the Unit Under Test (UUT)
    cache uut (
        .clk(clk),
        .rst(rst),
        .from_mem_data(from_mem_data),
        .from_cpu_data(from_cpu_data),
        .addr(addr),
        .request(request),
        .ready_mem(ready_mem),
        .to_mem_data(to_mem_data),
        .to_cpu_data(to_cpu_data),
        .Mem_request(Mem_request),
        .finish(finish)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        rst = 1;
        from_mem_data = 0;
        from_cpu_data = 0;
        addr = 0;
        request = 0;
        ready_mem = 0;

        // Apply reset
        #10;
        rst = 0;

        // Test case 1: Read miss -> Allocate
        addr = 32'h00000004;
        request = 2'b00; // Read request

        // Wait for a few clock cycles to observe the behavior
        #20;
        ready_mem = 1;
        from_mem_data = 128'hAABBCCDDEEFF00112233445566778899; // Simulated memory data

        // Wait for the cache to process the memory data
        #20;
        ready_mem = 0;

        // Test case 2: Write miss -> Write Allocate
        addr = 32'h00000010;
        request = 2'b01; // Write request
        from_cpu_data = 32'hCAFEBABE; // Data to write

        // Wait for a few clock cycles to observe the behavior
        #20;
        ready_mem = 1;
        from_mem_data = 128'h00112233445566778899AABBCCDDEEFF; // Simulated memory data for allocation

        // Wait for the cache to process the memory data
        #20;
        ready_mem = 0;

        // Test case 3: Read hit
        addr = 32'h00000004;
        request = 2'b00; // Read request

        // Wait for a few clock cycles to observe the behavior
        #20;

        // Test case 4: Write hit
        addr = 32'h00000004;
        request = 2'b01; // Write request
        from_cpu_data = 32'hDEADBEEF; // Data to write

        // Wait for a few clock cycles to observe the behavior
        #20;

        // Test case 5: Invalidate
        request = 2'b10; // Invalidate request

        // Wait for a few clock cycles to observe the behavior
        #20;

        // End of test
        $stop;
    end

endmodule
