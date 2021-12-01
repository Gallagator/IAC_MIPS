module mips_cpu_bus_generic_tb();
    parameter RAM_INIT_FILE = "";
    parameter TIMEOUT_CYCLES = 50_000;

    logic clk;
    logic reset;

    /* Mips ports */
    logic active;
    logic[31:0] register_v0;
   
    /* TODO SUPPLY READDATA IN LITTLE ENDIAN */ 
    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable; // Need to consider this later.
    logic[31:0] readdata;

    /* program RAM ports */
    logic[11:0] prog_addr;
    logic prog_read;
    logic prog_write;
    logic[31:0] prog_read_data;
   
    /* Stack RAM ports */
    logic[11:0] stack_addr;
    logic stack_read;
    logic stack_write;
    logic[31:0] stack_read_data;

    initial begin
        reset = 0;
        clk = 0;
        #5;
        reset = 1;
        clk = !clk;
        #5;
        clk = !clk;
        #5;
        clk = !clk;
        reset = 0;
        repeat(5) begin
            #5;
            clk = !clk;
            #5;
            clk = !clk;
        end    
        $display("output: %d", register_v0);
        $fatal(2, "Simulation timeout");
    end


    initial begin
        waitrequest = 0; // TODO make this periodic signal 

        @(negedge reset);
        @(posedge clk);
        while(active) begin
            @(posedge clk);
        end

        $display("output: %d", register_v0);
        $finish;
    end

    assign stack_addr = address[13:2];
    assign prog_addr = address[13:2];

    always_comb begin

        // Is the address in the stack region.        
        if(address < (4096 << 2)) begin
            stack_read = read;
            stack_write = write;
            readdata = stack_read_data;
        end
        else begin
            stack_read = 0;
            stack_write = 0;
            readdata = 0;
        end

        // Is the address in the program region.
        if(address >= 32'hBFC0_0000 && 
           address < (32'hBFC0_0000 + (4096 << 2)) ) begin
            prog_read = read;
            prog_write = write;
            readdata = prog_read_data;
        end 
        else begin
            stack_read = 0;
            stack_write = 0;
            readdata = 0;
        end

    end

    /* Addresses BASE_ADDRESS:BASE_ADDRESS+4095*/
    RAM_32x4096 #(RAM_INIT_FILE) program_region(
        .clk(clk),
        .address(prog_addr),
        .read(prog_read),
        .write(prog_write),
        .writedata(writedata),
        .readdata(prog_read_data)
    );
    /* Addresses 0:4095 */
    RAM_32x4096 stack_region(
        .clk(clk),
        .address(stack_addr),
        .read(stack_read),
        .write(stack_write),
        .writedata(writedata),
        .readdata(stack_read_data)
    );  

    mips_cpu_bus mips(.clk(clk), 
                 .reset(reset), 
                 .active(active),
                 .register_v0(register_v0),

                 .address(address),
                 .write(write),
                 .read(read),
                 .waitrequest(waitrequest),
                 .writedata(writedata),
                 .byteenable(byteenable),
                 .readdata(readdata) 
    );
endmodule
