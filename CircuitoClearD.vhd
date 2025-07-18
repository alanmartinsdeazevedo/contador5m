library ieee;
use ieee.std_logic_1164.all;

entity CircuitoClearD is
    port (
        Q : in  std_logic_vector(3 downto 0);
        CLR : out std_logic
    );
end CircuitoClearD;

architecture arc of CircuitoClearD is
begin
    -- Clear quando dezena = 6 (0110) para segundos ou 2 (0010) para minutos
    CLR <= ((not Q(3)) and Q(2) and Q(1) and (not Q(0))) or  -- 6 para segundos
           ((not Q(3)) and (not Q(2)) and Q(1) and (not Q(0)));  -- 2 para minutos
end arc;