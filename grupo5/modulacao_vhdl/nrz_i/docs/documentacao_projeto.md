# Documentação Técnica — Modulação NRZ-I

Referência técnica do projeto NRZ-I. Descreve como o circuito funciona
internamente em dois níveis: o **módulo de modulação `NRZ_I`** e o
***wrapper* de placa `Top_Module`** (idêntico em estrutura ao do projeto
NRZ-L, alterando somente a instância do módulo de modulação).

## 1. Visão geral

O `NRZ_I` é um modulador Unipolar **Non-Return-to-Zero — Inverted**: o
bit é representado pela **transição** do pulso no início do intervalo
de bit. `1` inverte o nível em relação ao bit anterior; `0` mantém o
nível anterior. Diferente do NRZ-L, a saída depende do nível
imediatamente anterior — exige memória de estado.

A implementação adota **pré-codificação combinacional por cascata de
XOR** (`generate`), equivalente a um *flip-flop* com realimentação e
mais robusta na simulação. Um processo síncrono varre `bit_index` de
`15 → 0` exibindo o bit codificado correspondente.

O `Top_Module` instancia o `NRZ_I` na Basys 3 com as mesmas
funcionalidades do *wrapper* do NRZ-L: divisor de clock ≈ 10 Hz, FSM
`start/ligado`, espelhamento da saída em LED, PMOD JA e controlador VGA
de tela cheia.

## 2. Diagrama de blocos

### 2.1 Módulo `NRZ_I`

```
                +---------------------------------------+
                |   Pré-codificação XOR (combinacional) |
                |                                       |
   data_in[15] -> XOR <- '0'                            |
                  |  -> encoded[15]                     |
   data_in[14] -> XOR <- encoded[15]                    |
                  |  -> encoded[14]                     |
   data_in[13] -> XOR <- encoded[14]                    |
                  |  -> encoded[13]                     |
                ... (gen_encode: for i in 14 downto 0)  |
   data_in[0]  -> XOR <- encoded[1]                     |
                  |  -> encoded[0]                      |
                +---------------------------------------+
                                |
                                v
   clk    -----+        +-------+---------+
   reset  ---+ |        |  MUX (bit_index)|
             | +------> |                 |--> nrz_out
             |          +-------+---------+      (com gate de reset)
             |                  ^
             v                  |
   +-----------------------+    |
   |  Contador de ciclos   |    |
   |  +                    |    |
   |  Contador de bits     |----+
   |  bit_index (15 -> 0)  +-------> bit_idx (saída)
   +-----------------------+
```

### 2.2 *Top_Module* (placa)

```
   clk (100 MHz) -+-> [ clk_wiz_vga (IP) ] --> clk_25MHz --> [ VGA 640x480@60Hz ]
                  |                                                     |
                  +-> [ Divisor /5_000_000 ] --> clk_slow (~10 Hz)       |
                                                       |                |
   start ----------> [ FSM Start/Reset ] --> ligado --+ |                |
   reset ----------------/                            v v                |
                                              clk_gated = clk_slow AND ligado
                                                       |                |
                            +--------- NRZ_I -----+    |                |
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

## 3. Interface — `NRZ_I`

| Porta     | Direção | Tipo                                       | Função                                                                                |
| --------- | :-----: | ------------------------------------------ | ------------------------------------------------------------------------------------- |
| `clk`     | in      | `std_logic`                                | Clock de transmissão (na placa, `clk_gated` ≈ 10 Hz; em simulação, 100 MHz).          |
| `reset`   | in      | `std_logic`                                | Reset síncrono ativo alto. Zera `cycle_count` e força `bit_index = DATA_WIDTH-1`. Quando ativo, força `nrz_out = '0'`. |
| `data_in` | in      | `std_logic_vector(DATA_WIDTH-1 downto 0)`  | Vetor de bits a modular (*switches* na placa).                                        |
| `nrz_out` | out     | `std_logic`                                | Sinal modulado em NRZ-I. Fora do reset, `nrz_out = encoded(bit_index)`.               |
| `bit_idx` | out     | `integer range 0 to DATA_WIDTH-1`          | Índice do bit em transmissão. Vai de `DATA_WIDTH-1` (15) até `0` e reinicia.          |

## 4. Interface — `Top_Module`

Mesma interface do `Top_Module` do NRZ-L. O *wrapper* não distingue qual
módulo de modulação está instanciado — apenas a instância interna muda
(`meu_nrzi_inst : entity work.NRZ_I`).

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

O `Top_Module` instancia o `NRZ_I` com os mesmos valores
(`generic map (DATA_WIDTH => 16, CYCLES_PER_BIT => 10)`).

## 6. Funcionamento interno

### 6.1 Pré-codificação XOR (combinacional)

O bloco principal do NRZ-I é uma **cascata de XORs declarada com
`generate`**:

```vhdl
encoded(DATA_WIDTH-1) <= '0' XOR data_in(DATA_WIDTH-1);

gen_encode: for i in DATA_WIDTH-2 downto 0 generate
    encoded(i) <= encoded(i+1) XOR data_in(i);
end generate;
```

Lê-se: o bit codificado da posição `i` é o XOR entre o bit codificado da
posição imediatamente superior (`i+1`) e o bit de entrada da própria
posição. Como a varredura começa do MSB (15) e o nível inicial assumido
é `'0'`, a cascata é equivalente, ponto a ponto, à regra clássica do
NRZ-I:

| `data_in(i)` | `encoded(i)` (regra prática)             |
| :----------: | ---------------------------------------- |
| `'1'`        | inverte em relação a `encoded(i+1)`      |
| `'0'`        | igual a `encoded(i+1)`                   |

Como o bloco é **puramente combinacional**, qualquer mudança em
`data_in` reflete imediatamente em todas as posições de `encoded` — o
módulo responde em tempo real à troca dos *switches* na placa.

### 6.2 Varredura síncrona dos bits

O processo `seq_proc(clk)` mantém dois sinais internos:

- `cycle_count : integer range 0 to CYCLES_PER_BIT-1` — conta ciclos
  dentro do bit corrente.
- `bit_index   : integer range 0 to DATA_WIDTH-1` — começa em
  `DATA_WIDTH-1` (15) e decrementa.

A cada borda de subida de `clk`:

1. Se `reset = '1'`, ambos voltam ao estado inicial
   (`cycle_count = 0`, `bit_index = DATA_WIDTH-1`).
2. Caso contrário:
   - Se `cycle_count = CYCLES_PER_BIT-1`, o bit terminou: `cycle_count`
     volta a `0`; `bit_index` decrementa (volta a `DATA_WIDTH-1` quando
     era `0`).
   - Caso contrário, `cycle_count` apenas incrementa.

### 6.3 Saída

```vhdl
nrz_out <= '0' when reset = '1' else encoded(bit_index);
bit_idx <= bit_index;
```

Durante o reset, a saída é forçada a `'0'` (em vez de seguir um valor
indefinido). Fora do reset, é o bit codificado correspondente ao
índice atualmente apontado.

### 6.4 *Top_Module*

A lógica do `Top_Module` é idêntica à do projeto NRZ-L (ver
`nrz_l/docs/documentacao_projeto.md`, seção 6.2):

1. **Divisor de clock** (`process(clk)`) para gerar `clk_slow` ≈ 10 Hz.
2. **FSM Start/Reset** (`process(clk_slow, reset)`) que arma `ligado` em
   `'1'` no primeiro `start` após a inicialização.
3. **Gating** `clk_gated = clk_slow AND ligado`, entregue ao `NRZ_I`.
4. **Controlador VGA 640×480 @ 60 Hz** (`process(clk_25MHz)`) com
   `h_cnt 0–799`, `v_cnt 0–524` e pulsos `vga_hsync`/`vga_vsync` nos
   intervalos VESA. A cor de tela cheia é definida em função de
   `nrz_signal`:

   | `nrz_signal` | `vga_red` | `vga_green` | `vga_blue` | Cor       |
   | :----------: | :-------: | :---------: | :--------: | :-------: |
   | `'1'`        | `1111`    | `0000`      | `0000`     | Vermelho  |
   | `'0'`        | `0000`    | `0000`      | `1111`     | Azul      |
   | (`video_on = 0`) | `0000` | `0000`   | `0000`     | Preto (*blanking*) |

### 6.5 Saída no PMOD JA

| Pino | Sinal           | Origem                               |
| :--: | --------------- | ------------------------------------ |
| JA1  | `pmod_ja[0]`    | `nrz_signal` (saída NRZ-I)           |
| JA2  | `pmod_ja[1]`    | `clk_gated` (clock lento da transmissão) |
| JA3  | `pmod_ja[2]`    | `start` (botão direito)              |
| JA4  | `pmod_ja[3]`    | `ligado` (estado da FSM Start/Reset) |

## 7. Mapeamento físico (resumo)

Idêntico ao do NRZ-L (ver `constraints/basys3_constraints.xdc`):

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
- **IP instanciado:** `clk_wiz_vga` (Clocking Wizard) com saída de
  **25,175 MHz** (frequência VESA para 640×480 @ 60 Hz). Portas `Reset`
  e `Locked` removidas.

## 9. Decisões de projeto

- **Pré-codificação combinacional por XOR (com `generate`)** em vez de
  *flip-flop* explícito: produz o mesmo comportamento, é mais legível
  e responde imediatamente a mudanças em `data_in` durante a simulação.
- **`nrz_out` gated pelo `reset`**: garante saída em `'0'` durante o
  reset, sem expor um valor indefinido a quem observa a saída.
- **`clk_gated` para a placa**: cada bit fica visível por ≈ 1 segundo
  (`clk_slow` ≈ 10 Hz × `CYCLES_PER_BIT = 10`); o gating por `ligado`
  impede transmissão involuntária ao ligar a placa.

## 10. Referências

- Forouzan, B. A. *Data Communications and Networking*, 5ª ed. — capítulo
  sobre codificação digital banda base.
- Digilent. *Basys 3 FPGA Board Reference Manual*.
- AMD/Xilinx. *Clocking Wizard v6.0 Product Guide* (PG065).
- VESA. *VESA Display Monitor Timing (DMT) standard*, 640×480 @ 60 Hz.
