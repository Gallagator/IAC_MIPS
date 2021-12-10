`include "package.v"

module alu_ctrl(
    input logic[5:0] opcode,
    input logic[5:0] rtype_fncode,
    output logic[5:0] fncode   
);
    always_comb begin

        case(opcode)        
            OPCODE_ADDIU :
                fncode = FUNCT_ADDU;
            OPCODE_SW :
                fncode = FUNCT_ADDU;
            OPCODE_LW :
                fncode = FUNCT_ADDU;
            OPCODE_LBU : 
                fncode = FUNCT_ADDU;
            OPCODE_LB : 
                fncode = FUNCT_ADDU;
            OPCODE_ANDI :
                fncode = FUNCT_AND;
            OPCODE_ORI  :
                fncode = FUNCT_OR;
            OPCODE_XORI  :
                fncode = FUNCT_XOR;
            OPCODE_RTYPE:
                fncode = rtype_fncode;
            default:
                fncode = 6'b11_1111; 
        endcase
    end
    

endmodule
