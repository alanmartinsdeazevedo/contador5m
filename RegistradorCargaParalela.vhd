library ieee;
use ieee.std_logic_1164.all;

entity RegistradorCargaParalela is
    generic (
        WIDTH : integer := 4
    );
    port (
        CLK  : in  std_logic;
        CLR  : in  std_logic;
        LOAD : in  std_logic;
        D    : in  std_logic_vector(WIDTH-1 downto 0);
        Q    : out std_logic_vector(WIDTH-1 downto 0)
    );
end RegistradorCargaParalela;

architecture arc of RegistradorCargaParalela is
    component FlipFlopD
        port (
            CLK : in  std_logic;
            CLR : in  std_logic;
            D   : in  std_logic;
            Q   : out std_logic
        );
    end component;
    
    signal data_in : std_logic_vector(WIDTH-1 downto 0);
    signal q_internal : std_logic_vector(WIDTH-1 downto 0);
    
begin
    gen_ff: for i in 0 to WIDTH-1 generate
        data_in(i) <= D(i) when LOAD = '1' else q_internal(i);
        
        ff_inst: FlipFlopD port map (
            CLK => CLK,
            CLR => CLR,
            D   => data_in(i),
            Q   => q_internal(i)
        );
    end generate;
    
    Q <= q_internal;
end arc;