library ieee;
use ieee.std_logic_1164.all;

entity FlipFlopD is
    port (
        CLK : in  std_logic;
        CLR : in  std_logic;
        D   : in  std_logic;
        Q   : out std_logic
    );
end FlipFlopD;

architecture arc of FlipFlopD is
begin
    process(CLK, CLR)
    begin
        if CLR = '1' then
            Q <= '0';
        elsif rising_edge(CLK) then
            Q <= D;
        end if;
    end process;
end arc;