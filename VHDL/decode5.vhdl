library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;

entity decode5 is
port (instruction_in: in std_logic_vector(15 downto 0);
wr_en: out std_logic; sel : out std_logic);
end decode5;
--convention
-- sel 1 -->data_out, 0 --> out

architecture behav of decode5 is
signal lw :std_logic:=(not(instruction_in(15)) and ((instruction_in(14))) and ((instruction_in(13))) and ((instruction_in(12))));
signal sw : std_logic:=(not(instruction_in(15)) and ((instruction_in(14))) and (not (instruction_in(13))) and ((instruction_in(12))));
begin
cont: process(instruction_in) is
begin
if(lw ='1') then
sel <= '1';
wr_en <= '0';
elsif(sw ='1') then
sel <= '0';
wr_en <= '1';
else 
sel <= '0';
wr_en <= '0';
end if;
end process;
end behav;