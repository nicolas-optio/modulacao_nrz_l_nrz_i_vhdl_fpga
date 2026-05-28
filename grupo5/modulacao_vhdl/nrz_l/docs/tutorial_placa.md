# Tutorial — Gravação na Basys 3 (NRZ-L)

Este tutorial mostra o fluxo completo de **síntese → implementação →
geração do *bitstream* → gravação na placa Basys 3**, partindo do projeto
Vivado já pronto. O *top* sintetizado é o `Top_Module`, que integra o
módulo `NRZ_L` à placa (divisor de clock, controle `start/reset`, saída
em LEDs, PMOD JA e VGA).

## 1. Pré-requisitos

- AMD Vivado 2025.2 instalado, com suporte à família Artix-7.
- Placa **Digilent Basys 3** (FPGA `xc7a35tcpg236-1`).
- Cabo **micro-USB** para alimentação e programação da placa.
- Drivers Digilent (Adept) instalados.
- Projeto `nrz_l/vivado_project/NRZ_L.xpr` aberto, com `Top_Module`
  definido como *top* da síntese.

> Para a saída VGA, o projeto depende do IP **`clk_wiz_vga`**
> (Clocking Wizard) já gerado no projeto Vivado, com *Reset* e *Locked*
> removidos e *Requested Frequency* de **25,175 MHz**. Ele deve aparecer
> em `Sources` → `IP Sources` e estar marcado como **OOC Synthesized**.

## 2. Definir `Top_Module` como *top* de síntese

1. No painel **Sources** → **Design Sources**, clicar com o botão direito
   em `Top_Module` → **Set as Top**.
2. Verificar que o `NRZ_L` aparece como sub-instância (`meu_nrz_inst`)
   sob o `Top_Module`.

![PLACEHOLDER: print do Sources com Top_Module definido como top](midia/placa_top_module.png)

## 3. Síntese

1. No **Flow Navigator**, clicar em **Run Synthesis**.
2. Aguardar a conclusão e, na janela de diálogo final, escolher **Open
   Synthesized Design** ou simplesmente **Cancel** para avançar à
   implementação.

> O `Top_Module` declara `clk_gated` como rede que precisa de tratamento
> especial. As linhas
> `set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_gated]` e
> `create_clock -period 100000000.00 -name clk_gated [get_nets clk_gated]`
> presentes no `basys3_constraints.xdc` resolvem a regra de roteamento
> dedicado e o cálculo de timing dessa rede.

## 4. Implementação

1. No **Flow Navigator**, clicar em **Run Implementation**.
2. Aguardar e, na janela final, escolher **Cancel** para avançar à
   geração do *bitstream*.

![PLACEHOLDER: print da janela de Implementation completa](midia/placa_implementation_ok.png)

## 5. Geração do *bitstream*

1. No **Flow Navigator**, clicar em **Generate Bitstream**.
2. Ao final, na janela de diálogo, escolher **Open Hardware Manager**.

## 6. Conexão da placa e *Program Device*

1. Conectar o cabo micro-USB do PC à porta **PROG/USB** da Basys 3.
2. Ligar a placa pelo *switch* `POWER` (canto superior direito).
3. No Vivado, dentro do **Hardware Manager**, clicar em **Open Target**
   → **Auto Connect**. O dispositivo `xc7a35t_0` aparece na árvore.
4. Clicar com o botão direito em `xc7a35t_0` → **Program Device** →
   selecionar o `.bit` gerado (em
   `NRZ_L.runs/impl_1/Top_Module.bit`) → **Program**.

![PLACEHOLDER: foto da Basys 3 ligada com cabo micro-USB conectado](midia/placa_basys3_conectada.jpg)

## 7. Mapeamento de uso na placa

Conferido em `constraints/basys3_constraints.xdc`. A nomenclatura
**LD0, LD1 …** segue a serigrafia da Basys 3 (LD0 é o LED mais à direita).

| Função                          | Recurso físico             | Pinos                                |
| ------------------------------- | -------------------------- | ------------------------------------ |
| Clock principal (100 MHz)       | Oscilador interno          | `W5`                                 |
| Reset                           | Botão central (`BTNC`)     | `U18`                                |
| Start                           | Botão direito (`BTNR`)     | `T17`                                |
| Entrada de dados `data_in[15:0]`| 16 *switches* SW0–SW15     | `V17, V16, W16, W17, W15, V15, W14, W13, V2, T3, T2, R3, W2, U1, T1, R2` |
| Saída `nrz_out`                 | LED 0 (LD0)                | `U16`                                |
| Índice `bit_idx[3:0]`           | LEDs LD1–LD4               | `E19, U19, V19, W18`                 |
| Saída PMOD `pmod_ja[3:0]`       | PMOD JA, pinos JA1–JA4     | `J1, L2, J2, G2`                     |
| Sincronismo VGA                 | Conector VGA               | `vga_hsync = P19, vga_vsync = R19`   |
| Cores VGA (4 bits cada)         | Conector VGA               | `vga_red[3:0] = G19,H19,J19,N19`;<br>`vga_green[3:0] = J17,H17,G17,D17`;<br>`vga_blue[3:0] = N18,L18,K18,J18` |

Detalhes importantes do `Top_Module`:

- O `Top_Module` divide o clock de 100 MHz por meio de um contador que
  conta até 4 999 999 e inverte `clk_slow` ao chegar nesse valor, gerando
  um *clock lento* de aproximadamente **10 Hz** (período ≈ 100 ms). Com
  `CYCLES_PER_BIT = 10`, cada bit fica visível por aproximadamente
  **1 segundo** nos LEDs.
- O sinal `clk_gated = clk_slow AND ligado` só permite a transmissão
  depois de o usuário pressionar `start`. `reset` zera `ligado` de volta
  para `0` (transmissão parada).
- A saída `nrz_out` da modulação é enviada simultaneamente a
  **LD0**, ao **PMOD JA1** e ao **controlador VGA** (cor de tela cheia).

## 8. Como testar

1. Posicionar os 16 *switches* na sequência desejada. Para a sequência
   de referência `"1010110010011101"` (MSB → LSB), ajustar:

   | Switch    | SW15 | SW14 | SW13 | SW12 | SW11 | SW10 | SW9 | SW8 | SW7 | SW6 | SW5 | SW4 | SW3 | SW2 | SW1 | SW0 |
   | --------- | :--: | :--: | :--: | :--: | :--: | :--: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
   | Bit       | 1    | 0    | 1    | 0    | 1    | 1    | 0   | 0   | 1   | 0   | 0   | 1   | 1   | 1   | 0   | 1   |
   | Posição   | up   | down | up   | down | up   | up   | down| down| up  | down| down| up  | up  | up  | down| up  |

2. Pressionar o **botão central** (`reset`) para garantir estado
   inicial. Os LEDs LD1–LD4 ficam todos acesos enquanto o reset está
   ativo (índice inicial = 15 = `1111`).
3. Pressionar o **botão direito** (`start`) para iniciar a transmissão.
   Não há botão de pausa; o reset (botão central) interrompe e zera.
4. Observar a evolução:
   - **LD0** acompanha o sinal modulado (aceso quando `nrz_out = '1'`).
   - **LD1–LD4** mostram, em binário, o índice corrente do bit. A
     correspondência é `bit_idx[0]` → LD1, `bit_idx[1]` → LD2,
     `bit_idx[2]` → LD3, `bit_idx[3]` → LD4. Exemplos:

     | bit_idx | LD4 | LD3 | LD2 | LD1 |
     | :----:  | :-: | :-: | :-: | :-: |
     | 15 (`1111`) | aceso | aceso | aceso | aceso |
     | 10 (`1010`) | aceso | apagado | aceso | apagado |
     | 5  (`0101`) | apagado | aceso | apagado | aceso |
     | 0  (`0000`) | apagado | apagado | apagado | apagado |
5. Alterar a sequência nos *switches* a qualquer momento: o sinal
   modulado responde imediatamente ao novo `data_in` (sem necessidade de
   regravar a placa).

![PLACEHOLDER: foto da Basys 3 transmitindo o NRZ-L com o índice nos LEDs](midia/placa_basys3_transmitindo.jpg)

![PLACEHOLDER: foto detalhe dos LEDs LD0–LD4 durante a sequência](midia/placa_leds_indice.jpg)

## 9. Extras

- [Saída no PMOD para o Analog Discovery 3](../extras/pmod_osciloscopio/docs/tutorial_pmod.md)
- [Saída VGA com cores pulsantes](../extras/vga/docs/tutorial_vga.md)

## Próximo passo

Concluída a gravação na placa, seguir para o projeto
[NRZ-I](../../nrz_i/).
