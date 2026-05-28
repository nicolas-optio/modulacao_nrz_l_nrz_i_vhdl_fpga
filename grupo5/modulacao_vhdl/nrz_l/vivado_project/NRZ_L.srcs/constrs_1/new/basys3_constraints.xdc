## ====================================================================
## CLOCK SIGNAL (100 MHz)
## ====================================================================
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## ====================================================================
## PUSH BUTTONS (Start e Reset)
## ====================================================================
# Central Button (Reset)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# Right Button (Start)
set_property PACKAGE_PIN T17 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]

## ====================================================================
## SWITCHES (data_in: 16 bits)
## ====================================================================
set_property PACKAGE_PIN V17 [get_ports {data_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {data_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {data_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {data_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[3]}]
set_property PACKAGE_PIN W15 [get_ports {data_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[4]}]
set_property PACKAGE_PIN V15 [get_ports {data_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[5]}]
set_property PACKAGE_PIN W14 [get_ports {data_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[6]}]
set_property PACKAGE_PIN W13 [get_ports {data_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[7]}]
set_property PACKAGE_PIN V2 [get_ports {data_in[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[8]}]
set_property PACKAGE_PIN T3 [get_ports {data_in[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[9]}]
set_property PACKAGE_PIN T2 [get_ports {data_in[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[10]}]
set_property PACKAGE_PIN R3 [get_ports {data_in[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[11]}]
set_property PACKAGE_PIN W2 [get_ports {data_in[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[12]}]
set_property PACKAGE_PIN U1 [get_ports {data_in[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[13]}]
set_property PACKAGE_PIN T1 [get_ports {data_in[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[14]}]
set_property PACKAGE_PIN R2 [get_ports {data_in[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[15]}]

## ====================================================================
## LEDS FÍSICOS DA PLACA
## ====================================================================
# LED 0 (nrz_out)
set_property PACKAGE_PIN U16 [get_ports nrz_out]
set_property IOSTANDARD LVCMOS33 [get_ports nrz_out]

# LEDs 1 a 4 (bit_idx: Barramento interno gerado pelo inteiro)
set_property PACKAGE_PIN E19 [get_ports {bit_idx[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bit_idx[0]}]
set_property PACKAGE_PIN U19 [get_ports {bit_idx[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bit_idx[1]}]
set_property PACKAGE_PIN V19 [get_ports {bit_idx[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bit_idx[2]}]
set_property PACKAGE_PIN W18 [get_ports {bit_idx[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bit_idx[3]}]

## ====================================================================
## PMOD HEADER JA (Linha Superior para medição com AD3)
## ====================================================================
# Pino 1 (JA1) - Saída NRZ_L (Fio Laranja/Branco 1+)
set_property PACKAGE_PIN J1 [get_ports {pmod_ja[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_ja[0]}]

# Pino 2 (JA2) - Clock Lento Gated
set_property PACKAGE_PIN L2 [get_ports {pmod_ja[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_ja[1]}]

# Pino 3 (JA3) - Sinal de Start
set_property PACKAGE_PIN J2 [get_ports {pmod_ja[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_ja[2]}]

# Pino 4 (JA4) - Estado Ligado do Sistema
set_property PACKAGE_PIN G2 [get_ports {pmod_ja[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_ja[3]}]

## ====================================================================
## VGA OUTPUTS (Conector azul da placa)
## ====================================================================
set_property PACKAGE_PIN G19 [get_ports {vga_red[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[0]}]
set_property PACKAGE_PIN H19 [get_ports {vga_red[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[1]}]
set_property PACKAGE_PIN J19 [get_ports {vga_red[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[2]}]
set_property PACKAGE_PIN N19 [get_ports {vga_red[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[3]}]

set_property PACKAGE_PIN J17 [get_ports {vga_green[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[0]}]
set_property PACKAGE_PIN H17 [get_ports {vga_green[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[1]}]
set_property PACKAGE_PIN G17 [get_ports {vga_green[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[2]}]
set_property PACKAGE_PIN D17 [get_ports {vga_green[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[3]}]

set_property PACKAGE_PIN N18 [get_ports {vga_blue[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[0]}]
set_property PACKAGE_PIN L18 [get_ports {vga_blue[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[1]}]
set_property PACKAGE_PIN K18 [get_ports {vga_blue[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[2]}]
set_property PACKAGE_PIN J18 [get_ports {vga_blue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[3]}]

set_property PACKAGE_PIN P19 [get_ports vga_hsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hsync]
set_property PACKAGE_PIN R19 [get_ports vga_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vsync]

## ====================================================================
## REGRAS DE INICIALIZAÇÃO E TRATAMENTO DE TIMING CLOCK (Gated Clock)
## ====================================================================
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_gated]
create_clock -period 100000000.00 -name clk_gated [get_nets clk_gated]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIX4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]