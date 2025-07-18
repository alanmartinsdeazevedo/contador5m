library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Relogio2MinCompativel is
    port (
        CLK : in  std_logic;
        HEX0: out std_logic_vector(6 downto 0);
        HEX1: out std_logic_vector(6 downto 0)
    );
end Relogio2MinCompativel;

architecture arch of Relogio2MinCompativel is
    signal clk_1hz: std_logic;
    signal contador_segundos: integer range 0 to 119 := 0;
    signal seg_u, seg_d: integer range 0 to 9;
    
    -- Divisor de frequência igual ao contador10s funcionando
    signal contador_div: integer := 0;
    signal s_clk_out: std_logic := '0';
    
    component Decod7segmentos
        port (
            i3, i2, i1, i0: in std_logic;
            a, b, c, d, e, f, g: out std_logic
        );
    end component;
    
begin
    -- Divisor de frequência exato do contador10s
    process(CLK)
    begin
        if rising_edge(CLK) then
            if contador_div = 24999999 then
                s_clk_out <= not s_clk_out;
                contador_div <= 0;
            else
                contador_div <= contador_div + 1;
            end if;
        end if;
    end process;
    
    clk_1hz <= s_clk_out;
    
    -- Processo de contagem simples
    process(clk_1hz)
    begin
        if rising_edge(clk_1hz) then
            if contador_segundos = 119 then
                contador_segundos <= 0;
            else
                contador_segundos <= contador_segundos + 1;
            end if;
        end if;
    end process;
    
    -- Conversão para displays (apenas segundos nos 2 displays)
    process(contador_segundos)
        variable segundos_restantes: integer;
    begin
        segundos_restantes := contador_segundos mod 60;
        
        -- Segundos nos displays
        seg_u <= segundos_restantes mod 10;
        seg_d <= segundos_restantes / 10;
    end process;
    
    -- Decodificadores para displays (igual ao contador10s)
    dec_seg_u: Decod7segmentos port map (
        std_logic_vector(to_unsigned(seg_u, 4))(3), std_logic_vector(to_unsigned(seg_u, 4))(2),
        std_logic_vector(to_unsigned(seg_u, 4))(1), std_logic_vector(to_unsigned(seg_u, 4))(0),
        HEX0(0), HEX0(1), HEX0(2), HEX0(3), HEX0(4), HEX0(5), HEX0(6)
    );
    
    dec_seg_d: Decod7segmentos port map (
        std_logic_vector(to_unsigned(seg_d, 4))(3), std_logic_vector(to_unsigned(seg_d, 4))(2),
        std_logic_vector(to_unsigned(seg_d, 4))(1), std_logic_vector(to_unsigned(seg_d, 4))(0),
        HEX1(0), HEX1(1), HEX1(2), HEX1(3), HEX1(4), HEX1(5), HEX1(6)
    );
    
end arch;