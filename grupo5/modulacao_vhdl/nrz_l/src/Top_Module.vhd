library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_Module is
    port (
        clk      : in  STD_LOGIC; -- 100 MHz da placa
        reset    : in  STD_LOGIC; -- Botão Central
        start    : in  STD_LOGIC; -- Botão Direito
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0); -- 16 Chaves
        nrz_out  : out STD_LOGIC; -- LED 0
        bit_idx  : out integer range 0 to 15; -- LEDs 1 a 4
        pmod_ja  : out STD_LOGIC_VECTOR(3 downto 0);
        
        -- Saídas VGA da BASYS 3
        vga_hsync : out STD_LOGIC;
        vga_vsync : out STD_LOGIC;
        vga_red   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_green : out STD_LOGIC_VECTOR(3 downto 0);
        vga_blue  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Top_Module;

architecture Behavioral of Top_Module is
    -- Clocks
    signal clk_slow    : STD_LOGIC := '0';
    signal clk_25MHz   : STD_LOGIC; -- Agora alimentado pelo Clock Wizard
    
    -- Contadores de Clock
    signal counter_slow : integer range 0 to 4999999 := 0; 
    
    -- Controle de Estado
    signal ligado      : STD_LOGIC := '0'; 
    signal clk_gated   : STD_LOGIC := '0';
    signal nrz_signal  : STD_LOGIC;

    -- Sinais do Controlador VGA Padrão (640x480 @ 60Hz)
    signal h_cnt : integer range 0 to 799 := 0;
    signal v_cnt : integer range 0 to 524 := 0;
    signal video_on : STD_LOGIC;

begin

    -- 1. INSTANCIAÇÃO DO CLOCK WIZARD (Gera os 25MHz perfeitos via hardware de PLL)
    vga_clk_gen : entity work.clk_wiz_vga
        port map (
            clk_in1  => clk,       -- Entrada de 100 MHz da placa
            clk_out1 => clk_25MHz  -- Saída limpa de 25 MHz
        );

    -- 2. DIVISOR DE CLOCK PARA TRANSMISSÃO (10 Hz)
    process(clk)
    begin
        if rising_edge(clk) then
            if counter_slow = 4999999 then
                counter_slow <= 0;
                clk_slow <= not clk_slow;
            else
                counter_slow <= counter_slow + 1;
            end if;
        end if;
    end process;

    -- 3. LÓGICA DE START / RESET
    process(clk_slow, reset)
    begin
        if reset = '1' then
            ligado <= '0';
        elsif rising_edge(clk_slow) then
            if start = '1' then
                ligado <= '1';
            end if;
        end if;
    end process;

    clk_gated <= clk_slow and ligado;

    -- 4. INSTANCIAÇÃO DO SEU CÓDIGO ORIGINAL (NRZ_L)
    meu_nrz_inst: entity work.NRZ_L
        generic map (DATA_WIDTH => 16, CYCLES_PER_BIT => 10)
        port map (
            clk => clk_gated, reset => reset, data_in => data_in,
            nrz_out => nrz_signal, bit_idx => bit_idx
        );

    nrz_out <= nrz_signal;
    pmod_ja(0) <= nrz_signal;
    pmod_ja(1) <= clk_gated; 
    pmod_ja(2) <= start;     
    pmod_ja(3) <= ligado;    

    -- 5. CONTROLADOR DE TEMPORIZAÇÃO VGA PADRÃO
    process(clk_25MHz)
    begin
        if rising_edge(clk_25MHz) then
            if h_cnt = 799 then
                h_cnt <= 0;
                if v_cnt = 524 then
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;
        end if;
    end process;

    -- Sincronismo estável
    vga_hsync <= '0' when (h_cnt >= 656 and h_cnt < 752) else '1';
    vga_vsync <= '0' when (v_cnt >= 490 and v_cnt < 492) else '1';
    
    -- Área visível ativa
    video_on <= '1' when (h_cnt < 640 and v_cnt < 480) else '0';

    -- 6. GERAÇÃO DE CORES (Tela cheia Verde ou Preta)
    process(video_on, nrz_signal)
    begin
        if video_on = '0' then
            vga_red   <= "0000";
            vga_green <= "0000";
            vga_blue  <= "0000";
        else
            if nrz_signal = '1' then
                vga_red   <= "1111";
                vga_green <= "0000"; -- Tela Verde
                vga_blue  <= "0000";
            else
                vga_red   <= "0000";
                vga_green <= "0000"; -- Tela Preta
                vga_blue  <= "1111";
            end if;
        end if;
    end process;

end Behavioral;