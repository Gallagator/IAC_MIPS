`include "package.v"

module sign_extension(
    input logic[15:0] itype_immediate,
    input logic[5:0] opcode,
    output logic[31:0] signed_itype_immediate
);
    logic msb;
    assign msb = itype_immediate[15];

    always_comb begin
        
        if( opcode == OPCODE_LW || opcode == OPCODE_SW || 
            opcode == OPCODE_LBU || opcode == OPCODE_LB || 
            opcode == OPCODE_LHU || opcode == OPCODE_LH || 
            opcode == OPCODE_LWL || opcode == OPCODE_LWL || 
            opcode == OPCODE_LWR) begin // Need to apply Panagiotis' change.
            signed_itype_immediate = msb ? {16'hFFFF, itype_immediate} : {16'b0, itype_immediate};  // Address calculations are signed.
        end
        else if(opcode == OPCODE_LUI) begin
            signed_itype_immediate = {itype_immediate, 16'b0};
        end
        else begin
            signed_itype_immediate = {16'b0, itype_immediate};  // Unsigned Itype instructions.
        end
        
    end

endmodule