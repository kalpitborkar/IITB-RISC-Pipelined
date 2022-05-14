library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;

entity decode6 is
port (instruction_in: in std_logic_vector(15 downto 0); prediction, cond_bit:in std_logic;
rf_wr, sel, PC_wr_en : out std_logic);
end decode6;

--conventions 
--sel 1 --> out1, 0 -->rb2

architecture behav of decode6 is
--detecting BEQ
signal a: std_logic:= ((instruction_in(15)) and (not(instruction_in(14))) and (not(instruction_in(13))) and (not (instruction_in(12))));
--detecting JLR
signal b: std_logic:= ((instruction_in(15)) and (not(instruction_in(14))) and ((instruction_in(13))) and (not (instruction_in(12))));

--detecing JRI
signal c: std_logic:= ((instruction_in(15)) and (not(instruction_in(14))) and ((instruction_in(13))) and ((instruction_in(12))));

--detecing SW
signal d: std_logic:= (not(instruction_in(15)) and ((instruction_in(14))) and (not(instruction_in(13))) and ((instruction_in(12))));

begin
decode: process(instruction_in, prediction, cond_bit) is
begin
if (a = '1') then
  rf_wr <= '0';
  if(prediction = cond_bit) then
  pc_wr_en <= '0';
  sel <= '1';
  else 
  pc_wr_en <= '0';
  sel <= '1';
  end if;
elsif (b ='1') then
  rf_wr <= '1';
  pc_wr_en <= '1';
  sel <= '0';
   
elsif(c ='1') then
  rf_wr <= '0';
  pc_wr_en <= '1';
  sel <= '1';
  
elsif(d = '1') then
  rf_wr <= '0';
  pc_wr_en <= '0';
  sel <= '1';
else 
  rf_wr <='1';
  pc_wr_en <= '0';
  sel <= '1';
 
end if;
end process;
end behav; 
  
 



