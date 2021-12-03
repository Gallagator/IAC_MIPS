module alu_ctrl(
    input logic[5:0] opcode,
    output logic[5:0] fncode   
);
    always_comb begin

        if(opcode == OPCODE_ADDIU) begin
            fncode = FUNCT_ADDU; 
        end  

    end
    

endmodule