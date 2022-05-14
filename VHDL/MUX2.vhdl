library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_std.all;


ENTITY MUX2 IS 
	generic( N : integer := 16);

PORT(
    inp1   : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0); --input
    inp2   : in std_logic_vector(N-1 downto 0);
	 sel : in std_logic;
	 output:  out std_logic_vector(N-1 downto 0)
	 
);
END MUX2;

ARCHITECTURE MURCH2 OF MUX2 IS

BEGIN
    process(inp1,inp2,sel)
    begin
        case(sel) is
		  when '0' =>
			output <= inp1;
		  when '1' => 
			output <= inp2;
			end case;
    end process;
END MURCH2;
