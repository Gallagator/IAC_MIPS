module sign_extension(
    input logic[15:0] itype_immediate,
    input logic[5:0] opcode,
    output logic[31:0] signed_itype_immediate
);
    logic msb;
    assign msb = itype_immediate[15];

    always_comb begin
        
        if(opcode == OPCODE_ANDI || opcode == OPCODE_ORI || opcode == OPCODE_XORI) begin
            signed_itype_immediate = {16'b0, itype_immediate}; 
        end
        else if(opcode == OPCODE_LUI) begin
            signed_itype_immediate = {itype_immediate, 16'b0};
        end
        else begin  // Address calculations and other Itype instructions.
            signed_itype_immediate = msb ? {16'hFFFF, itype_immediate} : {16'b0, itype_immediate};
        end
        
    end

endmodule

