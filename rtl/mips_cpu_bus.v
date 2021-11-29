// i1 <---- ir
// i2 <---- ir_next
// i3
// Fetch, Decode, execute, memory_access, WB

typedef enum logic[5:0] {
    FUNCT_ADDU = 6'b10_0001
} funct_t;

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
    typedef enum logic[2:0] {
        STATE_FETCH,
        STATE_EXECUTE,
        STATE_MEMORY,
        STATE_WRITEBACK
    } state_t;

    typedef enum logic[5:0] {
        OPCODE_RTYPE = 6'b00_0000,
        OPCODE_JAL   = 6'b00_0011,
        OPCODE_J     = 6'b00_0010
    } opcode_t;
    
    typedef struct packed {
        logic[5:0] opcode;
        logic[4:0] rs;
        logic[4:0] rt;
        logic[4:0] rd;
        logic[4:0] shamnt;
        logic[5:0] fncode;
    } rtype_t;
    
    typedef struct packed {
        logic[5:0] opcode;
        logic[4:0] rs;
        logic[4:0] rt;
        logic[15:0] immediate;
    } itype_t;
    
    typedef struct packed {
        logic[5:0] opcode;
        logic[25:0] address;
    } jtype_t;
    
    typedef enum logic[1:0] {
        RTYPE,
        ITYPE,
        JTYPE
    } instr_type_t;

    /* Represents an instruction selected by instr_type */    
    typedef struct packed{
        instr_type_t instr_type;
        union packed{
            rtype_t rtype;     
            itype_t itype;     
            jtype_t jtype;     
        } instruction;
    } instruction_t;

    /* Program Counter, instruction register, state */
    logic[31: 0] pc/*, pc_next*/;
    /* TODO REMEMBER TO SET IR_NEXT, AND EFFECTIVE_IR TO THE CORRECT INSTR! */ 
    logic[31: 0] ir/*, ir_next */, effective_ir;
    logic[5:0] opcode;
    instruction_t instr;
    state_t state;

    /* Register file outputs */  
    logic[31:0] rs_val, rt_val;

    logic reg_file_write;
    logic[31:0] reg_file_data_in;
    logic[4:0] reg_file_rs;
    logic[4:0] reg_file_rt;
    logic[4:0] reg_file_rd;


    logic[31:0] alu_out;
    logic[5:0] fncode;

    always_comb begin
        
        /* To be assigned more carefully: */
        write = 0;
        writedata = 0;
        byteenable = 0;

        /* Set active signal */
        active = pc != 0;
        /* Decoding */
        /* Grabs the instruction that has just been fetched. */
        effective_ir = state == STATE_EXECUTE ? readdata : ir;

        opcode = effective_ir[31:26];
        if(opcode == OPCODE_RTYPE) begin 
            instr.instr_type = RTYPE;
            instr.instruction.rtype.opcode = opcode;
            instr.instruction.rtype.rs = effective_ir[25:21];
            instr.instruction.rtype.rt = effective_ir[20:16];
            instr.instruction.rtype.rd = effective_ir[15:11];
            instr.instruction.rtype.shamnt = effective_ir[10:6];
            instr.instruction.rtype.fncode = effective_ir[5:0];

            reg_file_rs = instr.instruction.rtype.rs;
            reg_file_rt = instr.instruction.rtype.rt;
            reg_file_rd = instr.instruction.rtype.rd;
            reg_file_write = state == STATE_EXECUTE;
            reg_file_data_in = alu_out;
            fncode = instr.instruction.rtype.fncode;
        end
        else if(opcode == OPCODE_J || opcode == OPCODE_JAL) begin
            instr.instr_type = JTYPE;
            instr.instruction.jtype.opcode = opcode;
            instr.instruction.jtype.address = effective_ir[25:0];
        end
        else begin
            instr.instr_type = ITYPE;
            instr.instruction.itype.opcode    = opcode;
            instr.instruction.itype.rs        = effective_ir[25:21];
            instr.instruction.itype.rt        = effective_ir[20:16];
            instr.instruction.itype.immediate = effective_ir[15:0];
        end

        /* Fetch */
        if(state == STATE_FETCH) begin
            address = pc << 2;
            read = 1;
        end
    end

    always_ff @(posedge clk) begin
        if(active) begin
            if(reset) begin
                pc <= 32'hBFC0_0000;
                state <= STATE_FETCH;
            end
            else begin
                case(state)  
                    STATE_FETCH : begin
                        /* Won't exit the fetch state if bus isn't ready to be
                         * read from yet. Further, it won't do anything if 
                         * it's still * waiting */ 
                        if(!waitrequest) begin
                            pc <= pc + 1;
                            state <= STATE_EXECUTE;
                        end
                    end
                    STATE_EXECUTE : begin
                        ir <= readdata;
                        case(instr.instr_type) 
                            RTYPE : begin

                            end 
                            ITYPE : begin

                            end 
                            JTYPE : begin

                            end 
                            default : ;
                        endcase
                    end
                    STATE_MEMORY : begin
                       
                    end
                    STATE_WRITEBACK : begin
                        state <= STATE_FETCH;
                    end
                    default : ;
                endcase
            end
        end
    end

    reg_file reg_file(.clk(clk), 
                      .reset(reset), 
                      .addr_a(reg_file_rs),
                      .addr_b(reg_file_rt),
                      .write_addr(reg_file_rd),
                      .write(reg_file_write),
                      .data_in(reg_file_data_in),
                      .a(rs_val),
                      .b(rt_val),
                      .register_v0(register_v0)
    );
    alu alu(.a(rs_val), .b(rt_val), .fncode(fncode), .r(alu_out));
    
endmodule
