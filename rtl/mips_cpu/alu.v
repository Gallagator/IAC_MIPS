module alu(
    input logic[31:0] a,
    input logic[31:0] b,
    input funct_t fncode,
    output logic[31:0] r
);
    always_comb begin
        case(fncode) 
            FUNCT_ADDU : r = a + b;
            FUNCT_ADDIU : r = a + b;
            default : r = 0;
        endcase
    end
endmodule
