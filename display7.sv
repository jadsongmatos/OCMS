module display7 (
    input  logic x1,
    input  logic x3,
    input  logic x5,
    input  logic x7,
    output logic [63:0] y
);
    always_comb begin
        y = 64'b0;

        // Expressões não-nulas:
        // Linha 3: x1 x3 x5 (1 - x7)
        y[3]  = x1 & x3 & x5 & ~x7;

        // Linha 46: -x5 (x1 - 1)(x3 - 1)(x7 - 1) = x5' & x1' & x3' & x7'
        y[46] = ~x5 & ~x1 & ~x3 & ~x7;

        // Linha 61: -x3 (x1 - 1)(x5 - 1)(x7 - 1) = x3' & x1' & x5' & x7'
        y[61] = ~x3 & ~x1 & ~x5 & ~x7;
    end
endmodule
