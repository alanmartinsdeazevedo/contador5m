library verilog;
use verilog.vl_types.all;
entity Principal_vlg_check_tst is
    port(
        HEX0            : in     vl_logic_vector(6 downto 0);
        HEX1            : in     vl_logic_vector(6 downto 0);
        LEDS            : in     vl_logic_vector(9 downto 0);
        sampler_rx      : in     vl_logic
    );
end Principal_vlg_check_tst;
