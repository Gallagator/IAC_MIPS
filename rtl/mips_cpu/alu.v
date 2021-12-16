module alu(
    input logic[31:0] a,
    input logic[31:0] b,
    input funct_t fncode,
    output logic[31:0] r,
    output logic[31:0] o
);
    logic msb_a, msb_b;
    assign msb_a = a[31];
    assign msb_b = b[31];
    logic[63:0] tmp;
    logic[31:0] tmplo, tmphi, a_abs, b_abs;

    assign a_abs = msb_a ? -a : a;
    assign b_abs = msb_b ? -b : b;
    assign tmplo = tmp[31:0];
    assign tmphi = tmp[63:32];

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
            FUNCT_SRA  : r = $signed(b) >>> a;
            FUNCT_SRAV : r = $signed(b) >>> a;
            FUNCT_SLTU : r = a < b ? 1 : 0;
            FUNCT_SLT  : r = $signed(a) < $signed(b) ? 1 : 0;
            FUNCT_MULT : begin
                tmp = (msb_a ^ msb_b) ? -(a_abs * b_abs) : a_abs * b_abs;
                r = tmplo;
                o = tmphi;
            end
            FUNCT_MULTU : begin
                tmp = a * b;
                r = tmplo;
                o = tmphi;
            end
            FUNCT_DIV  : begin
                r = (msb_a ^ msb_b) ? -(a_abs / b_abs) : a_abs / b_abs;
                o = msb_a ? -(a_abs % b_abs) : a_abs % b_abs;
            end
            FUNCT_DIVU  : begin
                r = a / b;
                o = a % b;
            end 
            default : begin 
                r = 0;
                o = 0;
            end
        endcase
        
    end


endmodule

