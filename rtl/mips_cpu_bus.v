`include "package.v"

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
    /* readdata/writedata big endian */
    logic[31:0] readdata_eb;
    logic[31:0] writedata_eb;

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
    logic[31:0] alu_a;
    logic[31:0] alu_b;

    /* Instruction decode */
    logic[2:0] instr_type;
    logic[5:0] opcode;

    /* rtype instructions */
    logic[4:0] rtype_rs;
    logic[4:0] rtype_rt;
    logic[4:0] rtype_rd;
    logic[4:0] rtype_shamnt;
    logic[31:0] extended_shamnt;
    logic immediate_shift;
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
    assign extended_shamnt = {27'b0, rtype_shamnt};
    assign rtype_fncode = effective_ir[5:0];

    /* itype */
    assign itype_rs     = effective_ir[25:21];
    assign itype_rt     = effective_ir[20:16];

    /* jtype */
    assign jtype_address = effective_ir[25:0];

    /* Bit addressing does not work in  always comb blocks. */
    always_comb begin
        
                /* Set active signal */
        active = pc != 0;
        /* Decoding */
        /* Grabs the instruction that has just been fetched. */
        effective_ir = (state == STATE_EXECUTE && !waitrequest_prev) 
                       ? readdata_eb : ir;

        if(opcode == OPCODE_RTYPE) begin 
            immediate_shift = rtype_fncode == FUNCT_SLL || 
                              rtype_fncode == FUNCT_SRL || 
                              rtype_fncode == FUNCT_SRA;

            instr_type = RTYPE;
            reg_file_rs = rtype_rs;
            reg_file_rt = rtype_rt;
            reg_file_rd = rtype_rd;
            reg_file_write = state == STATE_EXECUTE;
            reg_file_data_in = alu_out;
            alu_a = immediate_shift ? extended_shamnt : rs_val;
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
            alu_a = rs_val;
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
                        writedata_eb = rt_val;
                        reg_file_write = 0;
                    end
                    OPCODE_LB : begin
                        write = 0;
                        read = 1;
                        //byteenable = 
                        address = alu_out;
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
                        reg_file_data_in = readdata_eb;
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
                    ir <= waitrequest_prev ? ir : readdata_eb;

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

    alu alu(.a(alu_a), .b(alu_b), .fncode(alu_fncode), .r(alu_out));

    toggle_endianness to_big(.a(readdata), .r(readdata_eb));
    toggle_endianness to_little(.a(writedata_eb), .r(writedata));

    sign_extension sign_extension(
        .itype_immediate(effective_ir[15:0]),
        .msb(effective_ir[15]),
        .opcode(opcode),
        .signed_itype_immediate(itype_immediate)
    );

endmodule

module toggle_endianness(
    input logic[31:0] a,
    output logic[31:0] r
);
    assign r = {a[7:0], a[15:8], a[23:16], a[31:24]};

endmodule

