`timescale 1ns / 1ps

module cache(
    input clk,
    input rst,

    input [127:0] from_mem_data,//data from memory
    input [31:0] from_cpu_data,//data from cpu
    input [31:0] addr,//address from memory
    input [1:0] request,//0:read, 1:write, 2\3:invalidate
    input ready_mem,//memory is ready

    output reg [127:0] to_mem_data,//data to memory
    output reg [31:0] to_cpu_data,//data to cpu
    output reg Mem_request,//memory request when miss,0 for read, 1 for write
    output reg finish //finish the request

    );

//FSM
//00:Idle ; 01:Compare Tag ; 10:Write Allocate ; 11:Write Back
reg [1:0] state;


//index bits = log2(128)=7
wire [6:0] index=addr[8:2];

//word offset bits = log2(4)=2
wire [1:0] word_offset=addr[1:0];

//tag bits =32(address bits)-2(word offset)-7(index bits)=23
wire [22:0] tag=addr[31:9];

//there are 128 cache regs and each has 2 ways
//each way has 154 bits( 3 bits for UDV ,23 bits for tag,128 bits for data)
reg [153:0] cache[127:0][1:0];

always @(posedge clk or posedge rst) begin
    if(rst) begin
        state<=2'b00;
    end
    else begin
        case(state)
            2'b00:begin//Idle
                finish<=0;//not finish
                Mem_request<=0;//no memory request

                if(request==2'b00 || request==2'b01) begin
                    state<=2'b01;//compare tag
                end 
                else begin 
                    state<=2'b00;//idle
                end
            end


            2'b01:begin//Compare Tag
                //hit:go to idle
                //first way
                if(cache[index][0][153] && cache[index][0][150:128]==tag) begin
                    if(request==2'b00) begin//read
                        to_cpu_data<=cache[index][0][(word_offset*32)+:32];//read data from cache
                        state<=2'b00;//idle
                        finish<=1;//finish
                    end

                    if(request==2'b01) begin//write
                        cache[index][0][(word_offset*32)+:32]<=from_cpu_data;//write data to cache
                        cache[index][0][152]<=1'b1;//set dirty bit
                        cache[index][0][151]<=1'b1;//set valid bit
                        state<=2'b00;//idle
                        finish<=1;//finish
                    end
                end
                //second way
                else if(cache[index][1][153] && cache[index][1][150:128]==tag) begin
                    if(request==2'b00) begin//read
                        to_cpu_data<=cache[index][1][(word_offset*32)+:32];//read data from cache
                        state<=2'b00;//idle
                        finish<=1;//finish
                    end

                    if(request==2'b01) begin//write
                        cache[index][1][(word_offset*32)+:32]<=from_cpu_data;//write data to cache
                        cache[index][1][152]<=1'b1;//set dirty bit
                        cache[index][1][151]<=1'b1;//set valid bit
                        state<=2'b00;//idle
                        finish<=1;//finish
                    end
                end

                //miss
                //clean:write allocate
                else if(cache[index][0][152]==0 && cache[index][1][152]==0) begin
                  state<=2'b10;//write allocate
                  Mem_request<=0;//read
                end
                //dirty:write back
                else begin
                  state<=2'b11;//write back
                  Mem_request<=1;//write
                end               
            end


            2'b10:begin//Write Allocate
                //if the memory isn't ready, wait
                if(!ready_mem) state<=2'b10;

                //if the memory is ready, allocate new cache line
                else begin
                    //LRU strategy
                    //cache[index][i][151]: 0=least used, 1=recently used
                    if(cache[index][0][151]) begin
                        //cahche[index][0] is recently used,so replace cache[index][1]
                        cache[index][0][151]<=1'b0;//mark it as least used
                        cache[index][1][151]<=1'b1;//mark it as recently used
                        cache[index][1][153]<=1'b1;//valid
                        cache[index][1][152]<=1'b0;//clean
                        cache[index][1][150:128]<=tag;//update tag
                        cache[index][1][127:0]<=from_mem_data;//update data
                        state<=2'b01;//compare tag
                    end

                    else begin
                        //cahche[index][1] is recently used,so replace cache[index][0]
                        cache[index][1][151]<=1'b0;//mark it as least used
                        cache[index][0][151]<=1'b1;//mark it as recently used
                        cache[index][0][153]<=1'b1;//valid
                        cache[index][0][152]<=1'b0;//clean
                        cache[index][0][150:128]<=tag;//update tag
                        cache[index][0][127:0]<=from_mem_data;//update data
                        state<=2'b01;//compare tag
                    end
                end
            end

            2'b11:begin//Write Back
                //if the memory isn't ready, wait
                if(!ready_mem) state<=2'b11;

                //if the memory is ready, write back
                else begin
                    Mem_request<=1;//write
                    state<=2'b10;//write allocate
                    if(cache[index][0][152]) begin
                        to_mem_data<=cache[index][0][127:0];//write back data
                        cache[index][0][152]<=0;//reset dirty bit
                    end
                    else begin
                        to_mem_data<=cache[index][1][127:0];//write back data
                        cache[index][1][152]<=0;//reset dirty bit
                    end
                end

            end
        endcase

end
    
end

endmodule
