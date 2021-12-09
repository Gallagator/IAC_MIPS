// i1 <---- ir
// i2 <---- ir_next
// i3
// Fetch, Decode, execute, memory_access, WB

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
    OPCODE_RTYPE = 6'b00_0000,
    OPCODE_JAL   = 6'b00_0011,
    OPCODE_J     = 6'b00_0010,
    OPCODE_ADDIU = 6'b00_1001,
    OPCODE_LW = 6'b10_0011,
    OPCODE_SW = 6'b10_1011,
    OPCODE_ANDI  = 6'b00_1100,
    OPCODE_ORI   = 6'b00_1101,
    OPCODE_XORI  = 6'b00_1110
} opcode_t;
    
typedef enum logic[1:0] {
    RTYPE,
    ITYPE,
    JTYPE
} instr_type_t;

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


    /* Program Counter, instruction register, state */
    logic[31: 0] pc /*, pc_next*/;
    /* TODO REMEMBER TO SET IR_NEXT, AND EFFECTIVE_IR TO THE CORRECT INSTR! */ 
    logic[31: 0] ir/*, ir_next */, effective_ir;
    state_t state;

    /* Register file outputs */  
    logic[31:0] rs_val, rt_val;

    /* Reg file inputs */
    logic reg_file_write;
    logic[31:0] reg_file_data_in;
    logic[4:0] reg_file_rs;
    logic[4:0] reg_file_rt;
    logic[4:0] reg_file_rd;

    /* ALU */
    logic[31:0] alu_out;
    logic[5:0] alu_fncode;
    logic[31:0] alu_b;

    /* Instruction decode */
    logic[2:0] instr_type;
    logic[5:0] opcode;

    /* rtype instructions */
    logic[4:0] rtype_rs;
    logic[4:0] rtype_rt;
    logic[4:0] rtype_rd;
    logic[4:0] rtype_shamnt;
    logic[5:0] rtype_fncode;

    /* itype instructions */
    logic[4:0] itype_rs;
    logic[4:0] itype_rt;
    logic[31:0] itype_immediate;

    /* jtype_instructions */
    logic[25:0] jtype_address;

    logic waitrequest_prev;

    assign opcode = effective_ir[31:26];

    /* rtype */
    assign rtype_rs     = effective_ir[25:21];
    assign rtype_rt     = effective_ir[20:16];
    assign rtype_rd     = effective_ir[15:11];
    assign rtype_shamnt = effective_ir[10:6];
    assign rtype_fncode = effective_ir[5:0];

    /* itype */
    assign itype_rs        = effective_ir[25:21];
    assign itype_rt        = effective_ir[20:16];
    assign itype_immediate = {16'b0, effective_ir[15:0]};

    /* jtype */
    assign jtype_address = effective_ir[25:0];

    always_comb begin
        
                /* Set active signal */
        active = pc != 0;
        /* Decoding */
        /* Grabs the instruction that has just been fetched. */
        effective_ir = (state == STATE_EXECUTE && !waitrequest_prev) 
                       ? readdata : ir;

        if(opcode == OPCODE_RTYPE) begin 
            instr_type = RTYPE;
            reg_file_rs = rtype_rs;
            reg_file_rt = rtype_rt;
            reg_file_rd = rtype_rd;
            reg_file_write = state == STATE_EXECUTE;
            reg_file_data_in = alu_out;
            alu_b = rt_val;
        end
        else if(opcode == OPCODE_J || opcode == OPCODE_JAL) begin
            instr_type = JTYPE;
        end
        else begin
            instr_type = ITYPE;
            reg_file_rs = itype_rs;
            reg_file_rt = itype_rt;  // Mysteriously needed.
            reg_file_rd = itype_rt;

            alu_b = itype_immediate;
        end

        case(state) 
            STATE_FETCH: begin
                reg_file_write = 0;
                read = 1;
                write = 0;
                address = pc;
                byteenable = 4'b1111;
            end
            STATE_EXECUTE : begin
                case(opcode)
                    OPCODE_LW : begin
                        write = 0;
                        read = 1;
                        byteenable = 4'b1111;
                        address = alu_out;  
                        reg_file_write = 0;
                    end
                    OPCODE_SW : begin
                        write = 1; 
                        read = 0;
                        byteenable = 4'b1111;
                        address = alu_out;
                        writedata = rt_val;
                        reg_file_write = 0;
                    end
                    default : begin
                        write = 0;  
                        read = 0;
                        reg_file_write = 1;
                        reg_file_data_in = alu_out;
                    end
                endcase
            end
            STATE_MEMORY : begin
                case(opcode)
                    OPCODE_LW : begin
                        reg_file_data_in = readdata;
                        reg_file_write = 1;
                    end
                endcase
            end
        endcase

    end

    always @(posedge clk) begin
        waitrequest_prev <= waitrequest;
       
        if(reset) begin
            pc <= 32'hBFC0_0000;
            state <= STATE_FETCH;
        end
        else if(active) begin
            case(state)  
                STATE_FETCH : begin
                    //reg_file_write <= 0;
                    /* Won't exit the fetch state if bus isn't ready to be
                     * read from yet. Further, it won't do anything if 
                     * it's still waiting */ 
                    if(!waitrequest) begin
                        pc <= pc + 4;
                        state <= STATE_EXECUTE;
                    end

                end
                STATE_EXECUTE : begin
                    ir <= waitrequest_prev ? ir : readdata;

                    case(instr_type) 
                        RTYPE : begin
                            if(rtype_fncode == FUNCT_JR) begin
                                pc <= rtype_rs;                       
                            end
                            state <= STATE_FETCH;
                        end 
                        ITYPE : begin
                            /* Will also have to include other load instrs */
                            if(opcode == OPCODE_LW) begin
                                if(!waitrequest) begin 
                                    state <= STATE_MEMORY;
                                end 
                            end
                            else if(opcode == OPCODE_SW) begin
                                if(!waitrequest) begin 
                                    state <= STATE_FETCH;
                                end
                            end 
                            else begin
                                state <= STATE_FETCH;
                            end

                        end 
                        JTYPE : begin

                        end 
                        default : ;
                    endcase
                    
                end
                STATE_MEMORY : begin
                    state <= STATE_FETCH;
                end

                default : ;
            endcase
        end
    end

    alu_ctrl alu_ctrl(.opcode(opcode),
                      .rtype_fncode(rtype_fncode),
                      .fncode(alu_fncode)
    );

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

    alu alu(.a(rs_val), .b(alu_b), .fncode(alu_fncode), .r(alu_out));

endmodule
