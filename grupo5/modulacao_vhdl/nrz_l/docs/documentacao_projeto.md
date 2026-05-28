# Documentação Técnica — Modulação NRZ-L

Referência técnica do projeto NRZ-L. Descreve como o circuito funciona
internamente em dois níveis: o **módulo de modulação `NRZ_L`** (núcleo
do projeto) e o ***wrapper* de placa `Top_Module`**, que integra o
módulo à Basys 3 e fornece divisor de clock, controle de *start/reset*,
saída no PMOD JA e controlador VGA.

## 1. Visão geral

O `NRZ_L` é um modulador Unipolar **Non-Return-to-Zero — Level**: o nível
do pulso durante todo o intervalo de bit representa o próprio bit
(`1` → nível alto; `0` → nível baixo). Não há memória de estado — a saída
no instante atual depende exclusivamente do bit atual. O módulo varre o
vetor `data_in[15:0]` do MSB ao LSB, mantendo cada bit ativo por
`CYCLES_PER_BIT` ciclos do `clk` recebido.

O `Top_Module` envolve o `NRZ_L` para uso na placa Basys 3, gerando um
clock lento de transmissão (≈ 10 Hz) a partir dos 100 MHz da placa,
travando o início pelo botão `start`, e replicando a saída modulada em
LED, PMOD JA e VGA (cor de tela cheia).

## 2. Diagrama de blocos

### 2.1 Módulo `NRZ_L`

```
                  +-----------------------+
   clk    ------->|                       |
   reset  ------->|  Contador de ciclos   |
                  |  (0 .. CYCLES_PER_BIT |
                  |       - 1)            |
                  +-----------+-----------+
                              | (transbordo)
                              v
                  +-----------------------+
                  |  Contador de bits     |
                  |  bit_index (15 -> 0)  |
                  +-----------+-----------+
                              | bit_idx
                              +-------------> bit_idx (saída)
                              |
                              v
   data_in[15:0] ---> [ MUX bit_index ] ---> current_bit ---> nrz_out
```

### 2.2 *Top_Module* (placa)

```
   clk (100 MHz) -+-> [ clk_wiz_vga (IP) ] --> clk_25MHz --> [ VGA 640x480@60Hz ]
                  |                                                    |
                  +-> [ Divisor /5_000_000 ] --> clk_slow (~10 Hz)      |
                                                       |               |
   start ----------> [ FSM Start/Reset ] --> ligado --+ |               |
   reset ----------------/                            v v               |
                                              clk_gated = clk_slow AND ligado
                                                       |               |
                            +--------- NRZ_L -----+    |                |
   data_in[15:0] ---------->| clk=clk_gated       |<---+                |
   reset --------+--------->| reset=reset         |                     |
                 |          | data_in=data_in     |                     |
                 |          +--------+------------+                     |
                 |                   | nrz_signal                       |
                 |                   +--> LD0 (nrz_out)                 |
                 |                   +--> PMOD JA1 (pmod_ja[0])         |
                 |                   +--> Cor VGA (vermelho/azul) ------+
                 |
                 +-> bit_idx[3:0] --> LD1..LD4
                 +-> clk_gated   --> PMOD JA2
                 +-> start       --> PMOD JA3
                 +-> ligado      --> PMOD JA4
```

## 3. Interface — `NRZ_L`

| Porta     | Direção | Tipo                                       | Função                                                                              |
| --------- | :-----: | ------------------------------------------ | ----------------------------------------------------------------------------------- |
| `clk`     | in      | `std_logic`                                | Clock de transmissão (na placa, `clk_gated` ≈ 10 Hz; em simulação, 100 MHz).        |
| `reset`   | in      | `std_logic`                                | Reset síncrono ativo alto. Zera `cycle_count`, força `bit_index = DATA_WIDTH-1` e `current_bit = '0'`. |
| `data_in` | in      | `std_logic_vector(DATA_WIDTH-1 downto 0)`  | Vetor de bits a modular (`switches` na placa).                                       |
| `nrz_out` | out     | `std_logic`                                | Sinal modulado. Reproduz o bit corrente de `data_in`.                               |
| `bit_idx` | out     | `integer range 0 to DATA_WIDTH-1`          | Índice do bit em transmissão. Vai de `DATA_WIDTH-1` (15) até `0` e reinicia.        |

## 4. Interface — `Top_Module`

| Porta            | Direção | Tipo                                       | Função / mapeamento físico                                          |
| ---------------- | :-----: | ------------------------------------------ | ------------------------------------------------------------------- |
| `clk`            | in      | `std_logic`                                | Clock de 100 MHz da Basys 3 (pino `W5`).                            |
| `reset`          | in      | `std_logic`                                | Botão central da placa (`BTNC`, pino `U18`).                        |
| `start`          | in      | `std_logic`                                | Botão direito da placa (`BTNR`, pino `T17`).                        |
| `data_in[15:0]`  | in      | `std_logic_vector(15 downto 0)`            | 16 *switches* SW0–SW15.                                             |
| `nrz_out`        | out     | `std_logic`                                | LED 0 (`LD0`, pino `U16`).                                          |
| `bit_idx[3:0]`   | out     | `integer range 0 to 15`                    | LEDs LD1–LD4 (pinos `E19, U19, V19, W18`).                          |
| `pmod_ja[3:0]`   | out     | `std_logic_vector(3 downto 0)`             | PMOD JA pinos JA1–JA4 (pinos `J1, L2, J2, G2`).                     |
| `vga_hsync`      | out     | `std_logic`                                | Sincronismo horizontal VGA (pino `P19`).                            |
| `vga_vsync`      | out     | `std_logic`                                | Sincronismo vertical VGA (pino `R19`).                              |
| `vga_red[3:0]`   | out     | `std_logic_vector(3 downto 0)`             | Componente vermelho do VGA (pinos `G19, H19, J19, N19`).            |
| `vga_green[3:0]` | out     | `std_logic_vector(3 downto 0)`             | Componente verde do VGA (pinos `J17, H17, G17, D17`).               |
| `vga_blue[3:0]`  | out     | `std_logic_vector(3 downto 0)`             | Componente azul do VGA (pinos `N18, L18, K18, J18`).                |

## 5. *Generics*

| Generic           | Valor padrão | Função                                                                          |
| ----------------- | :----------: | ------------------------------------------------------------------------------- |
| `DATA_WIDTH`      | `16`         | Largura do vetor de entrada. Alinhado aos 16 *switches* da Basys 3.             |
| `CYCLES_PER_BIT`  | `10`         | Número de ciclos do `clk` recebido durante o qual cada bit é sustentado.        |

> O `Top_Module` instancia o `NRZ_L` com os mesmos valores
> (`generic map (DATA_WIDTH => 16, CYCLES_PER_BIT => 10)`).

## 6. Funcionamento interno

### 6.1 Módulo `NRZ_L`

O módulo é puramente sequencial — um único `process(clk)` síncrono pela
borda de subida. Três sinais internos coordenam a operação:

- `cycle_count : integer range 0 to CYCLES_PER_BIT-1` — conta os ciclos
  de clock dentro de um mesmo bit.
- `bit_index   : integer range 0 to DATA_WIDTH-1` — aponta para o bit
  corrente no vetor `data_in`. Começa em `DATA_WIDTH-1` (15) e
  decrementa.
- `current_bit : std_logic` — registra o bit atual para apresentação em
  `nrz_out`.

Regra de operação a cada borda de subida de `clk`:

1. Se `reset = '1'`, todos os sinais voltam ao estado inicial.
2. Caso contrário, `current_bit` recebe `data_in(bit_index)` (captura o
   bit corrente). Em seguida:
   - Se `cycle_count = CYCLES_PER_BIT-1`, o intervalo do bit terminou:
     `cycle_count` volta a `0` e `bit_index` decrementa. Se `bit_index`
     era `0`, retorna a `DATA_WIDTH-1` (varredura cíclica).
   - Caso contrário, `cycle_count` apenas incrementa.

Saídas combinacionais:

- `nrz_out <= current_bit;`
- `bit_idx <= bit_index;`

### 6.2 `Top_Module`

O `Top_Module` adiciona, ao redor do `NRZ_L`, quatro blocos:

1. **Divisor de clock** (`process(clk)`). Conta de `0` a `4 999 999` e
   inverte `clk_slow` quando atinge o valor de fim. Com `clk = 100 MHz`,
   `clk_slow` tem período ≈ 100 ms (≈ 10 Hz). Com `CYCLES_PER_BIT = 10`,
   cada bit fica visível por aproximadamente **1 segundo** nos LEDs.

2. **FSM Start/Reset** (`process(clk_slow, reset)`). O registro `ligado`
   começa em `'0'`. Se `reset = '1'`, `ligado` volta a `'0'`. Caso
   contrário, na borda de subida de `clk_slow`, `start = '1'` arma
   `ligado` para `'1'`. A transmissão só ocorre quando `ligado = '1'`.

3. **Gating do clock**. `clk_gated <= clk_slow AND ligado`. Esse é o
   clock entregue ao `NRZ_L`. O `basys3_constraints.xdc` aplica
   `set_property CLOCK_DEDICATED_ROUTE FALSE` e
   `create_clock` na rede `clk_gated` para informar o Vivado da natureza
   especial dessa rede.

4. **Controlador VGA 640×480 @ 60 Hz** (`process(clk_25MHz)`). Contadores
   `h_cnt` (0–799) e `v_cnt` (0–524) geram a temporização padrão VESA.
   - `vga_hsync = '0'` quando `656 ≤ h_cnt < 752`;
   - `vga_vsync = '0'` quando `490 ≤ v_cnt < 492`;
   - `video_on = '1'` na área visível (`h_cnt < 640 AND v_cnt < 480`).

   A cor de tela cheia é definida em função de `nrz_signal`:

   | `nrz_signal` | `vga_red` | `vga_green` | `vga_blue` | Cor       |
   | :----------: | :-------: | :---------: | :--------: | :-------: |
   | `'1'`        | `1111`    | `0000`      | `0000`     | Vermelho  |
   | `'0'`        | `0000`    | `0000`      | `1111`     | Azul      |
   | (`video_on = 0`) | `0000` | `0000`   | `0000`     | Preto (*blanking*) |

   > **Atenção:** os comentários no fonte do `Top_Module.vhd` mencionam
   > "Tela Verde" e "Tela Preta" no bloco de cores. O comportamento real
   > implementado é o descrito na tabela acima (vermelho / azul). A
   > documentação reflete o comportamento real do circuito.

### 6.3 Saída no PMOD JA

| Pino | Sinal           | Origem                               |
| :--: | --------------- | ------------------------------------ |
| JA1  | `pmod_ja[0]`    | `nrz_signal` (saída modulada)        |
| JA2  | `pmod_ja[1]`    | `clk_gated` (clock lento da transmissão) |
| JA3  | `pmod_ja[2]`    | `start` (botão direito)              |
| JA4  | `pmod_ja[3]`    | `ligado` (estado da FSM Start/Reset) |

Esses pinos alimentam o Analog Discovery 3 conectado pelo PMOD JA — ver
[extras/pmod_osciloscopio/](../extras/pmod_osciloscopio/).

## 7. Mapeamento físico (resumo)

| Recurso                    | Pinos Basys 3                                            |
| -------------------------- | -------------------------------------------------------- |
| Clock 100 MHz              | `W5`                                                     |
| Botão central (reset)      | `U18`                                                    |
| Botão direito (start)      | `T17`                                                    |
| Switches `data_in[15:0]`   | `V17, V16, W16, W17, W15, V15, W14, W13, V2, T3, T2, R3, W2, U1, T1, R2` |
| LED 0 (`nrz_out`)          | `U16`                                                    |
| LEDs 1–4 (`bit_idx[3:0]`)  | `E19, U19, V19, W18`                                     |
| PMOD JA 1–4                | `J1, L2, J2, G2`                                         |
| VGA hsync / vsync          | `P19 / R19`                                              |
| VGA `red[3:0]`             | `G19, H19, J19, N19`                                     |
| VGA `green[3:0]`           | `J17, H17, G17, D17`                                     |
| VGA `blue[3:0]`            | `N18, L18, K18, J18`                                     |

## 8. Dependências e ambiente

- **Ferramenta:** AMD Vivado 2025.2.
- **Placa-alvo:** Digilent Basys 3 — FPGA Artix-7 `xc7a35tcpg236-1`.
- **Bibliotecas VHDL:** `IEEE.STD_LOGIC_1164.ALL` e `IEEE.NUMERIC_STD.ALL`.
- **IP instanciado:** `clk_wiz_vga` (Clocking Wizard). Configuração:
  - Entrada `clk_in1` = clock de placa 100 MHz;
  - Saída `clk_out1` = **25,175 MHz** (frequência VESA oficial para
    640×480 @ 60 Hz);
  - Portas `Reset` e `Locked` removidas da interface do IP.
- O projeto Vivado contém também o IP `clk_wiz_0` no cache, porém **ele
  não é instanciado** pelo `Top_Module` e não é dependência do projeto.

## 9. Decisões de projeto

- **Varredura MSB → LSB**: facilita a leitura do índice nos LEDs LD1–LD4
  e produz uma ordem natural ao posicionar a sequência nos *switches*.
- **`CYCLES_PER_BIT` como *generic***: separa a duração do bit do
  período do clock. Permite ajustar o ritmo para simulação (rápido) e
  para a placa (lento, visualmente perceptível) sem alterar a lógica.
- **Divisor de clock para 10 Hz e *gating***: produz cada bit visível
  por ≈ 1 segundo nos LEDs; o *gating* por `ligado` evita transmissão
  involuntária ao ligar a placa.
- **Pré-codificação **não** necessária**: como NRZ-L é sem memória,
  basta um *registrador* em `current_bit` para evitar *glitches* na
  saída quando `bit_index` muda.

## 10. Referências

- Forouzan, B. A. *Data Communications and Networking*, 5ª ed. — capítulo
  sobre codificação digital banda base.
- Digilent. *Basys 3 FPGA Board Reference Manual*.
- AMD/Xilinx. *Clocking Wizard v6.0 Product Guide* (PG065).
- VESA. *VESA Display Monitor Timing (DMT) standard*, 640×480 @ 60 Hz.
