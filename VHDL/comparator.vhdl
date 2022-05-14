library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
port (inp1,inp2: in std_logic_vector(15 downto 0); comp: out std_logic);
end comparator;

architecture ohohoho of comparator is
begin
out_process: process(inp1,inp2) is
begin
if(inp1 = inp2) then
	comp <= '1';
else
	comp <= '0';
end if;
end process;
end ohohoho;