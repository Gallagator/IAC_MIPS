`ifndef PACKAGE_V
`define PACKAGE_V


typedef enum logic[5:0] {
    FUNCT_ADDU  = 6'b10_0001,
    FUNCT_JR    = 6'b00_1000,
    FUNCT_AND   = 6'b10_0100,
    FUNCT_OR    = 6'b10_0101,
    FUNCT_XOR   = 6'b10_0110,
    FUNCT_SUBU  = 6'b10_0011,
    FUNCT_SLL   = 6'b00_0000,
    FUNCT_SLLV  = 6'b00_0100,
    FUNCT_SRL   = 6'b00_0010,
    FUNCT_SRLV  = 6'b00_0110,
    FUNCT_SRA   = 6'b00_0011,
    FUNCT_SRAV  = 6'b00_0111,
    FUNCT_SLT   = 6'b10_1010,
    FUNCT_SLTU  = 6'b10_1011
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
    OPCODE_SLTI     = 6'b00_1010,
    OPCODE_SLTIU    = 6'b00_1011,
    OPCODE_LBU      = 6'b10_0100,
    OPCODE_LB       = 6'b10_0000,
    OPCODE_LHU      = 6'b10_0101,
    OPCODE_LH       = 6'b10_0001,
    OPCODE_LUI      = 6'b00_1111,
    OPCODE_LWL      = 6'b10_0010,
    OPCODE_LWR      = 6'b10_0110
} opcode_t;
    
typedef enum logic[1:0] {
    RTYPE,
    ITYPE,
    JTYPE
} instr_type_t;

typedef enum logic {
    BRANCH_NONE,
    BRANCH_DELAYED
} branch_delay_state_t;
 
`endif

