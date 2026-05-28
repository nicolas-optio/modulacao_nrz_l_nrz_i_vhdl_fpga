# Extra — Saída pelo PMOD (Analog Discovery 3) — NRZ-I

Disponibiliza o sinal NRZ-I modulado em pinos do conector **PMOD JA** da
Basys 3 e o observa no software **Digilent WaveForms** com a placa
**Digilent Analog Discovery 3**, que faz o papel do osciloscópio. O
PMOD entrega quatro canais correlatos para depuração simultânea: o
próprio sinal modulado, o *clock* lento *gated*, o pulso de *start* e o
estado da FSM `ligado`.

## O que este extra implementa e por quê

Mesma motivação do extra equivalente no projeto NRZ-L: observar a forma
de onda real (níveis de tensão e transições) e correlacioná-la com o
clock da transmissão, o pulso de *start* e o estado da FSM. No NRZ-I, a
observação é particularmente útil para evidenciar a regra de transição
(transita em `1`, mantém em `0`).

O sinal vem do mesmo `nrz_signal` que alimenta o LED 0 e o controlador
VGA. Não há circuito de saída separado: aproveita-se o `Top_Module` e a
constraint do PMOD JA.

## Estrutura desta pasta

```
pmod_osciloscopio/
|-- README.md                       Este arquivo
|-- src/                            (sem fontes adicionais — reaproveita
|                                    src/ do projeto NRZ-I)
|-- constraints/                    (sem constraints adicionais — reaproveita
|                                    constraints/basys3_constraints.xdc)
`-- docs/
    |-- tutorial_pmod.md            Passo a passo da medição com WaveForms + AD3
    `-- midia/                      Capturas de tela do WaveForms
```

> Os fontes e constraints do PMOD já estão integrados ao projeto NRZ-I
> principal (`src/Top_Module.vhd` e `constraints/basys3_constraints.xdc`).

## Equipamentos e software necessários

- Placa **Digilent Basys 3** programada com o *bitstream* do NRZ-I.
- **Digilent Analog Discovery 3** com cabo de pontas (*flywires* MTE).
- **Digilent WaveForms** (versão 3.x ou superior).
- **Adaptador / fios** PMOD para conectar o AD3 ao PMOD JA da Basys 3.

## Mapeamento PMOD JA

| Pino PMOD JA | Sinal no `Top_Module`  | Significado físico                |
| :----------: | ---------------------- | --------------------------------- |
| JA1          | `pmod_ja[0]` = `nrz_signal` | Sinal NRZ-I modulado          |
| JA2          | `pmod_ja[1]` = `clk_gated`  | Clock lento de transmissão    |
| JA3          | `pmod_ja[2]` = `start`      | Botão direito (pulso de partida) |
| JA4          | `pmod_ja[3]` = `ligado`     | Estado da FSM Start/Reset     |

Pinos físicos no `basys3_constraints.xdc`:
`JA1 = J1`, `JA2 = L2`, `JA3 = J2`, `JA4 = G2`. O *ground* do PMOD JA
deve ser ligado ao GND da Analog Discovery 3.

## Como reproduzir

Seguir o [tutorial detalhado](./docs/tutorial_pmod.md).

![PLACEHOLDER: foto da Basys 3 conectada ao Analog Discovery 3 pelo PMOD JA](docs/midia/pmod_conexao_basys3_ad3.jpg)

## Próximo passo

Ver as capturas e o passo a passo completo em
[docs/tutorial_pmod.md](./docs/tutorial_pmod.md).
