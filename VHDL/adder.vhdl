library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_std.all;

entity adder is
	generic ( N: integer:=16
  );
    Port ( INPUT1 : in  STD_LOGIC_VECTOR(N-1 downto 0);
			  INPUT2 : in STD_LOGIC_VECTOR(N-1 downto 0); 	
			  OUTPUT: out  STD_LOGIC_VECTOR(N-1 downto 0)
  );
end adder;
		
architecture notSub of adder is

begin 
process(INPUT1, INPUT2)
begin
			OUTPUT <= std_logic_vector(unsigned(INPUT1) + unsigned(INPUT2));
end process;
end notSub;