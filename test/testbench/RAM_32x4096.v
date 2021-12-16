
module RAM_32x4096(
    input logic clk,
    input logic[11:0] address,
    input logic write,
    input logic[3:0] byteenable,
    input logic read,
    input logic[31:0] writedata,
    output logic[31:0] readdata
);
    parameter RAM_INIT_FILE = "";

    logic[31:0] memory [4095:0];

    logic[31:0] masked_writedata;
    logic[31:0] mask;

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<4096; i++) begin
            memory[i]=0;
        end
        $display("init file: %s", RAM_INIT_FILE);
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $readmemh(RAM_INIT_FILE, memory, 0, 4095);
        end
    end
        // Little endian mask
    assign mask = {
        byteenable[0] ? 8'hFF : 8'h00,
        byteenable[1] ? 8'hFF : 8'h00,
        byteenable[2] ? 8'hFF : 8'h00,
        byteenable[3] ? 8'hFF : 8'h00
    };

    assign  masked_writedata = 
        (writedata & mask) | (memory[address] & (~mask));

    /* Synchronous write path */
    always_ff @(posedge clk) begin
        if (write) begin
            memory[address] <= masked_writedata;
        end
        if(read) begin
            readdata <= memory[address]; // Read-after-write mode
        end
        /* Why do we not use if(read). If we were to use this most of the memory instructions don't work.*/
    end

endmodule
