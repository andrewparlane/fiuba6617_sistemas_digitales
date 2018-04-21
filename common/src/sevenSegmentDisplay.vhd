library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenSegmentDisplay is
    port (bcd:                  in  unsigned(3 downto 0);
          sevenSegmentOutput:   out std_logic_vector(6 downto 0));
end entity sevenSegmentDisplay;

architecture synth of sevenSegmentDisplay is
    signal auxOut: std_logic_vector(6 downto 0);
begin

    -- los señales están activa baja.
    --
    --         0
    --      -------
    --      |     |
    --    5 |     | 1
    --      |  6  |
    --      -------
    --      |     |
    --    4 |     | 2
    --      |     |
    --      -------
    --         3

    with bcd select sevenSegmentOutput <=
            (not "0111111") when 4ux"0",
            (not "0000110") when 4ux"1",
            (not "1011011") when 4ux"2",
            (not "1001111") when 4ux"3",
            (not "1100110") when 4ux"4",
            (not "1101101") when 4ux"5",
            (not "1111101") when 4ux"6",
            (not "0000111") when 4ux"7",
            (not "1111111") when 4ux"8",
            (not "1101111") when 4ux"9",
            (not "0000000") when others;

end architecture synth;