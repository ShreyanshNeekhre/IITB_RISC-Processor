library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;


package pipeline_registers is


component IF_ID is 
port ( enable_IF_ID : in std_logic;
clear : in std_logic;
pc_plus : in std_logic_vector(15 downto 0);
pc : in std_logic_vector(15 downto 0);
clk : in std_logic;
software_stall : in std_logic;
instruction  : in std_logic_vector(15 downto 0);
instruction_IF_ID  : out std_logic_vector(15 downto 0):= (others=> 'X');
pc_plus_IF_ID: out  std_logic_vector(15 downto 0):= (others=> 'X');
pc_IF_ID : out std_logic_vector(15 downto 0):= (others=> 'X'));
end component;


component ID_RR is 
port ( clk : in std_logic;
       enable_ID_RR : in std_logic;
		 clear  : in std_logic;
		 
       instruction_IF_ID : in std_logic_vector(15 downto 0);
       sign_extended_Imm_stream : in std_logic_vector(15 downto 0);
		 pc_IF_ID : in std_logic_vector(15 downto 0);
		 pc_plus_Imm : in std_logic_vector(15 downto 0);
		sign_extend  : in  std_logic_vector(1 downto 0);--0 for 6 and 1 for 9
			cond  : in std_logic_vector(1 downto 0);--00,01,10,11
			source1 : in std_logic_vector(2 downto 0);
			source2 : in std_logic_vector(2 downto 0);
			destination : in std_logic_vector(2 downto 0);
			whether_lw_or_sw  : in std_logic_vector(1 downto 0);--0 for lw and 1 for sw
			alu_operation : in std_logic_vector(1 downto 0);---0 for add and 1 for nand 
			flags   : in std_logic_vector(1 downto 0);--00(),01(c),10(z),11(cz)
			shiftleftB_or_not  : in std_logic_vector(1 downto 0);--1 for shift regB left by 1 
			write_on_reg_or_mem : in std_logic_vector(1 downto 0);-- 0 for reg and 1 for mem);
	
			
		 instruction_ID_RR : out std_logic_vector(15 downto 0):= (others=> 'X');
       sign_extended_Imm_stream_ID_RR : out std_logic_vector(15 downto 0):= (others=> 'X');
		 pc_ID_RR : out std_logic_vector(15 downto 0):= (others=> 'X');
		 pc_plus_Imm_ID_RR : out std_logic_vector(15 downto 0):= (others=> 'X');
		 sign_extend_ID_RR  : out  std_logic_vector(1 downto 0);--0 for 6 and 1 for 9
			cond_ID_RR  : out std_logic_vector(1 downto 0):= (others=> 'X');--00,01,10,11
			source1_ID_RR : out std_logic_vector(2 downto 0):= (others=> 'X');
			source2_ID_RR : out std_logic_vector(2 downto 0):= (others=> 'X');
			destination_ID_RR : out std_logic_vector(2 downto 0):= (others=> 'X');
			whether_lw_or_sw_ID_RR  : out std_logic_vector(1 downto 0):= (others=> 'X');--0 for lw and 1 for sw
			alu_operation_ID_RR : out std_logic_vector(1 downto 0):= (others=> 'X');---0 for add and 1 for nand 
			flags_ID_RR   : out std_logic_vector(1 downto 0):= (others=> 'X');--00(),01(c),10(z),11(cz)
			shiftleftB_or_not_ID_RR  : out std_logic_vector(1 downto 0):= (others=> 'X');--1 for shift regB left by 1 
			write_on_reg_or_mem_ID_RR : out std_logic_vector(1 downto 0):= (others=> 'X')-- 0 for reg and 1 for mem);
);

end component;
 
component  RR_EX is 
port ( clk : in std_logic;
       enable_RR_EX : in std_logic;
		 clear  : in std_logic;
		 
		 source1_ID_RR : in std_logic_vector(2 downto 0);
		 source2_ID_RR : in std_logic_vector(2 downto 0);
		 destination_ID_RR : in std_logic_vector(2 downto 0);
		 
		 source1_EX : out std_logic_vector(2 downto 0):=(others=>'X');
		 source2_EX : out std_logic_vector(2 downto 0):=(others=>'X');
		 destination_EX : out std_logic_vector(2 downto 0):=(others=>'X');
		 
		 shiftleftB_or_not_ID_RR : in std_logic_vector(1 downto 0);
		 shiftleftB_or_not_EX : out std_logic_vector(1 downto 0):=(others=>'X');
		 
		 write_on_reg_or_mem_ID_RR : in std_logic_vector(1 downto 0);
		 write_on_reg_or_mem_EX : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 alu_operation_ID_RR : in std_logic_vector(1 downto 0);
		 alu_operation_EX : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 flags_ID_RR   : in std_logic_vector(1 downto 0);
		 flags_EX   : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 whether_lw_or_sw_ID_RR  : in std_logic_vector(1 downto 0);
		 whether_lw_or_sw_EX  : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 cond_ID_RR  : in std_logic_vector(1 downto 0);
		 cond_EX  : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 sign_extend_ID_RR  : in  std_logic_vector(1 downto 0);
		 sign_extend_EX  : out  std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 instruction_ID_RR : in std_logic_vector(15 downto 0);
		 instruction_EX : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 
       sign_extended_Imm_stream_ID_RR : in std_logic_vector(15 downto 0);
		 sign_extended_Imm_stream_EX : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 pc_ID_RR : in std_logic_vector(15 downto 0);
		 pc_EX : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 pc_plus_Imm_ID_RR : in std_logic_vector(15 downto 0);
		 pc_plus_Imm_EX : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 
		 data_out1: in std_logic_vector(15 downto 0);
		 data_out2: in std_logic_vector(15 downto 0); 
		 
		 
		 data_out1_EX: out std_logic_vector(15 downto 0);
		 data_out2_EX: out std_logic_vector(15 downto 0));
		 
		 end component;
		 
component EX_MM is 
port ( clk : in std_logic;
       enable_EX_MM : in std_logic;
		 clear  : in std_logic;
		 
		 
		 
	    result_alu : in std_logic_vector(15 downto 0);
		 whether_lw_or_sw_EX : in std_logic_vector(1 downto 0);
		 pc_EX : in std_logic_vector(15 downto 0);
		 pc_plus_Imm_EX : in std_logic_vector(15 downto 0);
		 instruction_EX : in std_logic_vector(15 downto 0);
		 write_on_reg_or_mem_EX : in std_logic_vector(1 downto 0);
		 destination_EX : in std_logic_vector(2 downto 0);
		 data_out1_EX : in std_logic_vector(15 downto 0);
		 carry_flag : in std_logic;
		 zero_flag : in std_logic;
		 
		 result_alu_MM : out std_logic_vector(15 downto 0):= (others=> 'X');
		 whether_lw_or_sw_MM : out std_logic_vector(1 downto 0):= (others=> 'X');
		 pc_MM : out std_logic_vector(15 downto 0):= (others=> 'X');
		 pc_plus_Imm_MM : out std_logic_vector(15 downto 0):= (others=> 'X');
		 instruction_MM : out std_logic_vector(15 downto 0):= (others=> 'X');
		 write_on_reg_or_mem_MM : out std_logic_vector(1 downto 0):= (others=> 'X');
		 destination_MM : out std_logic_vector(2 downto 0):= (others=> 'X');
		 data_out1_MM: out std_logic_vector(15 downto 0):= (others=> 'X');
		 carry_flag_MM : out std_logic:='X';
		 zero_flag_MM : out std_logic:='X'
		 
		 
		 );
		 
		 end component;
		 
component MM_WB is 
port ( clk : in std_logic;
       enable_MM_WB : in std_logic;
		 clear  : in std_logic;
		 
		 result_alu_MM : in std_logic_vector(15 downto 0);
		 
		 pc_MM : in std_logic_vector(15 downto 0);
		 pc_plus_Imm_MM : in std_logic_vector(15 downto 0);
		 
		 write_on_reg_or_mem_MM : in std_logic_vector(1 downto 0);
		 destination_MM : in std_logic_vector(2 downto 0);
		 data_out1_MM : in std_logic_vector(15 downto 0);---------------------data that came from register A
		 whether_lw_or_sw_MM : in std_logic_vector(1 downto 0);
		 data_that_came_from_memory_MM : in std_logic_vector(15 downto 0);
		 instruction_MM : in std_logic_vector(15 downto 0);
		 carry_flag_MM : in std_logic;
		 zero_flag_MM  : in std_logic;
		 
		 result_alu_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 pc_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 pc_plus_Imm_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 write_on_reg_or_mem_WB : out std_logic_vector(1 downto 0):= (others=> 'X');
		 destination_WB : out std_logic_vector(2 downto 0):= (others=> 'X');
		 data_out1_WB: out std_logic_vector(15 downto 0):= (others=> 'X');--------------------data that came from register A
		 whether_lw_or_sw_WB : out std_logic_vector(1 downto 0):= (others=> 'X');
		 data_that_came_from_memory_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 instruction_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 carry_flag_WB : out std_logic:='X';
		 zero_flag_WB  : out std_logic:='X'
		 
		 );
		 
		 end component;
end package;



-------------------------------------------------------------------------------------------------------------------




library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;

entity IF_ID is 
port ( enable_IF_ID : in std_logic;
clear : in std_logic;
pc_plus : in std_logic_vector(15 downto 0);
pc : in std_logic_vector(15 downto 0);
clk : in std_logic;
software_stall : in std_logic;
instruction  : in std_logic_vector(15 downto 0);
instruction_IF_ID  : out std_logic_vector(15 downto 0):= (others=> 'X');
pc_plus_IF_ID: out  std_logic_vector(15 downto 0):= (others=> 'X');
pc_IF_ID : out std_logic_vector(15 downto 0):= (others=> 'X'));
end IF_ID;

architecture IF_ID_arch of IF_ID is

signal trans_instruction  : std_logic_vector(15 downto 0);

begin

trans_instruction <= "0000000000000000" when (software_stall='1') else instruction; 
instruction_instance : reg generic map(16) port map (trans_instruction,instruction_IF_ID,clk,enable_IF_ID,clear);
PC_plus_instance : reg generic map (16) port map (pc_plus,pc_plus_IF_ID,clk,enable_IF_ID,clear);
PC_instance      : reg generic map (16) port map (pc,pc_IF_ID,clk,enable_IF_ID,clear);

end IF_ID_arch;



----------------------------------------------------------------------------------------------------------------------





library ieee;
use ieee.numeric_std.all;   
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;

entity ID_RR is 
port ( clk : in std_logic;
       enable_ID_RR : in std_logic;
		 clear  : in std_logic;
		 
       instruction_IF_ID : in std_logic_vector(15 downto 0);
       sign_extended_Imm_stream : in std_logic_vector(15 downto 0);
		 pc_IF_ID : in std_logic_vector(15 downto 0);
		 pc_plus_Imm : in std_logic_vector(15 downto 0);
		 sign_extend  : in  std_logic_vector(1 downto 0);--0 for 6 and 1 for 9
			cond  : in std_logic_vector(1 downto 0);--00,01,10,11
			source1 : in std_logic_vector(2 downto 0);
			source2 : in std_logic_vector(2 downto 0);
			destination : in std_logic_vector(2 downto 0);
			whether_lw_or_sw  : in std_logic_vector(1 downto 0);--0 for lw and 1 for sw
			alu_operation : in std_logic_vector(1 downto 0);---0 for add and 1 for nand 
			flags   : in std_logic_vector(1 downto 0);--00(),01(c),10(z),11(cz)
			shiftleftB_or_not  : in std_logic_vector(1 downto 0);--1 for shift regB left by 1 
			write_on_reg_or_mem : in std_logic_vector(1 downto 0);-- 0 for reg and 1 for mem);
	
			
		 instruction_ID_RR : out std_logic_vector(15 downto 0):= (others=> 'X');
       sign_extended_Imm_stream_ID_RR : out std_logic_vector(15 downto 0):= (others=> 'X');
		 pc_ID_RR : out std_logic_vector(15 downto 0):= (others=> 'X');
		 pc_plus_Imm_ID_RR : out std_logic_vector(15 downto 0):= (others=> 'X');
		 sign_extend_ID_RR  : out  std_logic_vector(1 downto 0);--0 for 6 and 1 for 9
			cond_ID_RR  : out std_logic_vector(1 downto 0):= (others=> 'X');--00,01,10,11
			source1_ID_RR : out std_logic_vector(2 downto 0):= (others=> 'X');
			source2_ID_RR : out std_logic_vector(2 downto 0):= (others=> 'X');
			destination_ID_RR : out std_logic_vector(2 downto 0):= (others=> 'X');
			whether_lw_or_sw_ID_RR  : out std_logic_vector(1 downto 0):= (others=> 'X');--0 for lw and 1 for sw
			alu_operation_ID_RR : out std_logic_vector(1 downto 0):= (others=> 'X');---0 for add and 1 for nand 
			flags_ID_RR   : out std_logic_vector(1 downto 0):= (others=> 'X');--00(),01(c),10(z),11(cz)
			shiftleftB_or_not_ID_RR  : out std_logic_vector(1 downto 0):= (others=> 'X');--1 for shift regB left by 1 
			write_on_reg_or_mem_ID_RR : out std_logic_vector(1 downto 0):= (others=> 'X')-- 0 for reg and 1 for mem);
);
end ID_RR;

architecture ID_RR_arch of ID_RR is 
begin 

instruction_IF_ID_instance : reg generic map (16) port map (instruction_IF_ID,instruction_ID_RR,clk,enable_ID_RR,clear);
sign_extended_Imm_stream_instance : reg generic map (16) port map (sign_extended_Imm_stream,sign_extended_Imm_stream_ID_RR,clk,enable_ID_RR,clear);
pc_IF_ID_instance : reg generic map (16) port map (pc_IF_ID,pc_ID_RR,clk,enable_ID_RR,clear);
pc_plus_Imm_instance : reg generic map (16) port map (pc_plus_Imm,pc_plus_Imm_ID_RR,clk,enable_ID_RR,clear);
sign_extend_instance : reg generic map (2) port map (sign_extend,sign_extend_ID_RR,clk,enable_ID_RR,clear);
cond_instance : reg generic map (2) port map (cond,cond_ID_RR,clk,enable_ID_RR,clear);
source1_instance : reg generic map (3) port map (source1,source1_ID_RR,clk,enable_ID_RR,clear);
source2_instance : reg generic map (3) port map (source2,source2_ID_RR,clk,enable_ID_RR,clear);
destination_instance : reg generic map (3) port map (destination,destination_ID_RR,clk,enable_ID_RR,clear);
whether_lw_or_sw_instance : reg generic map (2) port map (whether_lw_or_sw,whether_lw_or_sw_ID_RR,clk,enable_ID_RR,clear);
alu_operation_instance : reg generic map (2)port map (alu_operation,alu_operation_ID_RR,clk,enable_ID_RR,clear);
flags_instance : reg generic map (2) port map (flags,flags_ID_RR,clk,enable_ID_RR,clear);
shiftleftB_or_not_instance : reg generic map (2) port map (shiftleftB_or_not,shiftleftB_or_not_ID_RR,clk,enable_ID_RR,clear);
write_on_reg_or_mem_instance : reg generic map (2) port map (write_on_reg_or_mem,write_on_reg_or_mem_ID_RR,clk,enable_ID_RR,clear);


end ID_RR_arch;
-----------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;   
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;

entity RR_EX is 
port ( clk : in std_logic;
       enable_RR_EX : in std_logic;
		 clear  : in std_logic;
		 
		 source1_ID_RR : in std_logic_vector(2 downto 0);
		 source2_ID_RR : in std_logic_vector(2 downto 0);
		 destination_ID_RR : in std_logic_vector(2 downto 0);
		 
		 source1_EX : out std_logic_vector(2 downto 0):=(others=>'X');
		 source2_EX : out std_logic_vector(2 downto 0):=(others=>'X');
		 destination_EX : out std_logic_vector(2 downto 0):=(others=>'X');
		 
		 shiftleftB_or_not_ID_RR : in std_logic_vector(1 downto 0);
		 shiftleftB_or_not_EX : out std_logic_vector(1 downto 0):=(others=>'X');
		 
		 write_on_reg_or_mem_ID_RR : in std_logic_vector(1 downto 0);
		 write_on_reg_or_mem_EX : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 alu_operation_ID_RR : in std_logic_vector(1 downto 0);
		 alu_operation_EX : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 flags_ID_RR   : in std_logic_vector(1 downto 0);
		 flags_EX   : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 whether_lw_or_sw_ID_RR  : in std_logic_vector(1 downto 0);
		 whether_lw_or_sw_EX  : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 cond_ID_RR  : in std_logic_vector(1 downto 0);
		 cond_EX  : out std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 sign_extend_ID_RR  : in  std_logic_vector(1 downto 0);
		 sign_extend_EX  : out  std_logic_vector(1 downto 0):= (others=> 'X');
		 
		 instruction_ID_RR : in std_logic_vector(15 downto 0);
		 instruction_EX : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 
       sign_extended_Imm_stream_ID_RR : in std_logic_vector(15 downto 0);
		 sign_extended_Imm_stream_EX : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 pc_ID_RR : in std_logic_vector(15 downto 0);
		 pc_EX : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 pc_plus_Imm_ID_RR : in std_logic_vector(15 downto 0);
		 pc_plus_Imm_EX : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 data_out1: in std_logic_vector(15 downto 0);
		 data_out2: in std_logic_vector(15 downto 0); 
		 
		 
		 data_out1_EX: out std_logic_vector(15 downto 0):= (others=> 'X');
		 data_out2_EX: out std_logic_vector(15 downto 0):= (others=> 'X'));
		 
		 end RR_EX;
		 
architecture RR_EX_arch of RR_EX is
begin

instruction_RR_EX_instance : reg generic map (16) port map (instruction_ID_RR,instruction_EX,clk,enable_RR_EX,clear);

sign_extended_Imm_stream_RR_EX_instance : reg generic map (16) port map (sign_extended_Imm_stream_ID_RR,sign_extended_Imm_stream_EX,clk,enable_RR_EX,clear);

pc_RR_EX_instance : reg generic map (16) port map (pc_ID_RR,pc_EX,clk,enable_RR_EX,clear);

pc_plus_Imm_RR_EX_instance : reg generic map (16) port map (pc_plus_Imm_ID_RR,pc_plus_Imm_EX,clk,enable_RR_EX,clear);

sign_extend_RR_EX_instance : reg generic map (2) port map (sign_extend_ID_RR,sign_extend_EX,clk,enable_RR_EX,clear);

cond_RR_EX_instance : reg generic map (2) port map (cond_ID_RR,cond_EX,clk,enable_RR_EX,clear);

source1_RR_EX_instance : reg generic map (3) port map (source1_ID_RR,source1_EX,clk,enable_RR_EX,clear);

source2_RR_EX_instance : reg generic map (3) port map (source2_ID_RR,source2_EX,clk,enable_RR_EX,clear);

destination_RR_EX_instance : reg generic map (3) port map (destination_ID_RR,destination_EX,clk,enable_RR_EX,clear);

whether_lw_or_sw_RR_EX_instance : reg generic map (2) port map (whether_lw_or_sw_ID_RR,whether_lw_or_sw_EX,clk,enable_RR_EX,clear);

alu_operation_RR_EX_instance : reg generic map (2)port map (alu_operation_ID_RR,alu_operation_EX,clk,enable_RR_EX,clear);

flags_RR_EX_instance : reg generic map (2) port map (flags_ID_RR,flags_EX,clk,enable_RR_EX,clear);

shiftleftB_or_not_RR_EX_instance : reg generic map (2) port map (shiftleftB_or_not_ID_RR,shiftleftB_or_not_EX,clk,enable_RR_EX,clear);

write_on_reg_or_mem_RR_EX_instance : reg generic map (2) port map (write_on_reg_or_mem_ID_RR,write_on_reg_or_mem_EX,clk,enable_RR_EX,clear);

data_out1_insatnce  : reg generic map (16) port map (data_out1,data_out1_EX,clk,enable_RR_EX,clear);

data_out2_insatnce  : reg generic map (16) port map(data_out2,data_out2_EX,clk,enable_RR_EX,clear);

end RR_EX_arch;
	
----------------------------------------------------------------------------------------------------------------------------------------------		 
library ieee;
use ieee.numeric_std.all;   
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;	 
		 
entity EX_MM is 
port ( clk : in std_logic;
       enable_EX_MM : in std_logic;
		 clear  : in std_logic;
		 
		 
		 
	    result_alu : in std_logic_vector(15 downto 0);
		 whether_lw_or_sw_EX : in std_logic_vector(1 downto 0);
		 pc_EX : in std_logic_vector(15 downto 0);
		 pc_plus_Imm_EX : in std_logic_vector(15 downto 0);
		 instruction_EX : in std_logic_vector(15 downto 0);
		 write_on_reg_or_mem_EX : in std_logic_vector(1 downto 0);
		 destination_EX : in std_logic_vector(2 downto 0);
		 data_out1_EX : in std_logic_vector(15 downto 0);
		 carry_flag : in std_logic;
		 zero_flag : in std_logic;
		 
		 result_alu_MM : out std_logic_vector(15 downto 0):= (others=> 'X');
		 whether_lw_or_sw_MM : out std_logic_vector(1 downto 0):= (others=> 'X');
		 pc_MM : out std_logic_vector(15 downto 0):= (others=> 'X');
		 pc_plus_Imm_MM : out std_logic_vector(15 downto 0):= (others=> 'X');
		 instruction_MM : out std_logic_vector(15 downto 0):= (others=> 'X');
		 write_on_reg_or_mem_MM : out std_logic_vector(1 downto 0):= (others=> 'X');
		 destination_MM : out std_logic_vector(2 downto 0):= (others=> 'X');
		 data_out1_MM: out std_logic_vector(15 downto 0):= (others=> 'X');--------data came from reg A
		 carry_flag_MM : out std_logic:='X';
		 zero_flag_MM : out std_logic:='X'
		 
		 );
		 
		 end EX_MM;
architecture EX_MM_arch of EX_MM is
begin

instruction_EX_MM_instance : reg generic map (16) port map (instruction_EX,instruction_MM,clk,enable_EX_MM,clear);
pc_EX_MM_instance : reg generic map (16) port map (pc_EX,pc_MM,clk,enable_EX_MM,clear);
pc_plus_Imm_EX_MM_instance : reg generic map (16) port map (pc_plus_Imm_EX,pc_plus_Imm_MM,clk,enable_EX_MM,clear);
destination_EX_MM_instance : reg generic map (3) port map (destination_EX,destination_MM,clk,enable_EX_MM,clear);
whether_lw_or_sw_EX_MM_instance : reg generic map (2) port map (whether_lw_or_sw_EX,whether_lw_or_sw_MM,clk,enable_EX_MM,clear);
result_EX_MM_instance  : reg generic map (16) port map (result_alu,result_alu_MM,clk,enable_EX_MM,clear);
write_on_reg_or_mem_EX_MM_instance : reg generic map (2) port map (write_on_reg_or_mem_EX,write_on_reg_or_mem_MM,clk,enable_EX_MM,clear);
data_out1_MM_insatnce :  reg generic map (16) port map (data_out1_EX,data_out1_MM,clk,enable_EX_MM,clear);
carry_flag_MM_insatnce :  reg_1  port map (carry_flag,carry_flag_MM,clk,enable_EX_MM,clear);
zero_flag_MM_insatnce :  reg_1  port map (zero_flag,zero_flag_MM,clk,enable_EX_MM,clear);
end EX_MM_arch;
----------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.numeric_std.all;   
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;	 
		 
entity MM_WB is 
port ( clk : in std_logic;
       enable_MM_WB : in std_logic;
		 clear  : in std_logic;
		 
		 result_alu_MM : in std_logic_vector(15 downto 0);
		 
		 pc_MM : in std_logic_vector(15 downto 0);
		 pc_plus_Imm_MM : in std_logic_vector(15 downto 0);
		 
		 write_on_reg_or_mem_MM : in std_logic_vector(1 downto 0);
		 destination_MM : in std_logic_vector(2 downto 0);
		 data_out1_MM : in std_logic_vector(15 downto 0);---------------------data that came from register A
		 whether_lw_or_sw_MM : in std_logic_vector(1 downto 0);
		 data_that_came_from_memory_MM : in std_logic_vector(15 downto 0);
		 instruction_MM : in std_logic_vector(15 downto 0);
		 carry_flag_MM : in std_logic;
		 zero_flag_MM  : in std_logic;
		 
		 result_alu_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 pc_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 pc_plus_Imm_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 
		 write_on_reg_or_mem_WB : out std_logic_vector(1 downto 0):= (others=> 'X');
		 destination_WB : out std_logic_vector(2 downto 0):= (others=> 'X');
		 data_out1_WB: out std_logic_vector(15 downto 0):= (others=> 'X');--------------------data that came from register A
		 whether_lw_or_sw_WB : out std_logic_vector(1 downto 0):= (others=> 'X');
		 data_that_came_from_memory_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 instruction_WB : out std_logic_vector(15 downto 0):= (others=> 'X');
		 carry_flag_WB : out std_logic:='X';
		 zero_flag_WB  : out std_logic:='X'
		 );
		 
		 end MM_WB;
architecture MM_WB_arch of MM_WB is
begin


pc_MM_WB_instance : reg generic map (16) port map (pc_MM,pc_WB,clk,enable_MM_WB,clear);
pc_plus_Imm_MM_WB_instance : reg generic map (16) port map (pc_plus_Imm_MM,pc_plus_Imm_WB,clk,enable_MM_WB,clear);
destination_MM_WB_instance : reg generic map (3) port map (destination_MM,destination_WB,clk,enable_MM_WB,clear);
result_alu_MM_WB_instance  : reg generic map (16) port map (result_alu_MM,result_alu_WB,clk,enable_MM_WB,clear);
write_on_reg_or_mem_MM_WB_instance : reg generic map (2) port map (write_on_reg_or_mem_MM,write_on_reg_or_mem_WB,clk,enable_MM_WB,clear);
data_out1_WB_insatnce :  reg generic map (16) port map (data_out1_MM,data_out1_WB,clk,enable_MM_WB,clear);
whether_lw_or_sw_MM_WB_instance : reg generic map (2) port map (whether_lw_or_sw_MM,whether_lw_or_sw_WB,clk,enable_MM_WB,clear);
data_that_came_from_memory_MM_WB_instance : reg generic map (16) port map (data_that_came_from_memory_MM,data_that_came_from_memory_WB,clk,enable_MM_WB,clear);
instruction_MM_WB_instance : reg generic map (16) port map (instruction_MM,instruction_WB,clk,enable_MM_WB,clear);
carry_flag_WB_instance : reg_1 port map (carry_flag_MM,carry_flag_WB,clk,enable_MM_WB,clear);
zero_flag_WB_instance : reg_1 port map (zero_flag_MM,zero_flag_WB,clk,enable_MM_WB,clear);
end MM_WB_arch;	 	 