# Modulação Digital em VHDL

Trabalho da disciplina de **Comunicação de Dados — Sistemas Reconfiguráveis**,
ministrada pelo Prof. Vinícius S. Borges. Faculdade de Engenharia Salvador Arena
— Engenharia de Computação. Semestre 2026/1.

## Integrantes

- Matheus Mitsuo Sato Silva — RA 081230046
- Nicolas Gomes Lima — RA 081230048
- Júlio César Caberlino Ferro — RA 081230003
- Alex Saifi de Souza — RA 081230025
- Felipe Medeiros — RA 081230026

## Descrição

Este trabalho implementa, em VHDL, dois sistemas de modulação digital banda
base: Unipolar NRZ-L e Unipolar NRZ-I. Cada modulação é um projeto Vivado
independente, com seu próprio módulo de modulação, testbench, *constraints*
da Basys 3 e *wrapper* de placa (`Top_Module.vhd`) que integra divisor de
clock, controle de *start/reset*, saída PMOD para o Analog Discovery 3 e
controlador VGA de tela cheia.

A simulação comportamental foi feita no Vivado Simulator com a sequência
de teste `"1010110010011101"` (hex `AC9D`). A implementação na placa
**Digilent Basys 3 (Artix-7 `xc7a35tcpg236-1`)** usa os 16 *switches* como
entrada de dados, os botões central e direito como `reset` e `start`, e
os LEDs como saída. Foram realizadas as duas atividades extras: saída VGA
640×480 @ 60 Hz com cores pulsantes (vermelho/azul) e visualização da
forma de onda no PMOD JA via Digilent Analog Discovery 3 (software
WaveForms).

## Estrutura do repositório

```
modulacao_vhdl/
|-- README.md            Visão geral, integrantes e índice (este arquivo)
|-- nrz_l/               Projeto da modulação NRZ-L (auto-contido)
|-- nrz_i/               Projeto da modulação NRZ-I (auto-contido)
`-- relatorio_final/     Relatório técnico consolidado e vídeo demo
```

Cada projeto possui sua própria pasta `docs/` com tutoriais e documentação
técnica, e uma pasta `extras/` com as atividades opcionais (saída PMOD e
saída VGA).

## Projetos

- [Modulação NRZ-L](./nrz_l/) — bit representado pelo *nível* do pulso
- [Modulação NRZ-I](./nrz_i/) — bit representado pela *transição* do pulso

## Relatório

- [Relatório técnico final](./relatorio_final/relatorio.pdf)
- [Vídeo de demonstração](./relatorio_final/video_demo.mp4) — gravado no
  dia da apresentação e adicionado posteriormente ao repositório.

## Ferramentas utilizadas

- AMD Vivado 2025.2
- Placa Digilent Basys 3 (FPGA Artix-7 `xc7a35tcpg236-1`)
- Digilent WaveForms + Analog Discovery 3 (extra de osciloscópio via PMOD JA)
- Monitor com entrada VGA (extra de saída VGA, 640×480 @ 60 Hz)

## Como começar

Recomenda-se iniciar pelo projeto NRZ-L. Acesse a pasta
[nrz_l/](./nrz_l/) e siga o README local, que aponta o tutorial de
simulação como ponto de partida.
