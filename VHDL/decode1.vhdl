library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;

entity decode1 is
port (instruction_in: in std_logic_vector(15 downto 0);
PC_in: in std_logic_vector(15 downto 0); imm: out std_logic_vector(15 downto 0); 
ra: out std_logic_vector(2 downto 0); A3: out std_logic_vector(2 downto 0);rb: out std_logic_vector(2 downto 0));
end decode1;

architecture behav of decode1 is
signal I: std_logic := ((instruction_in(15)) and (not(instruction_in(14))) and (not (instruction_in(13))) and (not (instruction_in(12)))) or 
     ( (not(instruction_in(15))) and (instruction_in(14)));
signal J:  std_logic:=(instruction_in(15) and (not(instruction_in(14))) and ( (instruction_in(13))) and ( (instruction_in(12))))
          or  (instruction_in(15) and (not (instruction_in(14))) and (not (instruction_in(13))) and ((instruction_in(12))))
			 or  (not(instruction_in(15)) and (not (instruction_in(14))) and (not (instruction_in(13))) and (not (instruction_in(12))));

signal a:  std_logic:=(not(instruction_in(15)) and (not (instruction_in(14))) and (not (instruction_in(13))) and ((instruction_in(12))))
           or (not(instruction_in(15)) and (not (instruction_in(14))) and ((instruction_in(13))) and (not (instruction_in(12))));	 

signal b:  std_logic:=(not(instruction_in(15)) and (not (instruction_in(14))) and (not (instruction_in(13))) and (not (instruction_in(12))));

begin 
data: process(instruction_in, PC_in) is 
begin
ra <= instruction_in(11 downto 9);
rb <= instruction_in(8 downto 6);
if(I = '1') then
    imm(5 downto 0) <= PC_in(5 downto 0);
   imm(15 downto 6) <= (15 downto 6 => PC_in(5));
elsif(J ='1') then
   imm(8 downto 0) <= PC_in(8 downto 0);
   imm(15 downto 9) <= (15 downto 9 => PC_in(8));
else 
   NULL;
end if;

if(a = '1') then
   A3 <= instruction_in(5 downto 3);
elsif(b ='1') then
   A3 <= instruction_in(8 downto 6);
else
   A3 <= instruction_in(11 downto 9);
end if;
end process;
end behav;
	
