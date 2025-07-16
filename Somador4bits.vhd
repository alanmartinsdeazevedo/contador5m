library ieee;
use ieee.std_logic_1164.all;

entity Somador4bits is
    port (
        A    : in  std_logic_vector(3 downto 0);
        B    : in  std_logic_vector(3 downto 0);
        CIN  : in  std_logic;
        S    : out std_logic_vector(3 downto 0);
        COUT : out std_logic
    );
end Somador4bits;

architecture arc of Somador4bits is
    component SomadorCompleto
        port (
            a, b, cin: in std_logic;
            s, cout: out std_logic
        );
    end component;
    
    signal carry : std_logic_vector(4 downto 0);
    
begin
    carry(0) <= CIN;
    
    gen_som: for i in 0 to 3 generate
        som_inst: SomadorCompleto port map (
            a    => A(i),
            b    => B(i),
            cin  => carry(i),
            s    => S(i),
            cout => carry(i+1)
        );
    end generate;
    
    COUT <= carry(4);
end arc;