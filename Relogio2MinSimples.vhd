library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Relogio2MinSimples is
    port (
        CLK : in  std_logic;
        RST : in  std_logic;
        HEX0: out std_logic_vector(6 downto 0);
        HEX1: out std_logic_vector(6 downto 0);
        HEX2: out std_logic_vector(6 downto 0);
        HEX3: out std_logic_vector(6 downto 0)
    );
end Relogio2MinSimples;

architecture arch of Relogio2MinSimples is
    signal clk_1hz: std_logic;
    signal contador_segundos: integer range 0 to 119 := 0; -- 0 a 119 segundos (2 minutos)
    signal seg_u, seg_d, min_u, min_d: integer range 0 to 9;
    
    component DF
        port (
            clk_in:  in  std_logic;
            clk_out: out std_logic
        );
    end component;
    
    component Decod7segmentos
        port (
            i3, i2, i1, i0: in std_logic;
            a, b, c, d, e, f, g: out std_logic
        );
    end component;
    
begin
    -- Divisor de frequência para 1 Hz
    div_freq: DF port map (CLK, clk_1hz);
    
    -- Processo de contagem simples
    process(clk_1hz, RST)
    begin
        if RST = '1' then
            contador_segundos <= 0;
        elsif rising_edge(clk_1hz) then
            if contador_segundos = 119 then  -- 2 minutos = 120 segundos
                contador_segundos <= 0;
            else
                contador_segundos <= contador_segundos + 1;
            end if;
        end if;
    end process;
    
    -- Conversão para formato MM:SS
    process(contador_segundos)
        variable segundos_total: integer;
        variable minutos_total: integer;
        variable segundos_restantes: integer;
    begin
        segundos_total := contador_segundos;
        minutos_total := segundos_total / 60;
        segundos_restantes := segundos_total mod 60;
        
        -- Segundos
        seg_u <= segundos_restantes mod 10;
        seg_d <= segundos_restantes / 10;
        
        -- Minutos
        min_u <= minutos_total mod 10;
        min_d <= minutos_total / 10;
    end process;
    
    -- Decodificadores para displays
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
    
    dec_min_u: Decod7segmentos port map (
        std_logic_vector(to_unsigned(min_u, 4))(3), std_logic_vector(to_unsigned(min_u, 4))(2),
        std_logic_vector(to_unsigned(min_u, 4))(1), std_logic_vector(to_unsigned(min_u, 4))(0),
        HEX2(0), HEX2(1), HEX2(2), HEX2(3), HEX2(4), HEX2(5), HEX2(6)
    );
    
    dec_min_d: Decod7segmentos port map (
        std_logic_vector(to_unsigned(min_d, 4))(3), std_logic_vector(to_unsigned(min_d, 4))(2),
        std_logic_vector(to_unsigned(min_d, 4))(1), std_logic_vector(to_unsigned(min_d, 4))(0),
        HEX3(0), HEX3(1), HEX3(2), HEX3(3), HEX3(4), HEX3(5), HEX3(6)
    );
    
end arch;