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
    logic[31:0] address_unaligned;
    assign address = {address_unaligned[31:2], 2'b00};

    /* readdata/writedata big endian */
    logic[31:0] readdata_eb;
    logic[31:0] writedata_eb;

    /* Program Counter, instruction register, state */
    logic[31: 0] pc, pc_branch;
    branch_delay_state_t branch_delayed;

    logic[31: 0] ir, effective_ir;
    state_t state;

    //hi lo regs for div and mult
    logic[31:0] hi, lo;

    /* Register file outputs */  
    logic[31:0] rs_val, rt_val;

    /* Reg file inputs */
    logic reg_file_write;
    logic[31:0] reg_file_data_in;
    logic[4:0] reg_file_rs;
    logic[4:0] reg_file_rt;
    logic[4:0] reg_file_rd;

    /* ALU */
    logic[31:0] alu_out, alu_out2;
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
    logic[31:0] loadstore_word; // bytes_control output.
    logic[3:0] bytes_byteenable;    // bytes_control output.

    /* jtype_instructions */
    logic[25:0] jtype_address;

    logic waitrequest_prev;

    assign opcode = effective_ir[31:26];

    /* rtype */
    assign rtype_rs        = effective_ir[25:21];
    assign rtype_rt        = effective_ir[20:16];
    assign rtype_rd        = effective_ir[15:11];
    assign rtype_shamnt    = effective_ir[10:6];
    assign extended_shamnt = {27'b0, rtype_shamnt};
    assign rtype_fncode    = effective_ir[5:0];

    /* itype */
    assign itype_rs     = effective_ir[25:21];
    assign itype_rt     = effective_ir[20:16];

    /* jtype */
    assign jtype_address = effective_ir[25:0];

    /* Bit addressing does not work in  always comb blocks. */
    always_comb begin
        
        /* Set active signal. pc must not be 0 and instruction must not 
         * have finished. */
        active = pc != 0 || state != STATE_FETCH;
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
            alu_a = immediate_shift ? extended_shamnt : rs_val;
            alu_b = rt_val;
            case(rtype_fncode)
                FUNCT_MFH : begin
                    reg_file_data_in = hi;
                    reg_file_write = state == STATE_EXECUTE;
                end
                FUNCT_MFL : begin
                    reg_file_data_in = lo;
                    reg_file_write = state == STATE_EXECUTE;
                end
                FUNCT_MULT : begin
                    reg_file_write = 0;
                end
                FUNCT_MULTU : begin
                    reg_file_write = 0;
                end
                FUNCT_DIV : begin
                    reg_file_write = 0;
                end
                FUNCT_DIVU : begin
                    reg_file_write = 0;
                end
                default   : begin
                    reg_file_data_in = alu_out; 
                    reg_file_write = state == STATE_EXECUTE;
                end
            endcase
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
                address_unaligned = pc;
                byteenable = 4'b1111;
            end
            STATE_EXECUTE : begin

                if(opcode == OPCODE_SW) begin
                    write = 0; 
                    read = 0;
                    address_unaligned = alu_out;
                    reg_file_write = 0;
                    writedata_eb = rt_val;
                    byteenable = bytes_byteenable;
                end
                else if(opcode == OPCODE_SB || opcode == OPCODE_SH) begin
                    write = 0;
                    read = 0;
                    address_unaligned = alu_out;
                    reg_file_write = 0;
                    writedata_eb = loadstore_word;
                    byteenable = bytes_byteenable;
                end
                else if(opcode == OPCODE_LW || opcode == OPCODE_LBU || opcode == OPCODE_LB || 
                        opcode == OPCODE_LHU || opcode == OPCODE_LH || 
                        opcode == OPCODE_LWL || opcode == OPCODE_LWR) begin     // Don't know if I can shorten this by putting it as default.
                    write = 0;
                    read = 1;
                    address_unaligned = alu_out;
                    reg_file_write = 0;
                    byteenable = bytes_byteenable;
                end
                else if(opcode == OPCODE_LUI) begin
                    write = 0;
                    read = 0;
                    reg_file_data_in = itype_immediate;
                    reg_file_write = 1;
                end
                else if(opcode == OPCODE_RTYPE) begin
                    if(rtype_fncode == FUNCT_MFH) begin
                        write = 0;  
                        read = 0;
                        reg_file_write = 1;
                        reg_file_data_in = hi;
                    end
                    else if (rtype_fncode == FUNCT_MFL) begin
                        write = 0;  
                        read = 0;
                        reg_file_write = 1;
                        reg_file_data_in = lo;
                    end
                    else begin
                        write = 0;  
                        read = 0;
                        reg_file_write = 1;
                        reg_file_data_in = alu_out;
                    end
                end
                else begin
                    write = 0;  
                    read = 0;
                    reg_file_write = 1;
                    reg_file_data_in = alu_out;
                end

            end
            STATE_MEMORY : begin
                reg_file_write = 1;
                if(opcode == OPCODE_SW || 
                   opcode == OPCODE_SB || 
                   opcode == OPCODE_SH) begin
                    write = 1;
                    address_unaligned = alu_out;
                    reg_file_write = 0;
                    writedata_eb = rt_val;
                    byteenable = bytes_byteenable;
                end
                else begin     // LBU, LB, LHU, LH, LWL, LWR
                    write = 0;
                    reg_file_data_in = loadstore_word;
                    address_unaligned = alu_out;
                    reg_file_write = 1;
                    byteenable = bytes_byteenable;
                end
            end
        endcase

    end

    always @(posedge clk) begin
        waitrequest_prev <= waitrequest;
       
        if(reset) begin
            pc <= 32'hBFC0_0000;
            state <= STATE_FETCH;
            pc_branch <= 0;
            branch_delayed <= BRANCH_NONE;
            lo <= 0;
            hi <= 0;
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
                    if(branch_delayed == BRANCH_DELAYED) begin
                        pc <= pc_branch;
                        branch_delayed <= BRANCH_NONE;
                    end
                    
                    case(instr_type) 
                        RTYPE : begin
                            case(rtype_fncode)
                                FUNCT_JR : begin
                                    pc_branch <= rtype_rs;
                                    branch_delayed <= BRANCH_DELAYED;
                                end
                                FUNCT_MULT : begin
                                    lo <= alu_out;
                                    hi <= alu_out2;
                                end
                                FUNCT_DIV : begin
                                    lo <= alu_out;
                                    hi <= alu_out2;
                                end
                                FUNCT_MULTU : begin
                                    lo <= alu_out;
                                    hi <= alu_out2;
                                end
                                FUNCT_DIVU : begin
                                    lo <= alu_out;
                                    hi <= alu_out2;
                                end
                            endcase
                            state <= STATE_FETCH;
                        end 
                        ITYPE : begin
                            /* Will also have to include other load instrs */
                            if( opcode == OPCODE_LW || opcode == OPCODE_LBU || 
                                opcode == OPCODE_LB || opcode == OPCODE_LH || 
                                opcode == OPCODE_LHU || opcode == OPCODE_LWL || 
                                opcode == OPCODE_LWR ) begin    // Don't know I could make this shorter by putting it into the else statement.
                                
                                if(!waitrequest) begin
                                    state <= STATE_MEMORY;
                                end 
                            end
                            else if(opcode == OPCODE_SW || opcode == OPCODE_SB || opcode == OPCODE_SH) begin
                                if(!waitrequest) begin 
                                    state <= STATE_MEMORY;
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

    alu alu(.a(alu_a),
            .b(alu_b),
            .fncode(alu_fncode), 
            .r(alu_out),
            .o(alu_out2));

    toggle_endianness to_big(.a(readdata), .r(readdata_eb));
    toggle_endianness to_little(.a(writedata_eb), .r(writedata));

    sign_extension sign_extension(
        .itype_immediate(effective_ir[15:0]),
        .opcode(opcode),
        .signed_itype_immediate(itype_immediate)
    );

    bytes_control bytes_control(
        .readdata_eb(readdata_eb),
        .opcode(opcode),
        .lsb_bits(address_unaligned[1:0]),
        .bytes_out(loadstore_word),
        .rt_val_itype(rt_val),
        .byteenable(bytes_byteenable)
    );

endmodule

module toggle_endianness(
    input logic[31:0] a,
    output logic[31:0] r
);
    assign r = {a[7:0], a[15:8], a[23:16], a[31:24]};
 
endmodule

