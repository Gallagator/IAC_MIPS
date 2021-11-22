
module reg_file(
    input logic clk,
    input logic reset,
    input logic[4:0] addr_a,
    input logic[4:0] addr_b,
    input logic[4:0] write_addr,
    input logic write,
    input logic[31:0] data_in,
    output logic [31:0] a,
    output logic [31:0] b
);
    logic[31: 0] regs[31];
    integer i; 

    /* Select registers combinatorially */
    always_comb begin
        a = addr_a == 0 ? 0 : regs[addr_a - 1];
        b = addr_b == 0 ? 0 : regs[addr_b - 1];
    end 

    /* Reset registers to 0 */
    always_ff @(posedge clk) begin
        if(reset) begin
            for(i = 0; i < 31; i += 1) begin
                regs[i] <= 0;
            end
        end 
    end

    /* Write to register on negative edge */
    always_ff @(negedge clk) begin
        if(!reset && write && write_addr != 0) begin
            regs[write_addr - 1] <= data_in;
        end 
    end

endmodule
