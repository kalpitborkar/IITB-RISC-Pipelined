library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;

entity decode3 is
port (instruction_in: in std_logic_vector(15 downto 0);
sel1: out std_logic; sel3 : out std_logic_vector(1 downto 0));
end decode3;

architecture behav of decode3 is
signal a:  std_logic:=(not(instruction_in(15)) and (not (instruction_in(14))) and (not (instruction_in(13))) and ((instruction_in(12))))
           or (not(instruction_in(15)) and (not (instruction_in(14))) and ((instruction_in(13))) and (not (instruction_in(12))));	 
signal b: std_logic:=(not(instruction_in(15)) and (not (instruction_in(14))) and (not (instruction_in(13))) and ((instruction_in(12))))
           or ((instruction_in(15)) and (not (instruction_in(14))) and (not(instruction_in(13))) and ((instruction_in(12))));

signal c:  std_logic:=(not(instruction_in(15)) and ((instruction_in(14))) and ((instruction_in(12))))
           or (not(instruction_in(15)) and (not (instruction_in(14))) and (not(instruction_in(13))) and (not (instruction_in(12))));	 
 
signal d:  std_logic:=((instruction_in(15)) and (not (instruction_in(14))) and (not (instruction_in(13))) )
           or ((instruction_in(15)) and (not (instruction_in(14))) and ((instruction_in(13))) and (not (instruction_in(12))));

begin 
decode: process(instruction_in)
begin
if(a = '1') then
 sel1 <= '0'; --select Rb
 sel3 <= "00"; --select Ra
elsif(b ='1') then
 sel1 <= '1'; --select imm
 sel3 <= "00"; --select Ra
elsif(c = '1') then
 sel1 <= '0'; --select Rb
 sel3 <= "01"; --select Immediate
elsif(d = '1') then
 sel1 <= '1'; --select Immediate
 sel3 <= "10"; --select PC
end if;
end process;
end behav;

