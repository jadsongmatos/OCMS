```python
import numpy as np
import sympy as sp

def criar_vetor_de_simbolos(tamanho):
    """
    Cria um vetor (lista) de símbolos SymPy com o tamanho especificado.
    Parameters:
    tamanho (int): O número de símbolos a serem criados.
    Returns:
    list: Lista contendo os símbolos criados.
    """
    # Cria os símbolos usando sp.symbols
    return sp.symbols(f'x1:{tamanho+1}')

# Função para calcular o produto Kronecker considerando binário exclusivo
def kronecker_binary(vectors):
    result = np.array([1])  # Inicia com o elemento neutro da multiplicação
    for v in vectors:
        result = np.kron(result, v)
    return result

def decimal_para_binario_vetor(numero_decimal, tamanho_bits=8):
    """
    Converte um número decimal para um vetor binário usando produtos de Kronecker.
    Args:
        numero_decimal (int): Número decimal a ser convertido.
        tamanho_bits (int, opcional): Número de bits para representar o número binário. Padrão é 8.
    Returns:
        np.ndarray: Vetor resultante da conversão.
    
    Raises:
        ValueError: Se o número decimal for negativo ou se o tamanho de bits for insuficiente.
    """
    # Mapeamento dos caracteres binários para os vetores desejados
    mapeamento = {'0': [1, 0], '1': [0, 1]}
    # Verifica se o número é um inteiro não negativo
    if not isinstance(numero_decimal, int):
        print(numero_decimal)
        raise TypeError("O número decimal deve ser um inteiro.")
    if numero_decimal < 0:
        raise ValueError("A função não suporta números decimais negativos.")
    # Converter o número decimal para binário e remover o prefixo '0b'
    numero_binario = bin(numero_decimal)[2:]
    # Verifica se o número binário cabe no tamanho de bits desejado
    if len(numero_binario) > tamanho_bits:
        raise ValueError(f"O número binário '{numero_binario}' excede o tamanho de bits especificado ({tamanho_bits} bits).")
    # Adiciona zeros à esquerda para completar o tamanho de bits desejado
    numero_binario = numero_binario.zfill(tamanho_bits)
    # Inicializa o vetor com 1 para o produto de Kronecker
    vetor = np.array([1])
    
    # Aplica o produto de Kronecker para cada dígito binário
    for digito in numero_binario:
        vetor = np.kron(vetor, mapeamento[digito])
    return vetor

bits = 4
variaveis = sp.Matrix(kronecker_binary(np.array_split(criar_vetor_de_simbolos(bits*2), bits)))
```

$\displaystyle \left[\begin{matrix}x_{1} x_{3} x_{5} x_{7}\\x_{1} x_{3} x_{5} x_{8}\\x_{1} x_{3} x_{6} x_{7}\\x_{1} x_{3} x_{6} x_{8}\\x_{1} x_{4} x_{5} x_{7}\\x_{1} x_{4} x_{5} x_{8}\\x_{1} x_{4} x_{6} x_{7}\\x_{1} x_{4} x_{6} x_{8}\\x_{2} x_{3} x_{5} x_{7}\\x_{2} x_{3} x_{5} x_{8}\\x_{2} x_{3} x_{6} x_{7}\\x_{2} x_{3} x_{6} x_{8}\\x_{2} x_{4} x_{5} x_{7}\\x_{2} x_{4} x_{5} x_{8}\\x_{2} x_{4} x_{6} x_{7}\\x_{2} x_{4} x_{6} x_{8}\end{matrix}\right]$

```python
import pandas as pd
data = {
  "S2": ["0", "0", "0", "0", "0", "0", "0", "1", "0", "0", "1", "1", "0", "1", "1", "1"],
  "S1": ["0", "0", "1", "1", "0", "1", "1", "0", "1", "1", "0", "0", "1", "0", "0", "1"],
  "S0": ["0", "1", "0", "1", "1", "0", "1", "0", "0", "1", "0", "1", "1", "0", "1", "0"]
}
tabela_verdade = pd.DataFrame(data)
tabela_verdade = tabela_verdade.astype(int)

vetor_dec = np.array([int("".join(map(str, row)), 2) for row in tabela_verdade.to_numpy()])
```

[0, 1, 2, 3, 1, 2, 3, 4, 2, 3, 4, 5, 3, 4, 5, 6]

```python
vetores_binarios = []
tamanho_bits = tabela_verdade.columns.size
for numero in vetor_dec:
    try:
        vetor = decimal_para_binario_vetor(int(numero), tamanho_bits)
        vetores_binarios.append(vetor)
    except (TypeError, ValueError) as e:
        print(f"Erro ao converter o número {numero}: {e}")
vetores_binarios = np.array(vetores_binarios).T
```

$\displaystyle \left[\begin{array}{cccccccccccccccc}1 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\0 & 1 & 0 & 0 & 1 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\0 & 0 & 1 & 0 & 0 & 1 & 0 & 0 & 1 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\0 & 0 & 0 & 1 & 0 & 0 & 1 & 0 & 0 & 1 & 0 & 0 & 1 & 0 & 0 & 0\\0 & 0 & 0 & 0 & 0 & 0 & 0 & 1 & 0 & 0 & 1 & 0 & 0 & 1 & 0 & 0\\0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 1 & 0 & 0 & 1 & 0\\0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 1\\0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\end{array}\right]$

Shape (8, 16)

```python
regra = sp.Matrix(np.dot(vetores_binarios, variaveis)) # expressões simbólicas
```

$\displaystyle \left[\begin{matrix}x_{1} x_{3} x_{5} x_{7}\\x_{1} x_{3} x_{5} x_{8} + x_{1} x_{4} x_{5} x_{7}\\x_{1} x_{3} x_{6} x_{7} + x_{1} x_{4} x_{5} x_{8} + x_{2} x_{3} x_{5} x_{7}\\x_{1} x_{3} x_{6} x_{8} + x_{1} x_{4} x_{6} x_{7} + x_{2} x_{3} x_{5} x_{8} + x_{2} x_{4} x_{5} x_{7}\\x_{1} x_{4} x_{6} x_{8} + x_{2} x_{3} x_{6} x_{7} + x_{2} x_{4} x_{5} x_{8}\\x_{2} x_{3} x_{6} x_{8} + x_{2} x_{4} x_{6} x_{7}\\x_{2} x_{4} x_{6} x_{8}\\0\end{matrix}\right]$

```python
def criar_substituicoes(bits):
    simbolos = criar_vetor_de_simbolos(bits * 2)
    substituicoes = {simbolos[i+1]: 1-simbolos[i] for i in range(0, len(simbolos), 2)}
    return substituicoes

print(bits)
substituicoes = criar_substituicoes(bits)
```

{x2: 1 - x1, x4: 1 - x3, x6: 1 - x5, x8: 1 - x7}

```python
f = sp.simplify(regra.subs(substituicoes))
```

$\displaystyle \left[\begin{matrix}x_{1} x_{3} x_{5} x_{7}\\x_{1} x_{5} \left(- 2 x_{3} x_{7} + x_{3} + x_{7}\right)\\- x_{1} x_{3} x_{7} \left(x_{5} - 1\right) + x_{1} x_{5} \left(x_{3} - 1\right) \left(x_{7} - 1\right) - x_{3} x_{5} x_{7} \left(x_{1} - 1\right)\\x_{1} x_{3} \left(x_{5} - 1\right) \left(x_{7} - 1\right) + x_{1} x_{7} \left(x_{3} - 1\right) \left(x_{5} - 1\right) + x_{3} x_{5} \left(x_{1} - 1\right) \left(x_{7} - 1\right) + x_{5} x_{7} \left(x_{1} - 1\right) \left(x_{3} - 1\right)\\- x_{1} \left(x_{3} - 1\right) \left(x_{5} - 1\right) \left(x_{7} - 1\right) + x_{3} x_{7} \left(x_{1} - 1\right) \left(x_{5} - 1\right) - x_{5} \left(x_{1} - 1\right) \left(x_{3} - 1\right) \left(x_{7} - 1\right)\\\left(x_{1} - 1\right) \left(x_{5} - 1\right) \left(- x_{3} \left(x_{7} - 1\right) - x_{7} \left(x_{3} - 1\right)\right)\\\left(x_{1} - 1\right) \left(x_{3} - 1\right) \left(x_{5} - 1\right) \left(x_{7} - 1\right)\\0\end{matrix}\right]$

```python
from itertools import product
# Gerar todas as combinações de 0 e 1 para as 4 variáveis
entradas = list(product([0, 1], repeat=4))

for i, e in enumerate(f):
    variaveis_ordenadas = sorted(e.free_symbols, key=lambda s: s.name)
    print(f"F{i+1}({", ".join(str(s) for s in variaveis_ordenadas)}) = {e}")
    print("-------------------------")
    bin_valor = []
    for vals in entradas:
        valor = e.subs({var: vals[i] for i, var in enumerate(variaveis_ordenadas)})
        bin_valor.append(valor)
        print(f"{vals[0]} {vals[1]} {vals[2]} {vals[3]} | {valor}")
    
    bin_valor = bin_valor[::-1]
    # Verificando se teste é igual a alguma coluna
    for coluna in tabela_verdade.columns:
        if tabela_verdade[coluna].tolist() == bin_valor:
            print(f"Coluna '{coluna}' é igual a",e)
    else:
        print("Nenhuma coluna é igual a",e)
```

```
F1(x1, x3, x5, x7) = x1*x3*x5*x7
-------------------------
0 0 0 0 | 0
0 0 0 1 | 0
0 0 1 0 | 0
0 0 1 1 | 0
0 1 0 0 | 0
0 1 0 1 | 0
0 1 1 0 | 0
0 1 1 1 | 0
1 0 0 0 | 0
1 0 0 1 | 0
1 0 1 0 | 0
1 0 1 1 | 0
1 1 0 0 | 0
1 1 0 1 | 0
1 1 1 0 | 0
1 1 1 1 | 1
Nenhuma coluna é igual a x1*x3*x5*x7
F2(x1, x3, x5, x7) = x1*x5*(-2*x3*x7 + x3 + x7)
-------------------------
0 0 0 0 | 0
0 0 0 1 | 0
0 0 1 0 | 0
0 0 1 1 | 0
0 1 0 0 | 0
0 1 0 1 | 0
0 1 1 0 | 0
0 1 1 1 | 0
1 0 0 0 | 0
1 0 0 1 | 0
1 0 1 0 | 0
1 0 1 1 | 1
1 1 0 0 | 0
1 1 0 1 | 0
1 1 1 0 | 1
1 1 1 1 | 0
Nenhuma coluna é igual a x1*x5*(-2*x3*x7 + x3 + x7)
F3(x1, x3, x5, x7) = -x1*x3*x7*(x5 - 1) + x1*x5*(x3 - 1)*(x7 - 1) - x3*x5*x7*(x1 - 1)
-------------------------
0 0 0 0 | 0
0 0 0 1 | 0
0 0 1 0 | 0
0 0 1 1 | 0
0 1 0 0 | 0
0 1 0 1 | 0
0 1 1 0 | 0
0 1 1 1 | 1
1 0 0 0 | 0
1 0 0 1 | 0
1 0 1 0 | 1
1 0 1 1 | 0
1 1 0 0 | 0
1 1 0 1 | 1
1 1 1 0 | 0
1 1 1 1 | 0
Nenhuma coluna é igual a -x1*x3*x7*(x5 - 1) + x1*x5*(x3 - 1)*(x7 - 1) - x3*x5*x7*(x1 - 1)
F4(x1, x3, x5, x7) = x1*x3*(x5 - 1)*(x7 - 1) + x1*x7*(x3 - 1)*(x5 - 1) + x3*x5*(x1 - 1)*(x7 - 1) + x5*x7*(x1 - 1)*(x3 - 1)
-------------------------
0 0 0 0 | 0
0 0 0 1 | 0
0 0 1 0 | 0
0 0 1 1 | 1
0 1 0 0 | 0
0 1 0 1 | 0
0 1 1 0 | 1
0 1 1 1 | 0
1 0 0 0 | 0
1 0 0 1 | 1
1 0 1 0 | 0
1 0 1 1 | 0
1 1 0 0 | 1
1 1 0 1 | 0
1 1 1 0 | 0
1 1 1 1 | 0
Nenhuma coluna é igual a x1*x3*(x5 - 1)*(x7 - 1) + x1*x7*(x3 - 1)*(x5 - 1) + x3*x5*(x1 - 1)*(x7 - 1) + x5*x7*(x1 - 1)*(x3 - 1)
F5(x1, x3, x5, x7) = -x1*(x3 - 1)*(x5 - 1)*(x7 - 1) + x3*x7*(x1 - 1)*(x5 - 1) - x5*(x1 - 1)*(x3 - 1)*(x7 - 1)
-------------------------
0 0 0 0 | 0
0 0 0 1 | 0
0 0 1 0 | 1
0 0 1 1 | 0
0 1 0 0 | 0
0 1 0 1 | 1
0 1 1 0 | 0
0 1 1 1 | 0
1 0 0 0 | 1
1 0 0 1 | 0
1 0 1 0 | 0
1 0 1 1 | 0
1 1 0 0 | 0
1 1 0 1 | 0
1 1 1 0 | 0
1 1 1 1 | 0
Nenhuma coluna é igual a -x1*(x3 - 1)*(x5 - 1)*(x7 - 1) + x3*x7*(x1 - 1)*(x5 - 1) - x5*(x1 - 1)*(x3 - 1)*(x7 - 1)
F6(x1, x3, x5, x7) = (x1 - 1)*(x5 - 1)*(-x3*(x7 - 1) - x7*(x3 - 1))
-------------------------
0 0 0 0 | 0
0 0 0 1 | 1
0 0 1 0 | 0
0 0 1 1 | 0
0 1 0 0 | 1
0 1 0 1 | 0
0 1 1 0 | 0
0 1 1 1 | 0
1 0 0 0 | 0
1 0 0 1 | 0
1 0 1 0 | 0
1 0 1 1 | 0
1 1 0 0 | 0
1 1 0 1 | 0
1 1 1 0 | 0
1 1 1 1 | 0
Nenhuma coluna é igual a (x1 - 1)*(x5 - 1)*(-x3*(x7 - 1) - x7*(x3 - 1))
F7(x1, x3, x5, x7) = (x1 - 1)*(x3 - 1)*(x5 - 1)*(x7 - 1)
-------------------------
0 0 0 0 | 1
0 0 0 1 | 0
0 0 1 0 | 0
0 0 1 1 | 0
0 1 0 0 | 0
0 1 0 1 | 0
0 1 1 0 | 0
0 1 1 1 | 0
1 0 0 0 | 0
1 0 0 1 | 0
1 0 1 0 | 0
1 0 1 1 | 0
1 1 0 0 | 0
1 1 0 1 | 0
1 1 1 0 | 0
1 1 1 1 | 0
Nenhuma coluna é igual a (x1 - 1)*(x3 - 1)*(x5 - 1)*(x7 - 1)
F8() = 0
-------------------------
0 0 0 0 | 0
0 0 0 1 | 0
0 0 1 0 | 0
0 0 1 1 | 0
0 1 0 0 | 0
0 1 0 1 | 0
0 1 1 0 | 0
0 1 1 1 | 0
1 0 0 0 | 0
1 0 0 1 | 0
1 0 1 0 | 0
1 0 1 1 | 0
1 1 0 0 | 0
1 1 0 1 | 0
1 1 1 0 | 0
1 1 1 1 | 0
Nenhuma coluna é igual a 0
```
