typedef enum logic[5:0] {
    FUNCT_ADDU = 6'b10_0001
} funct_t;

module alu(
    input logic[31:0] a,
    input logic[31:0] b,
    input funct_t fncode,
    output logic[31:0] r
);
    always_comb begin
        case(fncode) 
            FUNCT_ADDU : r = a + 80085;
            default : r = 0;
        endcase
    end
endmodule
