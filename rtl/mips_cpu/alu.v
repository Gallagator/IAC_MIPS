`include "package.v"

module alu(
    input logic[31:0] a,
    input logic[31:0] b,
    input funct_t fncode,
    output logic[31:0] r
);

    always_comb begin
        case(fncode) 
            FUNCT_ADDU : r = a + b;
            FUNCT_AND  : r = a & b;
            FUNCT_OR   : r = a | b;
            FUNCT_XOR  : r = a ^ b;
            FUNCT_SUBU : r = a - b;
            FUNCT_SLL  : r = b << a;
            FUNCT_SLLV : r = b << a;
            FUNCT_SRL  : r = b >> a;
            FUNCT_SRLV : r = b >> a;
            FUNCT_SRA  : r = b >>> a;
            FUNCT_SRAV : r = b >>> a;
            default : r = 0;
        endcase
    end


endmodule
