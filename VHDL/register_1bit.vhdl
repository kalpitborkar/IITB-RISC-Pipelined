library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_std.all;


ENTITY register1 IS 
	generic( N : integer := 1);

PORT(
    d   : IN STD_LOGIC; --input
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC -- output
);
END register1;

ARCHITECTURE regArch OF register1 IS

BEGIN
    process(clk)
    begin
        if clr = '1' then --clear register if clr is set
            q <= '0';
        elsif rising_edge(clk) then --write the register on rising edge of clock
            if ld = '1' then
                q <= d;
            end if;
        end if;
    end process;
END regArch;
