# Modulação NRZ-L

Implementação em VHDL da modulação **Unipolar NRZ-L**, em que o bit é
representado pelo *nível* do pulso durante todo o intervalo do bit
(`1` = nível alto, `0` = nível baixo). É codificação direta, sem memória de
estado: a saída depende apenas do bit atual.

## Estrutura desta pasta

```
nrz_l/
|-- README.md                       Descrição e índice do projeto (este arquivo)
|-- src/                            Código-fonte VHDL do circuito
|   |-- NRZ_L.vhd                   Módulo de modulação NRZ-L
|   `-- Top_Module.vhd              Top de placa (Basys 3): start/reset, PMOD e VGA
|-- sim/
|   `-- tb_NRZ_L.vhd                Testbench (CLK_PERIOD=10 ns, BIT_PERIOD=100 ns)
|-- constraints/
|   `-- basys3_constraints.xdc      Mapeamento de pinos (clock, botões, switches,
|                                   LEDs, PMOD JA e VGA)
|-- vivado_project/
|   `-- NRZ_L.xpr                   Projeto Vivado pronto para abrir
|-- docs/
|   |-- tutorial_simulacao.md       Passo a passo da simulação no Vivado
|   |-- tutorial_placa.md           Passo a passo da gravação na Basys 3
|   |-- documentacao_projeto.md     Diagramas, portas, generics e funcionamento
|   `-- midia/                      Prints da simulação e fotos da placa
`-- extras/
    |-- pmod_osciloscopio/          Saída no PMOD JA observada no Analog Discovery 3
    `-- vga/                        Saída VGA 640×480 @ 60 Hz com cores pulsantes
```

## Arquivos de código

- `src/NRZ_L.vhd` — módulo de modulação NRZ-L. Lê `data_in[15:0]` do MSB ao
  LSB, sustenta cada bit por `CYCLES_PER_BIT` ciclos do `clk` recebido e
  apresenta o bit corrente em `nrz_out`. Saída auxiliar `bit_idx`
  (15 → 0) sinaliza o índice em curso.
- `src/Top_Module.vhd` — *wrapper* de placa que integra o `NRZ_L` à Basys 3:
  gera o *gated clock* lento de transmissão a partir dos 100 MHz da placa,
  trava o início pelo botão `start`, espelha o sinal modulado em LED, PMOD
  JA e VGA, e instancia o IP `clk_wiz_vga` para o controlador 640×480
  @ 60 Hz.
- `sim/tb_NRZ_L.vhd` — testbench. Aplica `data_in = "1010110010011101"`,
  mantém `reset` ativo por 2 ciclos de clock e simula por `16 × BIT_PERIOD`.
- `constraints/basys3_constraints.xdc` — mapeamento físico completo
  (clock W5, botão central U18, botão direito T17, switches V17→R2,
  LED 0 U16, LEDs de índice E19/U19/V19/W18, PMOD JA J1/L2/J2/G2 e
  saídas VGA).

## Documentação

- [Tutorial de simulação](./docs/tutorial_simulacao.md) — como abrir o
  projeto, configurar o testbench e executar a simulação comportamental.
- [Tutorial de gravação na placa](./docs/tutorial_placa.md) — síntese,
  implementação, geração de bitstream e *Program Device*.
- [Documentação técnica](./docs/documentacao_projeto.md) — diagrama de
  blocos, tabela de portas, *generics*, funcionamento interno, mapeamento
  físico e dependências (incluindo o IP `clk_wiz_vga`).

## Por onde começar

Para uma **simulação rápida** (apenas ver funcionando):

1. Abrir o Vivado 2025.2 e carregar `vivado_project/NRZ_L.xpr`.
2. Clicar em `Run Simulation` → `Run Behavioral Simulation`.

Para **reproduzir o projeto do zero**, seguir esta ordem:

1. **Entender o circuito** lendo a
   [documentação técnica](./docs/documentacao_projeto.md).
2. **Simular no Vivado** seguindo o
   [tutorial de simulação](./docs/tutorial_simulacao.md).
3. **Gravar na placa** seguindo o
   [tutorial de gravação](./docs/tutorial_placa.md).
4. (Opcional) Explorar os [extras](./extras/) — PMOD e VGA.

## Extras (realizados)

- [Saída pelo PMOD / Analog Discovery 3](./extras/pmod_osciloscopio/)
- [Saída VGA com cores pulsantes](./extras/vga/)

## Próximo passo

Após concluir este projeto, seguir para a [Modulação NRZ-I](../nrz_i/),
que implementa a outra modulação estudada no trabalho.
