library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Principal is
    port (
        CLK : in  std_logic;
        LEDS: out std_logic_vector(9 downto 0);
        HEX0: out std_logic_vector(6 downto 0);
        HEX1: out std_logic_vector(6 downto 0)
    );
end Principal;

architecture arch of Principal is
    signal novoclock: std_logic;
    signal contador_out: std_logic_vector(3 downto 0);
    signal contador_int: integer range 0 to 10;
    signal unidade, dezena: std_logic_vector(3 downto 0);
    
    component DivisorFrequencia
        port (
            clk_in:  in  std_logic;
            clk_out: out std_logic
        );
    end component;
    
    component Contador
        port (
            CLK: in  std_logic;
            Q:   out std_logic_vector(3 downto 0)
        );
    end component;
    
    component Decod7segmentos
        port (
            i3, i2, i1, i0: in std_logic;
            a, b, c, d, e, f, g: out std_logic
        );
    end component;
    
begin
    i0: DivisorFrequencia port map (CLK, novoclock);
    i1: Contador port map (novoclock, contador_out);
    
    contador_int <= to_integer(unsigned(contador_out));
    
    process(contador_int)
    begin
        LEDS <= (others => '0');
        if contador_int <= 9 then
            LEDS(contador_int) <= '1';
            unidade <= std_logic_vector(to_unsigned(contador_int, 4));
            dezena <= "0000";
        elsif contador_int = 10 then
            LEDS <= "1111111111";
            unidade <= "0000";
            dezena <= "0001";
        end if;
    end process;
    
    dec_unidade: Decod7segmentos port map (
        unidade(3), unidade(2), unidade(1), unidade(0),
        HEX0(0), HEX0(1), HEX0(2), HEX0(3), HEX0(4), HEX0(5), HEX0(6)
    );
    
    dec_dezena: Decod7segmentos port map (
        dezena(3), dezena(2), dezena(1), dezena(0),
        HEX1(0), HEX1(1), HEX1(2), HEX1(3), HEX1(4), HEX1(5), HEX1(6)
    );
    
end arch;