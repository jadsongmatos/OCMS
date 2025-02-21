# OCMS

Para gerar um diagrama de circuito a partir de um código em SystemVerilog no Linux, você pode utilizar ferramentas de código aberto que permitem sintetizar o código HDL e visualizar o netlist resultante. A seguir, apresento um passo a passo detalhado utilizando o **Yosys** para síntese e o **Graphviz** para visualização do diagrama.

### 1. Instalar as Ferramentas Necessárias

**Yosys** é um sintetizador de código aberto para linguagens HDL como Verilog e SystemVerilog. **Graphviz** é uma ferramenta para visualização de gráficos que será utilizada para gerar o diagrama a partir do netlist.

Abra o terminal e execute os seguintes comandos para instalar as ferramentas:

```bash
sudo apt-get update
sudo apt-get install yosys graphviz
```

### 2. Preparar o Código SystemVerilog

Certifique-se de que seu código SystemVerilog está correto e salvo em um arquivo, por exemplo, `seu_circuito.sv`. Identifique o módulo principal que será o ponto de entrada para a síntese.

### 3. Criar um Script de Síntese para o Yosys

Crie um arquivo de script para o Yosys, por exemplo, `synth.ys`, com o seguinte conteúdo:

```tcl
# synth.ys

# Ativa o suporte a SystemVerilog
read_verilog -sv seu_circuito.sv

# Executa a síntese utilizando o pass básico
synth -top nome_do_modulo_principal

# Otimiza o circuito mapeado
opt

show -width -signed -format png -prefix nome_do_modulo_principal

# Exibe as estatísticas do circuito sintetizado
stat
```

**Substitua** `seu_circuito.sv` pelo nome do seu arquivo SystemVerilog e `nome_do_modulo_principal` pelo nome do módulo que atua como top module no seu design.

### 4. Executar o Yosys para Gerar o Netlist

No terminal, execute o Yosys com o script de síntese:

```bash
yosys synth.ys
```
