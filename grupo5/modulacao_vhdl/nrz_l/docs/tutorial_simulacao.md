# Tutorial — Simulação NRZ-L no Vivado

Este tutorial mostra, passo a passo, como rodar a simulação comportamental
do módulo `NRZ_L` no AMD Vivado e ler o resultado no *waveform*.

## 1. Pré-requisitos

- AMD Vivado 2025.2 (ou superior compatível) instalado.
- Sistema operacional: Windows 10/11 ou Linux com suporte oficial ao
  Vivado.
- Cópia local do repositório, com a pasta `nrz_l/` íntegra (`src/`,
  `sim/`, `constraints/`, `vivado_project/`).

## 2. Abrir o projeto

1. Iniciar o Vivado.
2. Em `Quick Start`, clicar em **Open Project**.
3. Selecionar o arquivo `nrz_l/vivado_project/NRZ_L.xpr` e clicar em
   **OK**.

> Caso o projeto não esteja disponível, criá-lo do zero como **RTL
> Project**, selecionando a *Default Part* `xc7a35tcpg236-1` (Basys 3) e
> adicionando manualmente os arquivos de `src/`, `sim/` e `constraints/`.
> Ao criar arquivos pelo Vivado, trocar **File type** para **VHDL** — o
> padrão é Verilog, e esquecer disso gera erro de elaboração.

![PLACEHOLDER: print da tela inicial do Vivado com o projeto NRZ_L aberto](midia/sim_projeto_aberto.png)

## 3. Estrutura dos arquivos no Vivado

No painel **Sources**, confirmar:

- **Design Sources**
  - `NRZ_L` (`src/NRZ_L.vhd`) — módulo de modulação.
  - `Top_Module` (`src/Top_Module.vhd`) — *wrapper* da placa (usado na
    síntese, não na simulação).
  - IP `clk_wiz_vga` — gerador de clock de 25,175 MHz para o controlador
    VGA (usado pela síntese, não pela simulação comportamental).
- **Simulation Sources**
  - `tb_NRZ_L` (`sim/tb_NRZ_L.vhd`) — testbench.
- **Constraints**
  - `basys3_constraints.xdc` — mapeamento físico, não usado na
    simulação.

## 4. Configurar o testbench como *top* da simulação

1. No painel **Sources**, expandir **Simulation Sources**.
2. Clicar com o botão direito em `tb_NRZ_L` → **Set as Top**. O ícone do
   testbench fica em destaque.
3. Acessar `Tools` → `Settings` → `Project Settings` → `Simulation`.
4. Confirmar **Simulator name** como **Vivado Simulator**.
5. Ajustar a propriedade `xsim.simulate.runtime` para **2000 ns**, o que
   garante a visualização completa dos 16 bits da sequência. Aplicar e
   fechar.

![PLACEHOLDER: print das Project Settings com xsim.simulate.runtime=2000 ns](midia/sim_runtime_2000ns.png)

## 5. Executar a simulação

1. No **Flow Navigator**, expandir **SIMULATION**.
2. Clicar em **Run Simulation** → **Run Behavioral Simulation**.
3. Aguardar a compilação dos fontes, elaboração e abertura automática da
   janela de *waveform*.

Caso a simulação encerre antes do tempo desejado, utilizar o atalho
`Shift + F2` (`Run for`) para estender o tempo simulado.

## 6. Visualização do *waveform*

1. Confirmar a presença, na janela de sinais, dos sinais do testbench:
   `clk`, `reset`, `data_in[15:0]`, `nrz_out` e `bit_idx`.
2. Aplicar zoom horizontal (`Ctrl` + roda do mouse) para enquadrar todo o
   intervalo da simulação.
3. Para legibilidade, clicar com o botão direito em `data_in` →
   `Radix` → `Binary`.
4. Capturar prints da janela de *waveform* para uso no relatório.

![PLACEHOLDER: print do waveform completo do NRZ-L de 0 a 2000 ns](midia/sim_waveform_nrz_l.png)

## 7. Resultado esperado

Para a sequência de entrada `data_in = "1010110010011101"` (hex `AC9D`,
MSB → LSB) e os parâmetros padrão (`CYCLES_PER_BIT = 10`,
`CLK_PERIOD = 10 ns`, `BIT_PERIOD = 100 ns`), o `nrz_out` reproduz
exatamente os bits de entrada, cada um sustentado por 100 ns:

| bit_idx | Bit | Intervalo (ns) | `nrz_out` |
| ------: | :-: | -------------: | :-------: |
| 15      | 1   | 20–120         | alto      |
| 14      | 0   | 120–220        | baixo     |
| 13      | 1   | 220–320        | alto      |
| 12      | 0   | 320–420        | baixo     |
| 11      | 1   | 420–520        | alto      |
| 10      | 1   | 520–620        | alto      |
| 9       | 0   | 620–720        | baixo     |
| 8       | 0   | 720–820        | baixo     |
| 7       | 1   | 820–920        | alto      |
| 6       | 0   | 920–1020       | baixo     |
| 5       | 0   | 1020–1120      | baixo     |
| 4       | 1   | 1120–1220      | alto      |
| 3       | 1   | 1220–1320      | alto      |
| 2       | 1   | 1320–1420      | alto      |
| 1       | 0   | 1420–1520      | baixo     |
| 0       | 1   | 1520–1620      | alto      |

Em 1.620 ns o `bit_idx` retorna a 15 e o ciclo recomeça. Os 20 ns
iniciais correspondem aos 2 ciclos de clock em que `reset` está ativo.

![PLACEHOLDER: print do waveform NRZ-L com radix binário em data_in](midia/sim_waveform_nrz_l_radix.png)

## Próximo passo

Validada a simulação, seguir para o
[tutorial de gravação na placa](tutorial_placa.md).
