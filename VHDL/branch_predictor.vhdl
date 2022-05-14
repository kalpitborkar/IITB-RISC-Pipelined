library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;


entity Branch_predictor is
Port(PC_in: in STD_LOGIC_VECTOR(15 downto 0); PC_n: in STD_LOGIC_VECTOR(15 downto 0);instruction: in std_logic_vector(15 downto 0)
; instruction_n: in std_logic_vector(15 downto 0); tnt: in std_logic; predn: out std_logic
);
end Branch_predictor;

architecture behav of Branch_predictor is
type pred is array(0 to 39) of std_logic_vector(16 downto 0);
signal pred_array: pred:= (
    "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000",
	 "00000000000000000","00000000000000000");
signal beq : std_logic:= (instruction(15) and (not (instruction(14))) and (not (instruction(13))) and (not (instruction(12))));
signal beq_n : std_logic:= (instruction_n(15) and (not (instruction_n(14))) and (not (instruction_n(13))) and (not (instruction_n(12))));

begin
find: process(beq, PC_in) is
begin
if(beq = '1') then
    for i in 0 to 39 loop
	    if(to_integer(unsigned(pred_array(i)(16 downto 1)) )= to_integer(unsigned(PC_in)) ) then
		 predn <=  pred_array(i)(0);
		 elsif(pred_array(i)= "0000000000000000") then
       pred_array(i)(16 downto 1) <= PC_in;
       exit;
       end if;
    end loop;
end if;
end process find;

Update: process(PC_n, beq_n) is
begin
if(beq_n = '1') then
for i in 0 to 20 loop
if(pred_array(i)(16 downto 1) = PC_n ) then
pred_array(i)(0) <= tnt;
end if;
end loop;
end if;
end process update;
end behav;
