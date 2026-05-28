# Tutorial — Saída VGA com cores pulsantes (NRZ-I)

Este tutorial mostra como gerar e validar a saída VGA da Basys 3 com a
tela inteira mudando de cor conforme o sinal `nrz_signal` do projeto
NRZ-I.

## 1. Pré-requisitos

- AMD Vivado 2025.2.
- Placa **Digilent Basys 3**.
- **Monitor com entrada VGA** (ou adaptador compatível com 640×480 @
  60 Hz).
- Cabo VGA macho-macho.
- Projeto NRZ-I (`nrz_i/vivado_project/NRZ_I.xpr`) aberto, com
  `Top_Module` como *top*.

## 2. IP Clocking Wizard (`clk_wiz_vga`)

O controlador VGA exige uma frequência de pixel próxima de 25 MHz. O
projeto utiliza o **Clocking Wizard** instanciado no `Top_Module` como
`clk_wiz_vga`. A configuração adotada é:

1. **IP Catalog** → **Clocking Wizard**.
2. **Clocking Options**:
   - *Primitive*: `Auto`.
   - *Primary Input Clock*: 100 MHz.
3. **Output Clocks**:
   - *clk_out1* → **Requested Output Freq: 25,175 MHz**.
4. **Optional Inputs / Outputs**:
   - **Remover** as portas **`Reset`** e **`Locked`**.
5. Confirmar o nome do componente como **`clk_wiz_vga`** (usado pelo
   `Top_Module.vhd`).
6. **OK** → **Generate**.

A frequência **25,175 MHz** é a oficial VESA para 640×480 @ 60 Hz. O
valor "redondo" de 25 MHz pode não ser reconhecido por monitores
modernos (como o de teste, com resolução nativa 1920×1080); o uso do
Clocking Wizard libera o valor correto da especificação.

![PLACEHOLDER: print do Clocking Wizard com Requested Freq=25.175 MHz](midia/vga_clkwiz_config.png)

## 3. Síntese, implementação e bitstream

Seguir o [tutorial de gravação na placa](../../../docs/tutorial_placa.md)
do projeto NRZ-I.

## 4. Conexão do monitor

1. Desligar a Basys 3 antes da conexão.
2. Conectar o cabo VGA ao conector VGA da placa.
3. Ligar o monitor e a placa.

![PLACEHOLDER: foto da Basys 3 conectada ao monitor VGA](midia/vga_setup.jpg)

## 5. Operação

1. Posicionar os 16 *switches* na sequência de teste
   `1010110010011101`.
2. Pressionar **Reset** — a tela passa a exibir azul
   (`nrz_signal = '0'` enquanto `ligado = '0'` e o gate de reset força
   `nrz_out = '0'`).
3. Pressionar **Start** — a tela passa a alternar conforme a sequência
   **NRZ-I**:

   | Nível NRZ-I  | Cor de tela cheia |
   | :----------: | :---------------: |
   | `'1'`        | **Vermelho** (R=`1111`, G=`0`, B=`0`) |
   | `'0'`        | **Azul** (R=`0`, G=`0`, B=`1111`)     |

4. Cada cor permanece por ≈ 1 segundo (intervalo de um bit). Diferente
   do NRZ-L, **sequências de `0` na entrada mantêm a cor anterior** e
   **sequências de `1` na entrada alternam a cor a cada bit**.

   Exemplo: para a sequência `1010110010011101` da entrada, a tela
   exibe (em ordem MSB → LSB, cor de cada intervalo de 1 s):

   `vermelho, vermelho, azul, azul, vermelho, azul, azul, azul,
    vermelho, vermelho, vermelho, azul, vermelho, azul, azul,
    vermelho`.

![PLACEHOLDER: foto da tela vermelha (nível alto) durante a transmissão](midia/vga_tela_vermelha.jpg)

![PLACEHOLDER: foto da tela azul (nível baixo) durante a transmissão](midia/vga_tela_azul.jpg)

![PLACEHOLDER: vídeo curto da tela alternando vermelho/azul](midia/vga_pulsante.mp4)

## 6. Solução de problemas

- **Tela "Sem sinal" / *Out of range***: verificar a frequência do IP
  (25,175 MHz) e os pinos VGA no `.xdc`. Alguns monitores rejeitam
  640×480 @ 60 Hz em adaptadores ativos VGA → HDMI.
- **Imagem tremida**: confirmar que o gerador de clock está com
  *Optional Ports* `Reset`/`Locked` removidas.
- **Cor errada**: rever o bloco `process(video_on, nrz_signal)` do
  `Top_Module.vhd`. No projeto NRZ-I, os comentários do fonte já
  correspondem ao comportamento real (`vermelho` para `'1'`, `azul`
  para `'0'`).
