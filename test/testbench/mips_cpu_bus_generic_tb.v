module mips_cpu_bus_generic_tb();
    parameter RAM_INIT_FILE = "";
    parameter EXPECTED_REG_V0 = -1213;
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
    logic debug_flag;
    //logic print_mem_tb;
    integer counter;
    initial begin
        //print_mem_tb = 0;
        //counter = 0;
        reset = 0;
        clk = 0;
        #5;
        reset = 1;
        clk = 1;
        #5;
        clk = 0;
        #5;
        clk = 1;
        reset = 0;
        repeat(TIMEOUT_CYCLES) begin
            #5;
            clk = 0;
            #5;
            clk = 1;
            //counter = counter + 1;
            //$display("Counter: %d", counter);
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
        if(register_v0 != EXPECTED_REG_V0) begin
            $fatal(2, "Expected %d for reg_v0, got: %d ", EXPECTED_REG_V0, register_v0);
        end
        //print_mem_tb = 1;
        $finish;
    end

    assign stack_addr = address[11:0];  // Had to change this, because otherwise it was dividing the address by 4 and rounding down.
    assign prog_addr = address[13:2];

    always_comb begin

        // Is the address in the stack region.        
        if(address < (4096)) begin  // Had to change this because we are not dividing by 4 anymore.
            stack_read = read;
            stack_write = write;
            readdata = stack_read_data;
            debug_flag = 0;
        end
        else begin
            debug_flag = 1;
            stack_read = 0;
            stack_write = 0;
            //readdata = 0;
        end

        // Is the address in the program region.
        if(address >= 32'hBFC0_0000 && 
           address < (32'hBFC0_0000 + (4096 << 2)) ) begin
            prog_read = read;
            prog_write = write;
            readdata = prog_read_data;
        end 
        else begin
            prog_read = 0;  // Changed this from stack_read to prog_read.
            prog_write = 0; // Same for prog_write.
            //readdata = 0;   // When we are doing load, this would be executed after we have gotten the readdata from Stack_RAM meaning that we would not be able to read from Stack_RAM.
        end

    end

    always @(readdata) begin // Debugging purposes.
        //$display("Testbench:    debug_flag: %x", debug_flag);
        
        $display("Testbench:    address: %x,    RAM stack_readdata: %x,     RAM readdata: %x", address, stack_read_data, readdata);


    end

    /* Addresses BASE_ADDRESS:BASE_ADDRESS+4095*/
    RAM_32x4096 #(RAM_INIT_FILE) program_region(
        .clk(clk),
        .address(prog_addr),
        .read(prog_read),
        .write(prog_write),
        .writedata(writedata),
        .readdata(prog_read_data)//,
        //.print_mem(1'b0)
    );
    /* Addresses 0:4095 */
    RAM_32x4096 stack_region(
        .clk(clk),
        .address(stack_addr),
        .read(stack_read),
        .write(stack_write),
        .writedata(writedata),
        .readdata(stack_read_data)//,
        //.print_mem(print_mem_tb)
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
