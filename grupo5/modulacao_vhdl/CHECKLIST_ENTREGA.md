# Checklist de Entrega — Modulação Digital em VHDL

Use este arquivo como guia final antes do *push* para o fork do grupo
(`viniciussbrg/modulacao_nrz_l_nrz_i_vhdl_fpga`). Marque cada item
conforme for concluído.

## 1. Arquivos `.md` que devem ser exportados para `.pdf`

O repositório oficial espera **PDFs** para tutoriais, documentação
técnica e relatório. Sugestão: exportar com Pandoc + LaTeX, ou abrir
no VS Code com a extensão *Markdown PDF*, ou usar `markdown-pdf`.
Manter o mesmo nome de arquivo, trocando apenas a extensão.

### NRZ-L

- [ ] `nrz_l/docs/tutorial_simulacao.md` → `tutorial_simulacao.pdf`
- [ ] `nrz_l/docs/tutorial_placa.md` → `tutorial_placa.pdf`
- [ ] `nrz_l/docs/documentacao_projeto.md` → `documentacao_projeto.pdf`
- [ ] `nrz_l/extras/pmod_osciloscopio/docs/tutorial_pmod.md` → `tutorial_pmod.pdf`
- [ ] `nrz_l/extras/vga/docs/tutorial_vga.md` → `tutorial_vga.pdf`

### NRZ-I

- [ ] `nrz_i/docs/tutorial_simulacao.md` → `tutorial_simulacao.pdf`
- [ ] `nrz_i/docs/tutorial_placa.md` → `tutorial_placa.pdf`
- [ ] `nrz_i/docs/documentacao_projeto.md` → `documentacao_projeto.pdf`
- [ ] `nrz_i/extras/pmod_osciloscopio/docs/tutorial_pmod.md` → `tutorial_pmod.pdf`
- [ ] `nrz_i/extras/vga/docs/tutorial_vga.md` → `tutorial_vga.pdf`

### Relatório final

- [ ] `relatorio_final/relatorio.md` → `relatorio.pdf`

> O arquivo `relatorio_final/relatorio.docx` já está gerado e
> espelha o conteúdo do `relatorio.md`. Use-o como base para gerar o
> PDF (`File → Export → PDF`) caso prefira ao Pandoc.

### Arquivos que **permanecem como `.md`** (READMEs)

Os READMEs ficam em Markdown (renderizam no GitHub):

- `README.md` (raiz)
- `nrz_l/README.md`
- `nrz_l/extras/pmod_osciloscopio/README.md`
- `nrz_l/extras/vga/README.md`
- `nrz_i/README.md`
- `nrz_i/extras/pmod_osciloscopio/README.md`
- `nrz_i/extras/vga/README.md`

## 2. Mídias pendentes (capturar na sexta — 2026-05-29)

A documentação está pronta, com placeholders nomeados para cada mídia.
Basta capturar os arquivos abaixo, salvá-los com **exatamente o nome
indicado** e movê-los para a pasta `docs/midia/` correspondente. Todos
os links nos `.md` já apontam para esses caminhos.

### Simulação (prints do Vivado)

- [ ] `nrz_l/docs/midia/sim_projeto_aberto.png` — tela inicial do
      Vivado com o projeto NRZ_L aberto.
- [ ] `nrz_l/docs/midia/sim_runtime_2000ns.png` — Project Settings com
      `xsim.simulate.runtime = 2000 ns`.
- [ ] `nrz_l/docs/midia/sim_waveform_nrz_l.png` — waveform completo
      do NRZ-L (0 a 2000 ns).
- [ ] `nrz_l/docs/midia/sim_waveform_nrz_l_radix.png` — waveform com
      `data_in` em radix binário.
- [ ] `nrz_l/docs/midia/sim_waveform_nrz_l_parte1.png` — waveform de
      0 a 1000 ns (figura 1 do relatório).
- [ ] `nrz_l/docs/midia/sim_waveform_nrz_l_parte2.png` — waveform de
      800 a 1700 ns (figura 2 do relatório).
- [ ] `nrz_i/docs/midia/sim_projeto_aberto.png`
- [ ] `nrz_i/docs/midia/sim_runtime_2000ns.png`
- [ ] `nrz_i/docs/midia/sim_waveform_nrz_i.png`
- [ ] `nrz_i/docs/midia/sim_waveform_nrz_i_radix.png`
- [ ] `nrz_i/docs/midia/sim_waveform_nrz_i_parte1.png` — figura 3 do
      relatório.
- [ ] `nrz_i/docs/midia/sim_waveform_nrz_i_parte2.png` — figura 4 do
      relatório.

### Gravação na placa (fotos)

- [ ] `nrz_l/docs/midia/placa_top_module.png` — Sources com `Top_Module`
      definido como top.
- [ ] `nrz_l/docs/midia/placa_implementation_ok.png` — Implementation
      completa.
- [ ] `nrz_l/docs/midia/placa_basys3_conectada.jpg` — Basys 3 ligada com
      cabo micro-USB.
- [ ] `nrz_l/docs/midia/placa_basys3_transmitindo.jpg` — Basys 3
      transmitindo o NRZ-L (figura 5 do relatório).
- [ ] `nrz_l/docs/midia/placa_leds_indice.jpg` — detalhe de LD0–LD4.
- [ ] `nrz_i/docs/midia/placa_top_module.png`
- [ ] `nrz_i/docs/midia/placa_implementation_ok.png`
- [ ] `nrz_i/docs/midia/placa_basys3_conectada.jpg`
- [ ] `nrz_i/docs/midia/placa_basys3_transmitindo.jpg` — figura 6 do
      relatório.
- [ ] `nrz_i/docs/midia/placa_leds_indice.jpg`

### PMOD / Analog Discovery 3 (WaveForms)

- [ ] `nrz_l/extras/pmod_osciloscopio/docs/midia/pmod_conexao_basys3_ad3.jpg`
- [ ] `nrz_l/extras/pmod_osciloscopio/docs/midia/pmod_conexao_detalhe.jpg`
- [ ] `nrz_l/extras/pmod_osciloscopio/docs/midia/pmod_waveforms_setup.png`
- [ ] `nrz_l/extras/pmod_osciloscopio/docs/midia/pmod_waveforms_nrz_l.png`
      — figura 7 do relatório.
- [ ] `nrz_l/extras/pmod_osciloscopio/docs/midia/pmod_waveforms_nrz_l_x_clk.png`
- [ ] `nrz_i/extras/pmod_osciloscopio/docs/midia/pmod_conexao_basys3_ad3.jpg`
- [ ] `nrz_i/extras/pmod_osciloscopio/docs/midia/pmod_conexao_detalhe.jpg`
- [ ] `nrz_i/extras/pmod_osciloscopio/docs/midia/pmod_waveforms_setup.png`
- [ ] `nrz_i/extras/pmod_osciloscopio/docs/midia/pmod_waveforms_nrz_i.png`
      — figura 8 do relatório.
- [ ] `nrz_i/extras/pmod_osciloscopio/docs/midia/pmod_waveforms_nrz_i_x_clk.png`

### VGA

- [ ] `nrz_l/extras/vga/docs/midia/vga_clkwiz_config.png` — print do
      Clocking Wizard (Requested Freq = 25,175 MHz).
- [ ] `nrz_l/extras/vga/docs/midia/vga_setup.jpg` — Basys 3 conectada ao
      monitor VGA.
- [ ] `nrz_l/extras/vga/docs/midia/vga_tela_vermelha.jpg` — figura 9 do
      relatório.
- [ ] `nrz_l/extras/vga/docs/midia/vga_tela_azul.jpg` — figura 10 do
      relatório.
- [ ] `nrz_l/extras/vga/docs/midia/vga_pulsante.mp4` — vídeo curto da
      tela alternando vermelho/azul.
- [ ] `nrz_i/extras/vga/docs/midia/vga_clkwiz_config.png`
- [ ] `nrz_i/extras/vga/docs/midia/vga_setup.jpg`
- [ ] `nrz_i/extras/vga/docs/midia/vga_tela_vermelha.jpg`
- [ ] `nrz_i/extras/vga/docs/midia/vga_tela_azul.jpg`
- [ ] `nrz_i/extras/vga/docs/midia/vga_pulsante.mp4`

### Vídeo de demonstração

- [ ] `relatorio_final/video_demo.mp4` — vídeo curto da apresentação na
      sexta (referenciado no README raiz e no relatório).

## 3. Antes do *push* final

- [ ] Conferir se todos os links internos (`./docs/...`, `../nrz_i/`,
      etc.) funcionam no GitHub (case-sensitive).
- [ ] Confirmar que os `.pdf` exportados estão na mesma pasta dos
      `.md` originais (caminhos relativos batem com o que os READMEs
      apontam).
- [ ] Conferir que o `relatorio_final/relatorio.pdf` foi gerado.
- [ ] Conferir que a sequência de teste `"1010110010011101"` aparece
      consistente em todos os documentos.
- [ ] Conferir que a versão **2025.2** do Vivado está citada em todos
      os tutoriais.
- [ ] Abrir um Pull Request no repositório oficial
      `viniciussbrg/modulacao_nrz_l_nrz_i_vhdl_fpga` com o título
      `Entrega - Grupo X - <Nomes>` e descrição com os integrantes.
