module lo_hi_reg(
    input logic clk,
    input logic reset,
    input logic addr_r,
    input logic write,
    input logic data_in,
    output logic[31:0] r
);
    logic[31:0] hi, lo;

    always_comb begin
        if(!write && !reset) begin
            r = addr_r? hi : lo;
        end
    end
    
    always_ff @(posedge clk) begin
        if(reset) begin
            lo <= 32'b0;
            hi <= 32'b0;
        end
        else if(!reset && write) begin
            if(addr_r) begin
            hi <= data_in;
            end
            else begin
            lo <= data_in;
            end
        end
    end
endmodule