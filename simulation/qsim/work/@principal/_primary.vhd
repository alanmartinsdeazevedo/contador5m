library verilog;
use verilog.vl_types.all;
entity Principal is
    port(
        CLK             : in     vl_logic;
        LEDS            : out    vl_logic_vector(9 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0)
    );
end Principal;
