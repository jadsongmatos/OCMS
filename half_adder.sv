// Definição do módulo Half Adder
module half_adder (
    input  wire A,      // Primeiro bit de entrada
    input  wire B,      // Segundo bit de entrada
    output wire Sum,    // Saída de soma
    output wire Carry   // Saída de transporte
);

    // Lógica combinacional para a soma
    assign Sum = A ^ B;      // Soma é o XOR das entradas

    // Lógica combinacional para o transporte
    assign Carry = A & B;    // Transporte é o AND das entradas

endmodule
