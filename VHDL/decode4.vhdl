library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;

entity decode4 is
port (instruction_in: in std_logic_vector(15 downto 0); cy, z, comp :in std_logic;
cond_bit: out std_logic; flag_mod: out std_logic_vector(1 downto 0); op: out std_logic_vector(2 downto 0));
end decode4;

-- Convention
--ALU: 000 None, 001 Add, 010 increment, 011 Shift 1 and add, 100 shift 7 and add, 101 -Nand
-- Flag modification: 00 - none, 01 modify z, 11 modify c and z
architecture behav of decode4 is 
signal a:  std_logic:=(not(instruction_in(15)) and (not (instruction_in(14))) and (not (instruction_in(13))) and ((instruction_in(12))))
           or (not(instruction_in(15)) and ((instruction_in(14))) and (not(instruction_in(13))) and (not (instruction_in(12))));
--detect LW, SW and JRI
signal g:std_logic:= (not(instruction_in(15)) and ((instruction_in(14)))  and ( (instruction_in(12))))
			  or ((instruction_in(15)) and (not (instruction_in(14))) and ((instruction_in(13))) and ((instruction_in(12))));
--detect ADL instruction
signal b: std_logic:= (not(instruction_in(15)) and (not(instruction_in(14))) and (not(instruction_in(13))) and ((instruction_in(12))) and (instruction_in(0)) and instruction_in(1));

--detect NAND instructions 
signal c: std_logic:= (not(instruction_in(15)) and (not(instruction_in(14))) and ((instruction_in(13))) and (not (instruction_in(12))));

--detect LHI
signal d: std_logic:= (not(instruction_in(15)) and (not(instruction_in(14))) and (not(instruction_in(13))) and (not (instruction_in(12))));
 
--detecting BEQ
signal e: std_logic:= ((instruction_in(15)) and (not(instruction_in(14))) and (not(instruction_in(13))) and (not (instruction_in(12))));

--detecting JAL,JLR
signal f: std_logic:= ((instruction_in(15)) and (not(instruction_in(14))) and ((instruction_in(13))) and (not (instruction_in(12))))
          or ((instruction_in(15)) and (not(instruction_in(14))) and (not(instruction_in(13))) and ((instruction_in(12))));
			 

begin 
decode: process(instruction_in, cy, z, comp) is
begin
if(b = '1') then
 op <= "011";
 flag_mod <= "11";
 cond_bit <= '1';
 
elsif (a = '1') then
 if((((instruction_in(1) = '1') and ((instruction_in(0) = '0')))  and cy ='0') or (((((instruction_in(1) = '0')) and instruction_in(0) = '1')) and z = '0') ) then
 cond_bit <= '0';
 op <= "000";
 flag_mod <= "00";
 else 
 op <= "001";
 flag_mod <= "11";
 cond_bit <= '1';
 end if;
 
elsif(g = '1') then
 op <= "001";
 cond_bit <= '1';
 flag_mod <= "00";
 
 if((((instruction_in(1) = '1') and ((instruction_in(0) = '0')))  and cy ='0') or (((((instruction_in(1) = '0')) and instruction_in(0) = '1')) and z = '0') ) then

elsif(c= '1') then
  op <= "000";
  cond_bit <= '0';
  flag_mod <= "00";
  else 
  op <= "101";
  cond_bit <= '1';
  flag_mod <= "01";
  end if;

elsif(d = '1') then
 op <= "100";
 cond_bit <= '1';
 flag_mod <= "00";

elsif(e = '1') then
 flag_mod <= "00";
 if (comp = '1') then
 op <= "001"; 
 cond_bit <= '1';
 elsif(comp = '0') then
 op <= "010";
 cond_bit <= '0';
 end if;
 
elsif(f = '1') then
 op <= "010";
 cond_bit <= '1';
 flag_mod <= "00";
 
else 
NULL;
end if;
end process;
end behav;
  
 