library ieee;
use ieee.std_logic_1164.all;

entity FFT is
    port (
        CLK : in  std_logic;
        CLR   : in  std_logic;
        T   : in  std_logic;
        Q   : out std_logic
    );
end FFT;

architecture arch of FFT is
    signal Q_interno : std_logic := '0';
begin
    process(CLK)
    begin
        if falling_edge(CLK) then
            if (CLR = '1') then
                Q_interno <= '0';
            elsif T = '1' then
                Q_interno <= not Q_interno;
            end if;
        end if;
    end process;
    
    Q <= Q_interno;
end arch;