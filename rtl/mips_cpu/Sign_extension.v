`include "package.v"

module sign_extension(
    input logic[15:0] itype_immediate,
    input logic msb,
    input logic[5:0] opcode,
    output logic[31:0] signed_itype_immediate
);

    always_comb begin
        
        if(opcode == OPCODE_LW || opcode == OPCODE_SW || opcode == OPCODE_LB) begin
            if(msb == 1) begin
                signed_itype_immediate = {16'hFFFF, itype_immediate};
            end
            else begin
                signed_itype_immediate = {16'b0, itype_immediate};
            end
        end
        else begin
            signed_itype_immediate = {16'b0, itype_immediate};
        end
    end

endmodule