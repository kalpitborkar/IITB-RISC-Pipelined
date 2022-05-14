library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;


entity decode0 is
port (instruction_in: in std_logic_vector(15 downto 0); imm: out std_logic_vector(15 downto 0);
 pc_in: in std_logic_vector(15 downto 0); en : out std_logic; jal_en : out std_logic);
end decode0;

architecture behav of decode0 is 
signal beq: std_logic:=(instruction_in(15) and (not (instruction_in(14))) and (not (instruction_in(13))) and (not (instruction_in(12))));
signal jal: std_logic:= (instruction_in(15) and (not (instruction_in(14))) and (not (instruction_in(13))) and ((instruction_in(12))));
begin
process(beq, jal, instruction_in)
begin
if (beq = '1') then
   imm(5 downto 0) <= PC_in(5 downto 0);
   imm(15 downto 6) <= (15 downto 6 => PC_in(5));
	en <= '1';
	jal <= '0';
	
elsif (jal ='1') then
   imm(8 downto 0) <= PC_in(8 downto 0);
   imm(15 downto 9) <= (15 downto 9 => PC_in(8));
   en <= '0';
	jal <= '1';
else 
   en <= '0';
	jal <= '0';
end if;
end process;
end behav;
   