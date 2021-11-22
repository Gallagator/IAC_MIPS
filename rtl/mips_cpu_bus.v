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

    /* R-type */ 
    opcode_t opcode;
    logic[4:0] rs, rt, rd;
    logic[4:0] shamnt;
    funct_t func;

    always_comb begin
        /* Decoding */
        /* Grabs the instruction that has just been fetched. */
        effective_ir = state == STATE_EXECUTE ? readdata : ir;
        /* rtype */ 
        opcode = effective_ir[31:26];
        rs     = effective_ir[25:21];
        rt     = effective_ir[20:16];
        rd     = effective_ir[15:11];
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
            case(state) begin 
                STATE_FETCH begin
                    pc <= pc + 1
                    state <= STATE_EXECUTE;
                end
                STATE_EXECUTE begin
                    /* Won't exit the execute state if bus hasn't been read 
                     * from yet. Further, it won't do anything if its still
                     * waiting */
                    if(!waitrequest) begin
                        ir <= readdata;
                        case(opcode) 
                            OPCODE_RTYPE begin
                                case(func)
                                    FUNCT_ADDU begin
                                        
                                    end 
                                endcase 
                            end                
                        endcase
                    end
                end
                STATE_MEMORY begin
                   
                end
                STATE_WRITEBACK begin

                end
            end
             
        end
    end

    reg_file reg_file(.clk(clk), 
                      .reset(reset), 
                      .addr_a(),
                      .addr_b(),
                      .write_addr(),
                      .write(),
                      .data_in(),
                      .a(),
                      .b()
    );
    
endmodule
