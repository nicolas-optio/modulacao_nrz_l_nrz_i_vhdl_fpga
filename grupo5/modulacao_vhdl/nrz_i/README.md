# Modulação NRZ-I

Implementação em VHDL da modulação **Unipolar NRZ-I**, em que o bit é
representado pela **transição** do pulso no início do intervalo de bit
(`1` = inversão do nível anterior, `0` = mantém o nível anterior). Por
depender do nível imediatamente anterior, a NRZ-I tem **memória de
estado** — aqui implementada como pré-codificação combinacional por
cascata de XOR (`generate`).

## Estrutura desta pasta

```
nrz_i/
|-- README.md                       Descrição e índice do projeto (este arquivo)
|-- src/                            Código-fonte VHDL do circuito
|   |-- NRZ_I.vhd                   Módulo de modulação NRZ-I (XOR cascateado)
|   `-- Top_Module.vhd              Top de placa (Basys 3): start/reset, PMOD e VGA
|-- sim/
|   `-- tb_nrz_I.vhd                Testbench (CLK_PERIOD=10 ns, BIT_PERIOD=100 ns)
|-- constraints/
|   `-- basys3_constraints.xdc      Mapeamento de pinos (clock, botões, switches,
|                                   LEDs, PMOD JA e VGA)
|-- vivado_project/
|   `-- NRZ_I.xpr                   Projeto Vivado pronto para abrir
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

- `src/NRZ_I.vhd` — módulo de modulação NRZ-I. A pré-codificação é feita
  por uma cascata de XORs declarada com `generate`:
  `encoded(DATA_WIDTH-1) <= '0' XOR data_in(DATA_WIDTH-1);`
  `encoded(i)   <= encoded(i+1) XOR data_in(i)` para `i = DATA_WIDTH-2 ... 0`.
  Um processo síncrono varre `bit_index` de `15 → 0`, exibindo
  `encoded(bit_index)` em `nrz_out`.
- `src/Top_Module.vhd` — *wrapper* de placa (mesma estrutura do
  `Top_Module` do NRZ-L): divisor de clock ≈ 10 Hz, FSM `start/ligado`,
  *gating* `clk_gated`, espelhamento da saída em LED, PMOD JA e VGA, e
  instância do IP `clk_wiz_vga` (25,175 MHz) para o controlador VGA
  640×480 @ 60 Hz.
- `sim/tb_nrz_I.vhd` — testbench. Aplica `data_in = "1010110010011101"`,
  mantém `reset` ativo por 2 ciclos de clock e simula por
  `16 × BIT_PERIOD`.
- `constraints/basys3_constraints.xdc` — mapeamento físico completo (clock
  W5, botões U18/T17, switches V17→R2, LED 0 U16, LEDs de índice
  E19/U19/V19/W18, PMOD JA J1/L2/J2/G2 e saídas VGA).

## Documentação

- [Tutorial de simulação](./docs/tutorial_simulacao.md) — como abrir o
  projeto, configurar o testbench e executar a simulação comportamental.
- [Tutorial de gravação na placa](./docs/tutorial_placa.md) — síntese,
  implementação, geração de bitstream e *Program Device*.
- [Documentação técnica](./docs/documentacao_projeto.md) — diagrama de
  blocos, tabela de portas, *generics*, funcionamento interno
  (pré-codificação XOR cascateada), mapeamento físico e dependências.

## Por onde começar

Para uma **simulação rápida** (apenas ver funcionando):

1. Abrir o Vivado 2025.2 e carregar `vivado_project/NRZ_I.xpr`.
2. Clicar em `Run Simulation` → `Run Behavioral Simulation`.

Para **reproduzir o projeto do zero**, seguir esta ordem:

1. **Entender o circuito** lendo a
   [documentação técnica](./docs/documentacao_projeto.md).
2. **Comparar com o NRZ-L** ([projeto anterior](../nrz_l/)) para
   identificar as diferenças na regra de transição.
3. **Simular no Vivado** seguindo o
   [tutorial de simulação](./docs/tutorial_simulacao.md).
4. **Gravar na placa** seguindo o
   [tutorial de gravação](./docs/tutorial_placa.md).
5. (Opcional) Explorar os [extras](./extras/) — PMOD e VGA.

## Extras (realizados)

- [Saída pelo PMOD / Analog Discovery 3](./extras/pmod_osciloscopio/)
- [Saída VGA com cores pulsantes](./extras/vga/)

## Próximo passo

Concluídos os dois projetos do trabalho, acessar o
[Relatório técnico final](../relatorio_final/relatorio.pdf), que
apresenta a análise comparativa entre NRZ-L e NRZ-I, os resultados
obtidos e as conclusões.
