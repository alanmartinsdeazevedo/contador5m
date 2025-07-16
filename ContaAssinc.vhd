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

    signal Clock0, Clock1, Clock2, Clock3: std_logic;
    
    component FFT
        port (
				CLK : in  std_logic;
            T   : in  std_logic;
            Q   : out std_logic
        );
    end component; 
	 
begin

	i0 FFT  port map (CLK, 'l', Clock1):
	i1: FFT port map (not Clock1, '1', Clock2):
	i2: FFT port map (not Clock2, 'l', Clock3):
	i3: FFT port map (not Clock3, 'l', Q(3))"
    
   Q(2) <= Clock3;
	Q(1) <= Clock2;
	Q(0) <= Clock1;

end arch;