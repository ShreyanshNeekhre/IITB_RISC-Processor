library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package essential_components is

type reg_rom is array (7 downto 0 ) of std_logic_vector(15 downto 0);

component reg is 
generic(n : integer); 
port( data_in : in std_logic_vector(n-1 downto 0);
       data_out : out std_logic_vector(n-1 downto 0):= (others=> 'X');
       clk,enable,clear : in std_logic);
end component;

component reg_1 is 

port( data_in : in std_logic;
       data_out : out std_logic:='X';
       clk,enable,clear : in std_logic);
end component;

component Instruction_Memory is
  port(  read_ena : in std_logic;
         address : in std_logic_vector(15 downto 0);
			instruction_out  : out std_logic_vector(15 downto 0):= (others=> 'X'));
end component;


component Instruction_decoder is 
port (instruction_IF_ID : in std_logic_vector(15 downto 0);--incoming inst
sign_extend  : out  std_logic_vector(1 downto 0):=(others=> 'X');--0 for 6 and 1 for 9
cond  : out std_logic_vector(1 downto 0):= (others=> 'X');--00,01,10,11
source1 : out std_logic_vector(2 downto 0):= (others=> 'X');
source2 : out std_logic_vector(2 downto 0):= (others=> 'X');
destination : out std_logic_vector(2 downto 0):= (others=> 'X');
whether_lw_or_sw  : out std_logic_vector(1 downto 0):= (others=> 'X');--0 for lw and 1 for sw
alu_operation : out std_logic_vector(1 downto 0):= (others=> 'X');---0 for add and 1 for nand 
flags   : out std_logic_vector(1 downto 0):= (others=> 'X');--00(),01(c),10(z),11(cz)
shiftleftB_or_not  : out std_logic_vector(1 downto 0):= (others=> 'X');--1 for shift regB left by 1 
write_on_reg_or_mem : out std_logic_vector(1 downto 0):= (others=> 'X')-- 0 for reg and 1 for mem
);
end component;


component sign_extend_entity is 
port( sign_extend : in  std_logic_vector(1 downto 0);
      sign_extended_Imm_stream : buffer std_logic_vector(15 downto 0):= (others=> 'X');
		pc_IF_ID : in std_logic_vector(15 downto 0);
      instruction_IF_ID : in std_logic_vector(15 downto 0);
		pc_plus_Imm : out std_logic_vector(15 downto 0):= (others=> 'X'));
end component;


component register_file is 
port ( sel_in : in std_logic_vector(2 downto 0);
       sel_out1 ,sel_out2  : in std_logic_vector(2 downto 0);
       write_ena : in std_logic;
		 data_in : in std_logic_vector(15 downto 0);
        clear : in std_logic;
        R7_ena  : in std_logic;
         R7_in  : in std_logic_vector(15 downto 0 );
			data_out1,data_out2 : out std_logic_vector(15 downto 0):= (others=> '0');
			R0 : out std_logic_vector(15 downto 0):= (others=> '0');
			clk : in std_logic;
		    
			 R1 : out std_logic_vector(15 downto 0 );
			 R2 : out std_logic_vector(15 downto 0 );
			 R3 : out std_logic_vector(15 downto 0 );
			 R4 : out std_logic_vector(15 downto 0 );
			 R5 : out std_logic_vector(15 downto 0 );
			 R6 : out std_logic_vector(15 downto 0 );
			 R7 : out std_logic_vector(15 downto 0 );
			ena_demo : out std_logic_vector(7 downto 0) 	
			); 
end component;



component  alu is 
port ( 
		 data_out1_EX : in std_logic_vector(15 downto 0);
		 data_out2_EX : in std_logic_vector(15 downto 0);
		 shifted_data_out2_EX : in std_logic_vector(15 downto 0);
       alu_operation_EX : in std_logic_vector(1 downto 0);
       flags_EX   : in std_logic_vector(1 downto 0);
       whether_lw_or_sw_EX  : in std_logic_vector(1 downto 0);
       cond_EX  : in std_logic_vector(1 downto 0);
		 sign_extend_EX  : in  std_logic_vector(1 downto 0);
		 sign_extended_Imm_stream_EX : in std_logic_vector(15 downto 0);
		 instruction_EX : in std_logic_vector(15 downto 0);
			carry_flag : out std_logic;
			zero_flag : out std_logic;
			result_alu : out std_logic_vector(15 downto 0));



end component;

component left_shift is 
port(
data_out2_EX : in std_logic_vector(15 downto 0);
shiftleftB_or_not_EX : in std_logic_vector(1 downto 0);--10 for shift regB left by 1 
shifted_data_out2_EX  : out std_logic_vector(15 downto 0)
);
end component;


component data_memory is
port(data_in : in std_logic_vector(15 downto 0);
     address_to_write : in std_logic_vector(7 downto 0);
	  address_to_read : in std_logic_vector(7 downto 0);
      data_out  : out std_logic_vector(15 downto 0);
		clk,w_ena,r_ena,clear  : in std_logic);
end component;


		 
component write_back is 
port( carry_flag_WB : in std_logic;
       zero_flag_WB  : in std_logic;
       instruction_WB : in std_logic_vector(15 downto 0);
       data_that_came_from_memory_WB : in std_logic_vector(15 downto 0);
       result_alu_WB : in std_logic_vector(15 downto 0);
		 
		 pc_WB : in std_logic_vector(15 downto 0);
		 pc_plus_Imm_WB : in std_logic_vector(15 downto 0);
		 
		 write_on_reg_or_mem_WB : in std_logic_vector(1 downto 0);
		 destination_WB : in std_logic_vector(2 downto 0);
		 data_out1_WB: in std_logic_vector(15 downto 0);-----------------------register file data
		 whether_lw_or_sw_WB : in std_logic_vector(1 downto 0);
       data_came_from_WB : out std_logic_vector(15 downto 0):=(others=>'X');
		 
		 
		 destination_came_from_WB : out std_logic_vector(2 downto 0);
		 register_write_enable : out std_logic;
		 
		 
		 mem_write_enable : out std_logic

);
end component;

component forwarding_RR_Ex is
port( destination : in std_logic_vector(2 downto 0);
      source1 : in std_logic_vector(2 downto 0);
      source2 : in std_logic_vector(2 downto 0);
		dependency_on_op1   : out std_logic;
		dependency_on_op2   : out std_logic
);
end component;
component forwarding_RR_MM is
port( destination : in std_logic_vector(2 downto 0);
      source1 : in std_logic_vector(2 downto 0);
      source2 : in std_logic_vector(2 downto 0);
		dependency_on_op1   : out std_logic;
		dependency_on_op2   : out std_logic
);
end component;
component forwarding_RR_WB is
port( destination : in std_logic_vector(2 downto 0);
      source1 : in std_logic_vector(2 downto 0);
      source2 : in std_logic_vector(2 downto 0);
      dependency_on_op1   : out std_logic;
		dependency_on_op2   : out std_logic);
end component;


end essential_components;
------------------------------------------------------------------------------------------------------
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity reg_1 is 

port( data_in : in std_logic;
       data_out : out std_logic:='X';
       clk,enable,clear : in std_logic);
end reg_1;

architecture areg_1 of reg_1 is 
begin
 process(clk,clear,enable)
 begin
 
    if (clk'event and clk='1') then
      
		if (enable = '1') then
               data_out <= data_in;
	   end if;
	   if (clear = '1' ) then
               data_out <= '0';
		end if;
	end if;
 end process;
end areg_1;
------------------------------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity reg is 
generic( n : integer);
port( data_in : in std_logic_vector(n-1 downto 0);
       data_out : out std_logic_vector(n-1 downto 0):= (others=> 'X');
       clk,enable,clear : in std_logic);
end reg;

architecture areg of reg is 
begin
 process(clk,clear,enable)
 begin
 
    if (clk'event and clk='1') then
      
		if (enable = '1') then
               data_out <= data_in;
	   end if;
	   if (clear = '1' ) then
               data_out <= (others=>'0');
		end if;
	end if;
 end process;
end areg;

---------------------------------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity sign_extend_entity is 
port( sign_extend : in  std_logic_vector(1 downto 0);
      sign_extended_Imm_stream : buffer std_logic_vector(15 downto 0):= (others=> 'X');
		pc_IF_ID : in std_logic_vector(15 downto 0);
      instruction_IF_ID : in std_logic_vector(15 downto 0);
		pc_plus_Imm : out std_logic_vector(15 downto 0):= (others=> 'X'));
end sign_extend_entity;



architecture se of sign_extend_entity is
begin

process(sign_extend,instruction_IF_ID)
begin 

if (sign_extend = "01") then
sign_extended_Imm_stream <= ( 15 downto 6 =>instruction_IF_ID(5)) & instruction_IF_ID(5 downto 0);

elsif (sign_extend = "10") then 
sign_extended_Imm_stream <= ( 15 downto 9 =>instruction_IF_ID(8)) & instruction_IF_ID(8 downto 0);

else 
sign_extended_Imm_stream <= "XXXXXXXXXXXXXXXX";
end if;

end process;

pc_plus_Imm<=std_logic_vector(unsigned(pc_IF_ID) + unsigned(sign_extended_Imm_stream));

end se;
---------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;






entity left_shift is 
port(
data_out2_EX : in std_logic_vector(15 downto 0);
shiftleftB_or_not_EX : in std_logic_vector(1 downto 0);--10 for shift regB left by 1 
shifted_data_out2_EX  : out std_logic_vector(15 downto 0)
);
end left_shift;


architecture left_shift_arch of left_shift is
begin 

shifted_data_out2_EX<= (data_out2_EX(14 downto 0) & '0') when shiftleftB_or_not_EX= "10" else "XXXXXXXXXXXXXXXX" ;

end left_shift_arch;


