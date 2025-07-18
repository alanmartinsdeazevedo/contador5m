library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Contador is
    port (
        CLK : in  std_logic;
        Q   : out std_logic_vector(3 downto 0)
    );
end Contador;

architecture arch of Contador is
    signal Clock0, Clock1, Clock2, Clock3, clear: std_logic;
    
    component FFT
        port (
            CLK : in  std_logic;
				CLR   : in  std_logic;
            T   : in  std_logic;
            Q   : out std_logic
        );
    end component;
    
begin
    i0: FFT port map (CLK, clear, '1', Clock0);
    i1: FFT port map (Clock0, clear, '1', Clock1);
    i2: FFT port map (Clock1, clear, '1', Clock2);
    i3: FFT port map (Clock2, clear, '1', Clock3);
    
    Q(0) <= Clock0;
    Q(1) <= Clock1;
    Q(2) <= Clock2;
    Q(3) <= Clock3;
	 
	 clear <= Clock1 and not(Clock2) and Clock3;
    
end arch;