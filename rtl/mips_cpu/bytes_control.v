`include "package.v"

module bytes_control(
    input logic[31:0] readdata_eb,
    input logic[5:0] opcode,
    input logic[1:0] lsb_bits,
    output logic[31:0] bytes_out,
    output logic[3:0] byteenable
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
                0: begin
                    bytes_out = (opcode == OPCODE_LHU) ? {16'b0, second, first} : ( (second >> 7) ? {16'hFFFF, second, first} : {16'b0, second, first});
                    byteenable = 4'b0011;
                end
                2: begin
                    bytes_out = {fourth, third, 16'b0};
                    byteenable = 4'b1100;
                end
            endcase

        end
        else begin 
            case(lsb_bits)
                0 : begin
                    bytes_out = (opcode == OPCODE_LBU) ? {24'b0, first} : ( (first >> 7) ? {24'hFFFFFF, first} :  {24'b0, first});   // first >> 7 is the MSB.
                    byteenable = 4'b0001;
                end
                1 : begin
                    bytes_out = (opcode == OPCODE_LBU) ? {24'b0, second} : ( (second >> 7) ? {24'hFFFFFF, second} : {24'b0, second});
                    byteenable = 4'b0010;
                end
                2 : begin
                    bytes_out = (opcode == OPCODE_LBU) ? {24'b0, third} : ( (third >> 7) ? {24'hFFFFFF, third} : {24'b0, third});
                    byteenable = 4'b0100;
                end
                3 : begin
                    bytes_out = (opcode == OPCODE_LBU) ? {24'b0, fourth} : ( (fourth >> 7) ? {24'hFFFFFF, fourth} : {24'b0, fourth});
                    byteenable = 4'b1000;
                end
            endcase
        end
        
    end

endmodule