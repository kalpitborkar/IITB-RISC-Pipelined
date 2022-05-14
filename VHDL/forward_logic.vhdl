library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;

entity forward_logic is
port (ir3, ir4, ir5, out_rf, out_ex, out_mem, out1: in std_logic_vector(15 downto 0); read_addr, a31, a32, a33  :in std_logic_vector(2 downto 0);
stall_enable: out std_logic; output: out std_logic_vector(15 downto 0));
end forward_logic;

architecture behav of forward_logic is 

signal a3:  std_logic:= (ir3(15) and (not ir3(14)) and (ir3(13) xnor ir3(12))) or ((not ir3(15)) and (ir3(14)) 
								and (not ir3(13)) and (ir3(12)));
--detect BEQ, SW and JRI in ir3

signal b3:  std_logic:= ((not ir3(15)) and (ir3(14)) and (ir3(13)) and (ir3(12)));
--detect LW in ir3

signal a4:  std_logic:= (ir4(15) and (not ir4(14)) and (ir4(13) xnor ir4(12))) or ((not ir4(15)) and (ir4(14)) 
								and (not ir4(13)) and (ir4(12)));
--detect BEQ, SW and JRI in ir4

signal a5:  std_logic:= (ir5(15) and (not ir5(14)) and (ir5(13) xnor ir5(12))) or ((not ir5(15)) and (ir5(14)) 
								and (not ir5(13)) and (ir5(12)));
--detect BEQ, SW and JRI in ir5

signal en:  std_logic:= '0';

begin 
frwrd: process(ir3, ir4, ir5, out_rf, out_ex, out_mem, out1, read_addr, a31, a32, a33) is
begin
output <= out_rf;
if(en = '0') then
	en <= '0';
	if(a31 = read_addr and a3 = '0') then
		if(b3 = '1') then
			en <= '1';
		else
			output <= out_ex;
		end if;
			
	elsif (a32 = read_addr and a4 = '0') then
		output <= out_mem;
		
	elsif (a33 = read_addr and a5 = '0') then
		output <= out1;
	 
	else 
	NULL;
	end if;

else
	en <= '0';
	output <= out_mem;
end if;
stall_enable <= en;
end process;
end behav;