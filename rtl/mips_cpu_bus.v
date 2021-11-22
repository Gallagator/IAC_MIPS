// Fetch, Decode, execute, memory_access, WB

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
    typedef enum logic[5:0] {
        OPCODE_RTYPE = 6'd0
    } opcode_t;
    
    typedef enum logic[5:0] {
        FUNCT_ADDU = 6'b10_0001;
    } funct_t;

    typedef enum logic[2:0] {
        STATE_FETCH,
        STATE_EXECUTE,
        STATE_MEMORY,
        STATE_WRITEBACK
    } state_t;

    /* Program Counter, instruction register, state */
    logic[31: 0] pc, pc_next;
    logic[31: 0] ir, effective_ir;
    state_t state;

    /* R-type encodings */ 
    opcode_t opcode;
    logic[4:0] rs, rt, rd;
    logic[4:0] shamnt;
    funct_t func;

    /* Register file outputs */  
    logic[31:0] rs_val, rt_val;

    logic reg_file_write;
    logic [31:0] reg_file_data_in;

    always_comb begin
        /* Decoding */
        /* Grabs the instruction that has just been fetched. */
        effective_ir = state == STATE_EXECUTE ? readdata : ir;
        /* rtype */ 
        opcode = effective_ir[31:26];
        rs     = effective_ir[25:21];
        rt     = effective_ir[20:16];
        rd     = opcode == OPCODE_RTYPE ? effective_ir[15:11] : rt;
        shamnt = effective_ir[10:6];
        func   = effective_ir[5:0];

        /* Fetch */
        if(state == STATE_FETCH) begin
            address = pc << 2;
            read = 1;
        end
    end

    always_ff @(posedge clk) begin
        if(reset) begin
            pc <= 32'hBFC0_0000;
            state <= STATE_FETCH;
        end
        else begin
            case(state) begin : states
                STATE_FETCH begin
                    /* Won't exit the fetch state if bus isn't ready to be read 
                     * from yet. Further, it won't do anything if its still
                     * waiting */ 
                    if(!waitrequest) begin
                        pc <= pc + 1
                        state <= STATE_EXECUTE;
                    end
                end
                STATE_EXECUTE begin
                    
                        ir <= readdata;
                        case(opcode) 
                            OPCODE_RTYPE begin : rtype
                                case(func)
                                    FUNCT_ADDU begin
                                        
                                    end 
                                endcase 
                                state <= STATE_FETCH;
                            end : rtype
                        endcase
                end
                STATE_MEMORY begin
                   
                end
                STATE_WRITEBACK begin

                end
            end : states
        end
    end

    reg_file reg_file(.clk(clk), 
                      .reset(reset), 
                      .addr_a(rs),
                      .addr_b(rt),
                      .write_addr(rd),
                      .write(reg_file_write),
                      .data_in(reg_file_data_in),
                      .a(rs_val),
                      .b(rt_val)
                      .register_v0(register_v0);
    );
    
endmodule
