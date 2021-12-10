`ifndef PACKAGE_P
`define PACKAGE_P


typedef enum logic[5:0] {
    FUNCT_ADDU = 6'b10_0001,
    FUNCT_JR   = 6'b00_1000,
    FUNCT_AND  = 6'b10_0100,
    FUNCT_OR   = 6'b10_0101,
    FUNCT_XOR  = 6'b10_0110,
    FUNCT_SUBU = 6'b10_0011
} funct_t;

typedef enum logic[1:0] {    /*3 bits for this?*/
    STATE_FETCH = 0,
    STATE_EXECUTE = 1,
    STATE_MEMORY = 2,
    STATE_WRITEBACK = 3
} state_t;

typedef enum logic[5:0] {
    OPCODE_RTYPE    = 6'b00_0000,
    OPCODE_JAL      = 6'b00_0011,
    OPCODE_J        = 6'b00_0010,
    OPCODE_ADDIU    = 6'b00_1001,
    OPCODE_LW       = 6'b10_0011,
    OPCODE_SW       = 6'b10_1011,
    OPCODE_ANDI     = 6'b00_1100,
    OPCODE_ORI      = 6'b00_1101,
    OPCODE_XORI     = 6'b00_1110,
    OPCODE_LBU      = 6'b10_0100,
    OPCODE_LB       = 6'b10_0000
} opcode_t;
    
typedef enum logic[1:0] {
    RTYPE,
    ITYPE,
    JTYPE
} instr_type_t;

`endif
