library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity NRZ_I is
    generic (
        DATA_WIDTH     : integer := 16;
        CYCLES_PER_BIT : integer := 10
    );
    port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        nrz_out  : out STD_LOGIC;
        bit_idx  : out integer range 0 to DATA_WIDTH-1
    );
end NRZ_I;
 
architecture Behavioral of NRZ_I is
    signal cycle_count : integer range 0 to CYCLES_PER_BIT-1 := 0;
    signal bit_index   : integer range 0 to DATA_WIDTH-1     := DATA_WIDTH-1;
    signal encoded     : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
begin
    -- Pre-codificacao NRZ-I via XOR concorrente
    encoded(DATA_WIDTH-1) <= '0' XOR data_in(DATA_WIDTH-1);
 
    gen_encode: for i in DATA_WIDTH-2 downto 0 generate
        encoded(i) <= encoded(i+1) XOR data_in(i);
    end generate;
 
    seq_proc: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cycle_count <= 0;
                bit_index   <= DATA_WIDTH-1;
            else
                if cycle_count = CYCLES_PER_BIT-1 then
                    cycle_count <= 0;
                    if bit_index = 0 then
                        bit_index <= DATA_WIDTH-1;
                    else
                        bit_index <= bit_index - 1;
                    end if;
                else
                    cycle_count <= cycle_count + 1;
                end if;
            end if;
        end if;
    end process;
 
    nrz_out <= '0' when reset = '1' else encoded(bit_index);
    bit_idx <= bit_index;
end Behavioral;
