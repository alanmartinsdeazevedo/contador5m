library ieee;
use ieee.std_logic_1164.all;

entity Decod7segmentos is
	port (
		i3, i2, i1, i0: in std_logic;
		a, b, c, d, e, f, g: out std_logic
	);
end Decod7segmentos;

architecture arc of Decod7segmentos is
begin
	-- Tabela verdade correta para display de 7 segmentos (catodo comum)
	-- Numeros 0-9: segmentos ativos em nivel alto
	a <= (not i3 and not i2 and not i1 and not i0) or  -- 0
	     (not i3 and not i2 and i1 and not i0) or      -- 2
	     (not i3 and not i2 and i1 and i0) or          -- 3
	     (not i3 and i2 and not i1 and i0) or          -- 5
	     (not i3 and i2 and i1 and not i0) or          -- 6
	     (not i3 and i2 and i1 and i0) or              -- 7
	     (i3 and not i2 and not i1 and not i0) or      -- 8
	     (i3 and not i2 and not i1 and i0);            -- 9
	          
	b <= (not i3 and not i2 and not i1 and not i0) or  -- 0
	     (not i3 and not i2 and not i1 and i0) or      -- 1
	     (not i3 and not i2 and i1 and not i0) or      -- 2
	     (not i3 and not i2 and i1 and i0) or          -- 3
	     (not i3 and i2 and not i1 and not i0) or      -- 4
	     (not i3 and i2 and i1 and i0) or              -- 7
	     (i3 and not i2 and not i1 and not i0) or      -- 8
	     (i3 and not i2 and not i1 and i0);            -- 9
	          
	c <= (not i3 and not i2 and not i1 and not i0) or  -- 0
	     (not i3 and not i2 and not i1 and i0) or      -- 1
	     (not i3 and not i2 and i1 and i0) or          -- 3
	     (not i3 and i2 and not i1 and not i0) or      -- 4
	     (not i3 and i2 and not i1 and i0) or          -- 5
	     (not i3 and i2 and i1 and not i0) or          -- 6
	     (not i3 and i2 and i1 and i0) or              -- 7
	     (i3 and not i2 and not i1 and not i0) or      -- 8
	     (i3 and not i2 and not i1 and i0);            -- 9
	          
	d <= (not i3 and not i2 and not i1 and not i0) or  -- 0
	     (not i3 and not i2 and i1 and not i0) or      -- 2
	     (not i3 and not i2 and i1 and i0) or          -- 3
	     (not i3 and i2 and not i1 and i0) or          -- 5
	     (not i3 and i2 and i1 and not i0) or          -- 6
	     (i3 and not i2 and not i1 and not i0) or      -- 8
	     (i3 and not i2 and not i1 and i0);            -- 9
	          
	e <= (not i3 and not i2 and not i1 and not i0) or  -- 0
	     (not i3 and not i2 and i1 and not i0) or      -- 2
	     (not i3 and i2 and i1 and not i0) or          -- 6
	     (i3 and not i2 and not i1 and not i0);        -- 8
	          
	f <= (not i3 and not i2 and not i1 and not i0) or  -- 0
	     (not i3 and i2 and not i1 and not i0) or      -- 4
	     (not i3 and i2 and not i1 and i0) or          -- 5
	     (not i3 and i2 and i1 and not i0) or          -- 6
	     (i3 and not i2 and not i1 and not i0) or      -- 8
	     (i3 and not i2 and not i1 and i0);            -- 9
	          
	g <= (not i3 and not i2 and i1 and not i0) or      -- 2
	     (not i3 and not i2 and i1 and i0) or          -- 3
	     (not i3 and i2 and not i1 and not i0) or      -- 4
	     (not i3 and i2 and not i1 and i0) or          -- 5
	     (not i3 and i2 and i1 and not i0) or          -- 6
	     (i3 and not i2 and not i1 and not i0) or      -- 8
	     (i3 and not i2 and not i1 and i0);            -- 9
end arc;