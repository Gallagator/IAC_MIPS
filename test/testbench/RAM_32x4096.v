module RAM_32x4096(
    input logic clk,
    input logic[11:0] address,
    input logic write,
    input logic read,
    input logic print_mem,
    input logic[31:0] writedata,
    output logic[31:0] readdata
);
    parameter RAM_INIT_FILE = "";

    logic[31:0] memory [4095:0];
    integer k;

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
        // $display("RAM write: %x,    writedata: %x", write, writedata);  // This statement is printed 4 times in the EXEC state, because we have 2 RAMs.
        if (write) begin
            $display("RAM           write: %x,    writedata: %x,    address: %x", write, writedata, address);
            //$display("memory[%d] will be equal to %d", address, writedata);
            memory[address] = writedata;    // Had to change from non-blocking to blocking assignment.
            $display("RAM           Mem[%x] = %x", address, memory[address]);
        end
        if(read == 1) begin
            $display("RAM       mem[%x]: readdata = %x", address, memory[address]);
        end

        readdata = memory[address]; // Read-after-write mode
    end

    always @(print_mem) begin
        for(k = 0; k < 4096; k++) begin
            $display("RAM: k: %x,   value: %x", k, memory[k]);
        end

    end

endmodule
