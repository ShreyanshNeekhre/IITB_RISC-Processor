library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;
use work.pipeline_registers.all;

entity write_back is 
port(  carry_flag_WB : in std_logic;
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
end write_back;

architecture wb_arch of write_back is 
signal register_write_enable_signal : std_logic;
signal mem_write_enable_signal : std_logic;
signal ADC_ADZ_signal : std_logic_vector(5 downto 0):=(others=>'X');
begin

ADC_ADZ_signal<=instruction_WB(15 downto 12)&instruction_WB(1 downto 0);

process(write_on_reg_or_mem_WB,data_out1_WB,result_alu_WB,whether_lw_or_sw_WB,
data_that_came_from_memory_WB,instruction_WB,zero_flag_WB,ADC_ADZ_signal,carry_flag_WB,pc_WB)
begin

if(write_on_reg_or_mem_WB="01")then----------------------write on reg

				if(whether_lw_or_sw_WB="01")then-----------------------if LW
				
					 data_came_from_WB<=data_that_came_from_memory_WB;
					 register_write_enable_signal<='1';
					 mem_write_enable_signal<='0';
					 
				elsif(whether_lw_or_sw_WB="10")then----------------------------SW will never come together with write in reg
				
					 data_came_from_WB<="XXXXXXXXXXXXXXXX";
					 register_write_enable_signal<='0';
					 mem_write_enable_signal<='0';
				end if;
				if(ADC_ADZ_signal="000100" or ADC_ADZ_signal="000111" or ADC_ADZ_signal="0001XX" or ADC_ADZ_signal="001000" )then
					 data_came_from_WB<=result_alu_WB;------------------simple instructions like ADD/NAND
					 register_write_enable_signal<='1';
					 mem_write_enable_signal<='0';
				end if;
				if(instruction_WB(15 downto 12)="0111")then
				    data_came_from_WB<=result_alu_WB;------------------ADI
					 register_write_enable_signal<='1';
					 mem_write_enable_signal<='0';
				end if;
				if(instruction_WB(15 downto 12)="0011")then------------------------------LHI
				     data_came_from_WB<=instruction_WB(8 downto 0)&"0000000";
					  register_write_enable_signal<='1';
					  mem_write_enable_signal<='0';
				end if;
				if(instruction_WB(15 downto 12)="1001")then------------------------------JAL
				     data_came_from_WB<=std_logic_vector(unsigned(pc_WB)+1);
					  register_write_enable_signal<='1';
					  mem_write_enable_signal<='0';
				end if;
				if(instruction_WB(15 downto 12)="1010")then------------------------------JLR
				     data_came_from_WB<=std_logic_vector(unsigned(pc_WB)+1);
					  register_write_enable_signal<='1';
					  mem_write_enable_signal<='0';
				end if;
				if(ADC_ADZ_signal="000110" or ADC_ADZ_signal="001010")then------------------ADC
				     if(carry_flag_WB='1')then
					     data_came_from_WB<=result_alu_WB;
					     register_write_enable_signal<='1';
					     mem_write_enable_signal<='0';
						else
						  data_came_from_WB<=result_alu_WB;
					     register_write_enable_signal<='0';
					     mem_write_enable_signal<='0';
						end if;
				elsif(ADC_ADZ_signal="000101" or ADC_ADZ_signal="001001")then--------------------------------------ADZ
				      if(zero_flag_WB='1')then
						  data_came_from_WB<=result_alu_WB;
					     register_write_enable_signal<='1';
					     mem_write_enable_signal<='0';
						else
						  data_came_from_WB<=result_alu_WB;
					     register_write_enable_signal<='0';
					     mem_write_enable_signal<='0';
						end if;

				end if;	  
					  
elsif(write_on_reg_or_mem_WB="10")then--------------------------write on memory

             data_came_from_WB<=data_out1_WB;----------------------SW
				 mem_write_enable_signal<='1';
				 register_write_enable_signal<='0';

else 
             mem_write_enable_signal<='0';
				 register_write_enable_signal<='0';
end if;   
end process;

destination_came_from_WB<=destination_WB;

register_write_enable<=register_write_enable_signal;

mem_write_enable<=mem_write_enable_signal;
end wb_arch;