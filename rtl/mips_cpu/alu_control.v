module alu_control(
    input logic[1:0] aluop,
    input logic[4:0] funct,
    output logic[3:0] fncode
);



    always_comb begin
        if(opcode == OPCODE_ADDIU )begin
            /* We are performing an addition, therefore:*/
            fncode = FUNCT_ADDU; 
        end
    end
    
endmodule