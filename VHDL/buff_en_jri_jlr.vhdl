library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--instruction is take from stage 1(IF stage)
--the output is enable for the buffers at the stage interfaces, MSB for stage1-2 interface and LSB for stage5-6 interface

entity buffer_en is
port(clock: in std_logic; instruction_in :in std_logic_vector(15 downto 0); buff_en :out std_logic_vector(4 downto 0));
end buffer_en;

architecture behav of buffer_en is
---------------Define state type here-----------------------------
type state is (init,s1,s2,s3,s4,s5,s6, s7, s8);
---------------Define signals of state type-----------------------
signal y_present,y_next: state:=init;
signal out_sig: std_logic_vector(4 downto 0);

begin
clock_proc:process(clock)
begin
    if(clock='1' and clock' event) then
    y_present <= y_next;
    end if;
    
end process;

state_process: process(instruction_in, y_present) 
begin
case y_present is 
     when init =>
	       out_sig <= "11111";
	       if ((instruction_in(15) and (not(instruction_in(14))) and instruction_in(13)) = '1') then
			 y_next<= s1;
			 else 
			 y_next <= init;
			 end if;
	  when s1 =>
	       out_sig <= "01111";
	       y_next <= s2;
	  when s2 =>
          out_sig <= "00111";
	       y_next <= s3;
	  when s3 =>
          out_sig <= "00011";
	       y_next <= s4;
	  when s4 =>
          out_sig <= "00001";
	       y_next <= s5;
	  when s5 =>
          out_sig <= "10000";
	       y_next <= s6;
	  when s6 =>
          out_sig <= "11000";
	       y_next <= s7;
	  when s7 =>
          out_sig <= "11100";
	       y_next <= s8;
	  when s8 =>
          out_sig <= "11110";
	       y_next <= init;
end case;
buff_en <= out_sig;
end process;
end behav;