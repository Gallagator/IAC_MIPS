// i1 <---- ir
// i2 <---- ir_next
// i3
// Fetch, Decode, execute, memory_access, WB

typedef enum logic[5:0] {
    FUNCT_ADDU = 6'b10_0001,
    FUNCT_JR   = 6'b00_1000
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
        STATE_FETCH = 0,
        STATE_EXECUTE = 1,
        STATE_MEMORY = 2,
        STATE_WRITEBACK = 3
    } state_t;

    typedef enum logic[5:0] {
        OPCODE_RTYPE = 6'b00_0000,
        OPCODE_JAL   = 6'b00_0011,
        OPCODE_J     = 6'b00_0010,
        OPCODE_ADDIU = 6'b00_1001
    } opcode_t;
    
    typedef enum logic[1:0] {
        RTYPE,
        ITYPE,
        JTYPE
    } instr_type_t;

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
    logic[5:0] fncode;
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
    assign itype_immediate = {16'b0 , effective_ir[15:0]};

    /* jtype */
    assign jtype_address = effective_ir[25:0];

    /* iverilog won't allow always_comb when selecting bits with [] */
    always_comb begin
        
        /* TODO assign more carefully: */
        write = 0;
        writedata = 0;
        byteenable = 0;

        /* Set active signal */
        active = pc != 0;
        /* Decoding */
        /* Grabs the instruction that has just been fetched. */
        effective_ir = state == STATE_EXECUTE ? readdata : ir;
       
        if(opcode == OPCODE_RTYPE) begin 
            instr_type = RTYPE;

            reg_file_rs = rtype_rs;
            reg_file_rt = rtype_rt;
            reg_file_rd = rtype_rd;
            reg_file_write = state == STATE_EXECUTE;
            reg_file_data_in = alu_out;
            fncode = rtype_fncode;
            alu_b = rt_val;
        end
        else if(opcode == OPCODE_J || opcode == OPCODE_JAL) begin
            instr_type = JTYPE;
        end
        else begin
            instr_type = ITYPE;

            reg_file_rs = itype_rs;
            reg_file_rd = itype_rt;
            reg_file_write = state == STATE_EXECUTE;
            reg_file_data_in = alu_out;
            alu_b = itype_immediate;
            fncode = FUNCT_ADDU;
        end

        /* Fetch */
        if(state == STATE_FETCH && !waitrequest) begin
            address = pc;
            read = 1;
        end
        else begin
            read = 0; 
            // address needs to be set.
        end
    end

    always @(posedge clk) begin
        if(reset) begin
            pc <= 32'hBFC0_0000;
            state <= STATE_FETCH;
        end
        else if(active) begin
            case(state)  
                STATE_FETCH : begin
                    /* Won't exit the fetch state if bus isn't ready to be
                     * read from yet. Further, it won't do anything if 
                     * it's still waiting */ 
                    if(!waitrequest) begin
                        pc <= pc + 4;
                        state <= STATE_EXECUTE;
                        $display("state FETCH\naddress: %x\nread: %d\neff_ir: %x\n\n", address, read, readdata);
                    end
                end
                STATE_EXECUTE : begin
                    $display("state EXEC\naddress: %x\nread: %d\neff_ir: %x\n\n", address, read, effective_ir);

                    ir <= readdata;
                    case(instr_type) 
                        RTYPE : begin
                            if(rtype_fncode == FUNCT_JR) begin
                                pc <= rtype_rs;
                            end
                        end 
                        ITYPE : begin

                        end 
                        JTYPE : begin

                        end 
                        default : ;
                    endcase
                    state <= STATE_FETCH;
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

    alu alu(.a(rs_val), .b(alu_b), .fncode(fncode), .r(alu_out));

endmodule
