// Fetch, Decode, execute, memory_access, WB

module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);
    logic[31: 0] pc;
    
    reg_file reg_file(.clk(clk), 
                      .reset(reset), 
                      .addr_a(),
                      .addr_b(),
                      .write_addr(),
                      .write(),
                      .data_in(),
                      .a(),
                      .b()
    ); 

    typedef enum logic[5:0] {
        OPCODE_RTYPE = 6'd0
    } opcode_t;

    typedef enum logic[2:0] {
        STATE_FETCH,
        STATE_DECODE,
        STATE_EXECUTE,
        STATE_MEMORY,
        STATE_WRITEBACK
    } state_t;

    always_ff @(posedge clk) begin
        if(reset) begin
            pc <= 32'hBFC0_0000;
        end
        else begin

        end
    end

    
endmodule
