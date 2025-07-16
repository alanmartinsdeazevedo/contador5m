library ieee;
use ieee.std_logic_1164.all;

entity CircuitoClearU is
    port (
        Q : in  std_logic_vector(3 downto 0);
        CLR : out std_logic
    );
end CircuitoClearU;

architecture arc of CircuitoClearU is
begin
    -- Clear quando unidade = 10 (1010)
    CLR <= Q(3) and (not Q(2)) and Q(1) and (not Q(0));
end arc;