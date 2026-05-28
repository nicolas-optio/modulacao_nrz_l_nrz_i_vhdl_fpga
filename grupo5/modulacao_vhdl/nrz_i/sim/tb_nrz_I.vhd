library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity tb_NRZ_I is
end tb_NRZ_I;
 
architecture Behavioral of tb_NRZ_I is
    constant CLK_PERIOD : time := 10 ns;
    constant BIT_PERIOD : time := 100 ns;
 
    signal clk     : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '1';
    signal data_in : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal nrz_out : STD_LOGIC;
    signal bit_idx : integer range 0 to 15;
begin
    uut: entity work.NRZ_I
        generic map (DATA_WIDTH => 16, CYCLES_PER_BIT => 10)
        port map (
            clk => clk, reset => reset, data_in => data_in,
            nrz_out => nrz_out, bit_idx => bit_idx
        );
 
    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;
 
    stim_process : process
    begin
        data_in <= "1010110010011101";
        reset <= '1';
        wait for 2 * CLK_PERIOD;
        reset <= '0';
        wait for 16 * BIT_PERIOD;
        wait;
    end process;
end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity tb_NRZ_I is
end tb_NRZ_I;
 
architecture Behavioral of tb_NRZ_I is
    constant CLK_PERIOD : time := 10 ns;
    constant BIT_PERIOD : time := 100 ns;
 
    signal clk     : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '1';
    signal data_in : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal nrz_out : STD_LOGIC;
    signal bit_idx : integer range 0 to 15;
begin
    uut: entity work.NRZ_I
        generic map (DATA_WIDTH => 16, CYCLES_PER_BIT => 10)
        port map (
            clk => clk, reset => reset, data_in => data_in,
            nrz_out => nrz_out, bit_idx => bit_idx
        );
 
    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;
 
    stim_process : process
    begin
        data_in <= "1010110010011101";
        reset <= '1';
        wait for 2 * CLK_PERIOD;
        reset <= '0';
        wait for 16 * BIT_PERIOD;
        wait;
    end process;
end Behavioral;
