library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Instruction to be taken from EX stage 
--Pred is the prediction given for the instruction in the IR stage
--Comp is the comparator output
--the output is enable for the buffers at the stage interfaces, MSB for IF-OR interface and LSB for Mem-WR interface
--The output of this state machine needs to be bitwise anded with the output of the buffer_en entity to get the buffer enable
--The result after the and operation will be enables in the following format
--MSB is enable for stage1-2 and LSB is enable for stage5-6
entity buff_en2 is 
port(instruction_in : in std_logic_vector(15 downto 0); predn: in std_logic; comp: in std_logic;
   clock :in std_logic;
   buff_en: out std_logic_vector(4 downto 0));
	
end buff_en2;

architecture behav of buff_en2 is
---------------Define state type here-----------------------------
type state is (init,s1,s2,s3,s4,s5);
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
	       if ((instruction_in(15) and (not(instruction_in(14))) and (not(instruction_in(13))) and (not(instruction_in(12)))) = '1') then
			   if (not(predn = comp)) then
				y_next <= s1;
			   else 
			   y_next <= init;
			   end if;	
			 else 
			 y_next <= init;
			 end if;
	  when s1 =>
	       out_sig <= "00001";
	       y_next <= s2;
	  when s2 =>
          out_sig <= "10000";
	       y_next <= s3;
	  when s3 =>
          out_sig <= "11000";
	       y_next <= s4;
	  when s4 =>
          out_sig <= "11100";
	       y_next <= s5;
	  when s5 =>
          out_sig <= "11110";
	       y_next <= init;
	  end case;
buff_en <= out_sig;
end process;
end behav;