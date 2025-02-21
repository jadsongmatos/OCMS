module DecimalParaBinarioVetor #(
    parameter NUM_BITS = 4  // Número de bits do número binário de entrada
)(
    input  logic [$clog2(2**NUM_BITS)-1:0] numero_decimal, // Número decimal de entrada
    output logic [2**NUM_BITS-1:0] vetor_binario         // Vetor binário de saída
);

    // Função para realizar o produto de Kronecker
    function automatic logic [2**NUM_BITS-1:0] kronecker_product(
        input logic [NUM_BITS-1:0] bin
    );
        logic [2**NUM_BITS-1:0] result;
        integer i;

        // Inicializa o vetor com [1]
        result = 1'b1;

        for (i = 0; i < NUM_BITS; i++) begin
            logic [2**(i+1)-1:0] temp;
            if (bin[NUM_BITS-1-i] == 1'b0) begin
                // Produto de Kronecker com [1, 0]
                temp = {result, 0};
            end else begin
                // Produto de Kronecker com [0, 1]
                temp = {0, result};
            end
            result = temp;
        end

        kronecker_product = result;
    endfunction

    // Conversão do número decimal para binário
    logic [NUM_BITS-1:0] numero_binario;
    assign numero_binario = numero_decimal;

    // Geração do vetor binário usando o produto de Kronecker
    assign vetor_binario = kronecker_product(numero_binario);

endmodule
