module bytes_control(
    input logic[31:0] readdata_eb,
    input logic[5:0] opcode,
    input logic[1:0] lsb_bits,
    input logic[31:0] rt_val_itype,
    output logic[31:0] bytes_out,
    output logic[3:0] byteenable
);
    /* For readdata_eb */
    logic[7:0] first;
    logic[7:0] second;
    logic[7:0] third;
    logic[7:0] fourth;

    /* For rt_val_itype */
    logic[7:0] rt_first;
    logic[7:0] rt_second;
    logic[7:0] rt_third;
    logic[7:0] rt_fourth;

    /* For readdata_eb */
    assign first    = readdata_eb[7:0];
    assign second   = readdata_eb[15:8];
    assign third    = readdata_eb[23:16];
    assign fourth   = readdata_eb[31:24];

    /* For rt_val_itype */
    assign rt_first     = rt_val_itype[7:0];
    assign rt_second    = rt_val_itype[15:8];
    assign rt_third     = rt_val_itype[23:16];
    assign rt_fourth    = rt_val_itype[31:24];
    

    always_comb begin

        if(opcode == OPCODE_LW || opcode == OPCODE_SW) begin
            byteenable = 4'b1111;
            bytes_out = readdata_eb;
        end
        else if(opcode == OPCODE_SB) begin

            case(lsb_bits)
                0 : begin
                    byteenable = 4'b0001;
                    bytes_out = {24'b0, rt_first};
                end
                1 : begin
                    byteenable = 4'b0010;
                    bytes_out = {16'b0, rt_first, 8'b0};
                end
                2 : begin
                    byteenable = 4'b0100;
                    bytes_out = {8'b0, rt_first, 16'b0};
                end
                3 : begin
                    byteenable = 4'b1000;
                    bytes_out = {rt_first, 24'b0};
                end
            endcase

        end

        else if(opcode == OPCODE_SH) begin
            
            case(lsb_bits)
                0 : begin
                    byteenable = 4'b0011;
                    bytes_out = {16'b0, rt_second, rt_first};
                end
                2 : begin
                    byteenable = 4'b1100;
                    bytes_out = {rt_second, rt_first, 16'b0};
                end
            endcase
        end

        else if(opcode == OPCODE_LHU || opcode == OPCODE_LH) begin
            
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
        else if(opcode == OPCODE_LWL) begin

            case(lsb_bits)
                0 : begin
                    bytes_out = readdata_eb;
                    byteenable = 4'b1111; 
                end
                1: begin    // In spec it says to ignore this, but included it for completeness.
                    bytes_out = {rt_fourth, fourth, third, second};
                    byteenable = 4'b1110; 
                end
                2: begin
                    bytes_out = {rt_fourth, rt_third, fourth, third};
                    byteenable = 4'b1100; 
                end
                3: begin
                    bytes_out = {rt_fourth, rt_third, rt_second, fourth};
                    byteenable = 4'b1000; 
                end
            endcase

        end
        else if(opcode == OPCODE_LWR) begin

            case(lsb_bits)
                0 : begin
                    bytes_out = {first, rt_third, rt_second, rt_first};
                    byteenable = 4'b0001; 
                end
                1: begin
                    bytes_out = {second, first, rt_second, rt_first};
                    byteenable = 4'b0011; 
                end
                2: begin    // In spec it says to ignore this, but included it for completeness
                    bytes_out = {third, second, first, rt_first};
                    byteenable = 4'b0111; 
                end
                3: begin
                    bytes_out = readdata_eb;
                    byteenable = 4'b1111; 
                end
            endcase

        end
        else begin  // LB, LBU
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

