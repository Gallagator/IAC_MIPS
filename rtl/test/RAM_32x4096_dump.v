module ram_dump();
    parameter RAM_INIT_FILE = "Oh_dear";
    
    int i;
    logic[31:0] readdata;
    logic clk;
    initial begin
        $display("init file: %s", RAM_INIT_FILE);
        clk = 0;
        for(i = 0; i < 10; i++) begin
            #1;
            clk = 1;
            #1;
            clk = 0;
            $display("RAM[%x] = %x", i, readdata);
        end
    end

    RAM_32x4096 #(RAM_INIT_FILE) dut(.clk(clk), 
                    .address(i[11:0]),
                    .write(1'b0), 
                    .read(1'b1),
                    .writedata(32'b0),
                    .readdata(readdata));

endmodule
