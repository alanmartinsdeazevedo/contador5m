library ieee;
use ieee.std_logic_1164.all;

entity Relogio2Min is
    port (
        CLK : in  std_logic;
        RST : in  std_logic;
        HEX0: out std_logic_vector(6 downto 0);
        HEX1: out std_logic_vector(6 downto 0);
        HEX2: out std_logic_vector(6 downto 0);
        HEX3: out std_logic_vector(6 downto 0)
    );
end Relogio2Min;

architecture arc of Relogio2Min is
    component DF
        port (
            clk_in:  in  std_logic;
            clk_out: out std_logic
        );
    end component;
    
    component RegistradorCargaParalela
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
    end component;
    
    component Somador4bits
        port (
            A    : in  std_logic_vector(3 downto 0);
            B    : in  std_logic_vector(3 downto 0);
            CIN  : in  std_logic;
            S    : out std_logic_vector(3 downto 0);
            COUT : out std_logic
        );
    end component;
    
    component CircuitoClearU
        port (
            Q : in  std_logic_vector(3 downto 0);
            CLR : out std_logic
        );
    end component;
    
    component CircuitoClearD
        port (
            Q : in  std_logic_vector(3 downto 0);
            CLR : out std_logic
        );
    end component;
    
    component Decod7segmentos
        port (
            i3, i2, i1, i0: in std_logic;
            a, b, c, d, e, f, g: out std_logic
        );
    end component;
    
    signal clk_1hz : std_logic;
    signal seg_u, seg_d, min_u, min_d : std_logic_vector(3 downto 0);
    signal seg_u_next, seg_d_next, min_u_next, min_d_next : std_logic_vector(3 downto 0);
    signal clear_seg_u, clear_seg_d, clear_min_u, clear_min_d : std_logic;
    signal reset_all : std_logic;
    
begin
    -- Divisor de frequência para 1 Hz
    div_freq: DF port map (CLK, clk_1hz);
    
    -- Registradores para segundos (unidade)
    reg_seg_u: RegistradorCargaParalela 
        generic map (WIDTH => 4)
        port map (
            CLK  => clk_1hz,
            CLR  => clear_seg_u or RST or reset_all,
            LOAD => '1',
            D    => seg_u_next,
            Q    => seg_u
        );
    
    -- Somador para segundos (unidade)
    som_seg_u: Somador4bits port map (
        A    => seg_u,
        B    => "0001",
        CIN  => '0',
        S    => seg_u_next,
        COUT => open
    );
    
    -- Clear para segundos (unidade) - reseta quando chega a 10
    clear_u: CircuitoClearU port map (seg_u_next, clear_seg_u);
    
    -- Registradores para segundos (dezena)
    reg_seg_d: RegistradorCargaParalela 
        generic map (WIDTH => 4)
        port map (
            CLK  => clear_seg_u,
            CLR  => clear_seg_d or RST or reset_all,
            LOAD => '1',
            D    => seg_d_next,
            Q    => seg_d
        );
    
    -- Somador para segundos (dezena)
    som_seg_d: Somador4bits port map (
        A    => seg_d,
        B    => "0001",
        CIN  => '0',
        S    => seg_d_next,
        COUT => open
    );
    
    -- Clear para segundos (dezena) - reseta quando chega a 6
    clear_d: CircuitoClearD port map (seg_d_next, clear_seg_d);
    
    -- Registradores para minutos (unidade)
    reg_min_u: RegistradorCargaParalela 
        generic map (WIDTH => 4)
        port map (
            CLK  => clear_seg_d,
            CLR  => clear_min_u or RST or reset_all,
            LOAD => '1',
            D    => min_u_next,
            Q    => min_u
        );
    
    -- Somador para minutos (unidade)
    som_min_u: Somador4bits port map (
        A    => min_u,
        B    => "0001",
        CIN  => '0',
        S    => min_u_next,
        COUT => open
    );
    
    -- Clear para minutos (unidade) - reseta quando chega a 10
    clear_min_u_circuit: CircuitoClearU port map (min_u_next, clear_min_u);
    
    -- Registradores para minutos (dezena)
    reg_min_d: RegistradorCargaParalela 
        generic map (WIDTH => 4)
        port map (
            CLK  => clear_min_u,
            CLR  => clear_min_d or RST or reset_all,
            LOAD => '1',
            D    => min_d_next,
            Q    => min_d
        );
    
    -- Somador para minutos (dezena)
    som_min_d: Somador4bits port map (
        A    => min_d,
        B    => "0001",
        CIN  => '0',
        S    => min_d_next,
        COUT => open
    );
    
    -- Clear para minutos (dezena) - reseta quando chega a 2
    clear_min_d_circuit: CircuitoClearD port map (min_d_next, clear_min_d);
    
    -- Reset geral quando atinge 2 minutos
    reset_all <= clear_min_d;
    
    -- Decodificadores para displays
    dec_seg_u: Decod7segmentos port map (
        seg_u(3), seg_u(2), seg_u(1), seg_u(0),
        HEX0(0), HEX0(1), HEX0(2), HEX0(3), HEX0(4), HEX0(5), HEX0(6)
    );
    
    dec_seg_d: Decod7segmentos port map (
        seg_d(3), seg_d(2), seg_d(1), seg_d(0),
        HEX1(0), HEX1(1), HEX1(2), HEX1(3), HEX1(4), HEX1(5), HEX1(6)
    );
    
    dec_min_u: Decod7segmentos port map (
        min_u(3), min_u(2), min_u(1), min_u(0),
        HEX2(0), HEX2(1), HEX2(2), HEX2(3), HEX2(4), HEX2(5), HEX2(6)
    );
    
    dec_min_d: Decod7segmentos port map (
        min_d(3), min_d(2), min_d(1), min_d(0),
        HEX3(0), HEX3(1), HEX3(2), HEX3(3), HEX3(4), HEX3(5), HEX3(6)
    );
    
    
end arc;