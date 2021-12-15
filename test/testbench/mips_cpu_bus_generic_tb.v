module mips_cpu_bus_generic_tb();
    parameter RAM_INIT_FILE = "";
    parameter EXPECTED_REG_V0 = -1213;
    parameter TIMEOUT_CYCLES = 50_000;
    parameter MAX_WAIT_REQUEST_CYCLES = 1;  // All testcases pass when it is 4 or bigger.
    
    logic clk;
    logic reset;

    /* Mips ports */
    logic active;
    logic[31:0] register_v0;
   
    logic[31:0] address;
    logic[31:0] prev_address;

    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    logic[11:0] RAM_addr;
    /* program RAM ports */
    logic prog_read;
    logic prog_write;
    logic[31:0] prog_read_data;
   
    /* Stack RAM ports */
    logic stack_read;
    logic stack_write;
    logic[31:0] stack_read_data;

    int waitrequest_cycles;

    initial begin
        waitrequest_cycles = $urandom % MAX_WAIT_REQUEST_CYCLES + 1;

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
        repeat(TIMEOUT_CYCLES) begin
            if(waitrequest_cycles == 0) begin
                waitrequest = 0;
                waitrequest_cycles = $urandom % MAX_WAIT_REQUEST_CYCLES + 1;
            end
            else begin
                waitrequest = 1;
            end

            #5;
            clk = !clk;
            #5;
            clk = !clk;
            waitrequest_cycles -= 1;
        end    
        $display("output: %d", register_v0);
        $fatal(2, "Simulation timeout");
    end


    initial begin

        @(negedge reset);
        @(posedge clk);
        while(active) begin
            @(posedge clk);
        end

        $display("output: %d", register_v0);
        if(register_v0 != EXPECTED_REG_V0) begin
            $fatal(2, "Expected %d for reg_v0, got: %d ", EXPECTED_REG_V0, register_v0);
        end
        $finish;
    end

    assign RAM_addr = address[13:2];

    always_comb begin

        // Is the address in the stack region.        
        if(prev_address < (4096 << 2)) begin
            stack_read = read;
            stack_write = write;
            readdata = stack_read_data;
        end
        else begin
            stack_read = 0;
            stack_write = 0;
        end

        // Is the address in the program region.
        if(prev_address >= 32'hBFC0_0000 && 
           prev_address < (32'hBFC0_0000 + (4096 << 2)) ) begin
            prog_read = read;
            prog_write = write;
            readdata = prog_read_data;
        end 
        else begin
            prog_read = 0;
            prog_write = 0;
        end

    end

    always_ff @(posedge clk) begin
        prev_address <= address; 
    end

    /* Addresses BASE_ADDRESS:BASE_ADDRESS+4095*/
    RAM_32x4096 #(RAM_INIT_FILE) program_region(
        .clk(clk),
        .address(RAM_addr),
        .read(prog_read),
        .write(prog_write),
        .byteenable(byteenable),
        .writedata(writedata),
        .readdata(prog_read_data)
    );
    /* Addresses 0:4095 */
    RAM_32x4096 stack_region(
        .clk(clk),
        .address(RAM_addr),
        .read(stack_read),
        .write(stack_write),
        .byteenable(byteenable),
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
