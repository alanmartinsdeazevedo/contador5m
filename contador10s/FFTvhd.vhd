library ieee;
use ieee.std_logic_1164.all;

entity FFT is
    port (
        T   : in  std_logic;   -- Entrada T
        CLK : in  std_logic;   -- Clock
        CLR : in  std_logic;   -- Clear assíncrono
        Q   : out std_logic    -- Saída Q
    );
end FFT;

architecture behavioral of FFT is
    signal Q_int : std_logic := '0';
begin
    process(CLK, CLR)
    begin
        if CLR = '1' then
            Q_int <= '0';  -- Reset
        elsif rising_edge(CLK) then
            if T = '1' then
                Q_int <= not Q_int; -- T=1
            end if;
        end if;
    end process;
    
    Q <= Q_int;  -- Saída
end behavioral;