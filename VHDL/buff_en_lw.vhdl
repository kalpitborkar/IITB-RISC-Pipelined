library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Instructions
--This entity stalls the buffer write mechanism for buffers before the ex stage
--this stalling is active when we have a load isntruction and the register being loaded is used in the next instruction
--The output of this enable needs to be bitwise anded with other buffer stalling entities to get the\
--final buffer enable bits.
entity buff_en3 is
port (en: in std_logic; buff_en: out std_logic_vector(4 downto 0));
end buff_en3;

architecture behav of buff_en3 is
begin
out_process: process(en) is
begin
if(en = '1') then
buff_en <= "00011";
else
buff_en <= "11111";
end if;
end process;
end behav;
