module BranchUnit (
    input  [31:0] pc_ex, // endereço pc 
    input  [31:0] rs1_value, //registrador 1
    input  [31:0] rs2_value, //registrador 2
    input  [31:0] instruction,

    output reg        branch_taken, //avisa se o desvio ocorrer
    output reg [31:0] branch_target //qual endereço deve ir se desvio
);

    localparam BEQ = 7'b110_0011;

    wire [6:0] opcode;
    assign opcode = instruction[6:0];
    wire [31:0] branch_imm;


    assign branch_imm = {
        {20{instruction[31]}},
        instruction[7],
        instruction[30:25],
        instruction[11:8],
        1'b0
    };

    always @(*) begin
        branch_taken  = 1'b0;
        branch_target = pc_ex + 32'd4;

        //parte implementação beq
        if(opcode == BEQ) begin
            if(rs1_value == rs2_value) begin
                branch_taken  = 1'b1; // avisa que vai saltar
                branch_target = pc_ex + branch_imm;
             end
        end
    end

endmodule
