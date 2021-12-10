`include "package.v"

module bytes_control(
    input logic[31:0] readdata_eb,
    input logic[5:0] opcode,
    input logic[1:0] lsb_bits,
    output logic[31:0] bytes_out 
);

    logic[7:0] first;
    logic[7:0] second;
    logic[7:0] third;
    logic[7:0] fourth;

    assign first    = readdata_eb[7:0];
    assign second   = readdata_eb[15:8];
    assign third    = readdata_eb[23:16];
    assign fourth   = readdata_eb[31:24];

    always_comb begin

        if(opcode == OPCODE_LHU || opcode == OPCODE_LH) begin
            
            case(lsb_bits)
                0: bytes_out = (opcode == OPCODE_LHU) ? {16'b0, second, first} : ( (second >> 7) ? {16'hFFFF, second, first} : {16'b0, second, first});
                2: bytes_out = {fourth, third, 16'b0};
            endcase

        end
        else begin 
            case(lsb_bits)
                0 : begin
                    bytes_out = (opcode == OPCODE_LBU) ? {24'b0, first} : ( (first >> 7) ? {24'hFFFFFF, first} :  {24'b0, first});   // first >> 7 is the MSB.
                end
                1 : begin
                    bytes_out = (opcode == OPCODE_LBU) ? {24'b0, second} : ( (second >> 7) ? {24'hFFFFFF, second} : {24'b0, second});
                end
                2 : begin
                    bytes_out = (opcode == OPCODE_LBU) ? {24'b0, third} : ( (third >> 7) ? {24'hFFFFFF, third} : {24'b0, third});
                end
                3 : begin
                    bytes_out = (opcode == OPCODE_LBU) ? {24'b0, fourth} : ( (fourth >> 7) ? {24'hFFFFFF, fourth} : {24'b0, fourth});
                end
            endcase
        end
    end

endmodule