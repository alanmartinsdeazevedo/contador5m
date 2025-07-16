library ieee;
use ieee.std_logic_1164.all;

entity DivisorFrequencia is
    port (
        clk_in: in std_logic;
        clk_out: out std_logic
    );
end DivisorFrequencia;
    
architecture arc of DivisorFrequencia is
    signal contador : integer := 0;
    signal s_clk_out : std_logic := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if contador = 24999999 then
                s_clk_out <= not s_clk_out;
                contador <= 0;
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;
    
    clk_out <= s_clk_out;
end arc;