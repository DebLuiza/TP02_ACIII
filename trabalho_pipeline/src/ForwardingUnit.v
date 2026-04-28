module ForwardingUnit (
    input  [4:0] idex_rs1,
    input  [4:0] idex_rs2,
    input  [4:0] exmem_rd,
    input  [4:0] memwb_rd,

    input  [6:0] exmem_op,
    input  [6:0] memwb_op,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

    localparam NO_FORWARD  = 2'b00;
    localparam FROM_MEM    = 2'b01;
    localparam FROM_WB_ALU = 2'b10;
    localparam FROM_WB_LD  = 2'b11;

    localparam LW    = 7'b000_0011;
    localparam ALUop = 7'b001_0011;

    initial begin
      forwardA = NO_FORWARD;
      forwardB = NO_FORWARD;
    end

    always @(*) begin
        forwardA = NO_FORWARD;
        forwardB = NO_FORWARD;

        // lógica do forwarding para operando A 
        if ((exmem_rd != 5'd0) && (idex_rs1 == exmem_rd)) begin
            forwardA = FROM_MEM;
        end
        else if ((memwb_rd != 5'd0) && (idex_rs1 == memwb_rd)) begin
            if (memwb_op == ALUop)
                forwardA = FROM_WB_ALU;
            else if (memwb_op == LW)
                forwardA = FROM_WB_LD;
        end

        // lógica do forwarding para operando B
        if ((exmem_rd != 5'd0) && (idex_rs2 == exmem_rd)) begin 
            forwardB = FROM_MEM;
        end
        else if ((memwb_rd != 5'd0) && (idex_rs2 == memwb_rd)) begin
            if (memwb_op == ALUop)
                forwardB = FROM_WB_ALU;
            else if (memwb_op == LW)
                forwardB = FROM_WB_LD;
        end
    end

endmodule
