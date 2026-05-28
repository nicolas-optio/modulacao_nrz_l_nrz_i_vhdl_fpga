# Extra — Saída pelo PMOD (Analog Discovery 3)

Disponibiliza o sinal NRZ-L modulado em pinos do conector **PMOD JA** da
Basys 3 e o observa no software **Digilent WaveForms** com a placa
**Digilent Analog Discovery 3**, que faz o papel do osciloscópio. O
PMOD entrega quatro canais correlatos para depuração simultânea: o
próprio sinal modulado, o *clock* lento *gated*, o pulso de *start* e o
estado da FSM `ligado`.

## O que este extra implementa e por quê

O sinal modulado é gerado dentro da FPGA em tempo real (≈ 1 segundo por
bit). Observá-lo no PMOD permite:

- Validar o comportamento da modulação fora dos LEDs (níveis de tensão e
  forma de onda real, não apenas piscar visual).
- Correlacionar o sinal de dados com o *clock* da transmissão, o pulso
  de *start* e o estado da FSM — útil para diagnosticar problemas no
  *gating* e na partida.

O sinal vem do mesmo `nrz_signal` que alimenta o LED 0 e o controlador
VGA. Não há circuito de saída separado: aproveita-se o `Top_Module` e a
constraint do PMOD JA.

## Estrutura desta pasta

```
pmod_osciloscopio/
|-- README.md                       Este arquivo
|-- src/                            (sem fontes adicionais — reaproveita
|                                    src/ do projeto NRZ-L)
|-- constraints/                    (sem constraints adicionais — reaproveita
|                                    constraints/basys3_constraints.xdc)
`-- docs/
    |-- tutorial_pmod.md            Passo a passo da medição com WaveForms + AD3
    `-- midia/                      Capturas de tela do WaveForms
```

> Os fontes e constraints do PMOD já estão integrados ao projeto NRZ-L
> principal (`src/Top_Module.vhd` e `constraints/basys3_constraints.xdc`).
> Esta pasta serve apenas para documentar o procedimento de medição.

## Equipamentos e software necessários

- Placa **Digilent Basys 3** programada com o *bitstream* do NRZ-L
  (`Top_Module` como *top*).
- **Digilent Analog Discovery 3** com cabo de pontas (*flywires* MTE).
- **Digilent WaveForms** (versão 3.x ou superior) instalado.
- **Adaptador / fios** PMOD para conectar AD3 ao PMOD JA da Basys 3.

## Mapeamento PMOD JA

| Pino PMOD JA | Sinal no `Top_Module`  | Significado físico                |
| :----------: | ---------------------- | --------------------------------- |
| JA1          | `pmod_ja[0]` = `nrz_signal` | Sinal NRZ-L modulado          |
| JA2          | `pmod_ja[1]` = `clk_gated`  | Clock lento de transmissão (≈ 10 Hz, ativo só após `start`) |
| JA3          | `pmod_ja[2]` = `start`      | Botão direito (pulso de partida) |
| JA4          | `pmod_ja[3]` = `ligado`     | Estado da FSM (`'1'` enquanto transmite) |

Pinos físicos no `basys3_constraints.xdc`:
`JA1 = J1`, `JA2 = L2`, `JA3 = J2`, `JA4 = G2`. O *ground* do PMOD JA
(pino 5) deve ser ligado ao GND da Analog Discovery 3.

## Como reproduzir

Seguir o [tutorial detalhado](./docs/tutorial_pmod.md), que descreve:

1. Conexão física do AD3 ao PMOD JA da Basys 3;
2. Gravação do *bitstream* na placa;
3. Configuração do WaveForms (Scope) — canais, escala vertical (3,3 V),
   escala horizontal (≈ 200 ms/div) e *trigger* na borda de subida do
   canal 3 (start);
4. Captura da forma de onda da sequência completa para os dois projetos
   (NRZ-L e NRZ-I).

![PLACEHOLDER: foto da Basys 3 conectada ao Analog Discovery 3 pelo PMOD JA](docs/midia/pmod_conexao_basys3_ad3.jpg)

## Próximo passo

Ver as capturas e o passo a passo completo em
[docs/tutorial_pmod.md](./docs/tutorial_pmod.md).
