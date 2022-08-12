library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;
use work.pipeline_registers.all;

entity forwarding_RR_Ex is
port( destination : in std_logic_vector(2 downto 0);
      source1 : in std_logic_vector(2 downto 0);
      source2 : in std_logic_vector(2 downto 0);
      dependency_on_op1   : out std_logic;
		dependency_on_op2   : out std_logic);
end forwarding_RR_Ex;


architecture fre of forwarding_RR_Ex is


begin

process(source1 ,source2, destination)begin
if((     (source1="XXX")and(destination="XXX")and(source1 = destination)      )or(    (source2="XXX")and(destination="XXX")and(source2 = destination)   ))then
   dependency_on_op1<='0';
	dependency_on_op2<='0';
elsif ((source1 = destination))then
   dependency_on_op1<='1';
	dependency_on_op2<='0';
elsif((source2 = destination))then
   dependency_on_op1<='0';
	dependency_on_op2<='1';
else 
   dependency_on_op1<='0';
	dependency_on_op2<='0';
end if;
end process;






end fre;
