module RAM_32x4096(
    input logic clk,
    input logic[11:0] address,
    input logic write,
    input logic read,
    input logic[31:0] writedata,
    output logic[31:0] readdata
);
    parameter RAM_INIT_FILE = "";

    logic[31:0] memory [4095:0];

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

    /* Synchronous write path */
    always @(posedge clk) begin
        $display("RAM write ", write);
        if (write) begin
            memory[address] <= writedata;
        end
        readdata <= memory[address]; // Read-after-write mode
    end
endmodule
