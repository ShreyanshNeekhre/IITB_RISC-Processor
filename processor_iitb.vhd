library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;
use work.pipeline_registers.all;

entity processor_iitb is 
port( clk : in std_logic;
 Reg0 : out std_logic_vector(15 downto 0);
 Reg1 : out std_logic_vector(15 downto 0);
 Reg2 : out std_logic_vector(15 downto 0);
 Reg3 : out std_logic_vector(15 downto 0);
 Reg4 : out std_logic_vector(15 downto 0);
 Reg5 : out std_logic_vector(15 downto 0);
 Reg6 : out std_logic_vector(15 downto 0);
 Reg7 : out std_logic_vector(15 downto 0);
 pc_out : out std_logic_vector(15 downto 0);
 pc_plus_out : out std_logic_vector(15 downto 0)


);
end processor_iitb;

architecture pro of processor_iitb is 
signal pc : std_logic_vector(15 downto 0):=(others=>'0');
signal pc_plus : std_logic_vector(15 downto 0):=(others=>'0');
signal instruction : std_logic_vector(15 downto 0):=(others=>'X');
signal instruction_IF_ID  :  std_logic_vector(15 downto 0):=(others=>'X');
signal pc_plus_IF_ID :   std_logic_vector(15 downto 0):=(others=>'X');
signal pc_IF_ID :  std_logic_vector(15 downto 0):=(others=>'X');

signal sign_extend  : std_logic_vector(1 downto 0);--0 for 6 and 1 for 9
signal cond  :  std_logic_vector(1 downto 0);--00,01,10,11
signal source1 :  std_logic_vector(2 downto 0);
signal source2 :  std_logic_vector(2 downto 0);
signal destination :  std_logic_vector(2 downto 0);
signal whether_lw_or_sw  :  std_logic_vector(1 downto 0);--0 for lw and 1 for sw
signal alu_operation :  std_logic_vector(1 downto 0);---0 for add and 1 for nand 
signal flags   :  std_logic_vector(1 downto 0);--00(),01(c),10(z),11(cz)
signal shiftleftB_or_not  :  std_logic_vector(1 downto 0);--1 for shift regB left by 1 
signal write_on_reg_or_mem :  std_logic_vector(1 downto 0);-- 0 for reg and 1 for mem
--
signal sign_extended_Imm_stream :  std_logic_vector(15 downto 0);
signal pc_plus_Imm :  std_logic_vector(15 downto 0):=(others=>'0');
--
signal instruction_ID_RR :  std_logic_vector(15 downto 0):=(others=>'X');
signal  sign_extended_Imm_stream_ID_RR :  std_logic_vector(15 downto 0);
signal pc_ID_RR :  std_logic_vector(15 downto 0);
signal pc_plus_Imm_ID_RR :  std_logic_vector(15 downto 0);
signal sign_extend_ID_RR  :   std_logic_vector(1 downto 0);--0 for 6 and 1 for 9
signal	cond_ID_RR  :  std_logic_vector(1 downto 0);--00,01,10,11
signal	source1_ID_RR :  std_logic_vector(2 downto 0);
signal	source2_ID_RR :  std_logic_vector(2 downto 0);
signal	destination_ID_RR :  std_logic_vector(2 downto 0);
signal	whether_lw_or_sw_ID_RR  :  std_logic_vector(1 downto 0);--0 for lw and 1 for sw
signal	alu_operation_ID_RR :  std_logic_vector(1 downto 0);---0 for add and 1 for nand 
signal flags_ID_RR   :  std_logic_vector(1 downto 0);--00(),01(c),10(z),11(cz)
signal	shiftleftB_or_not_ID_RR  :  std_logic_vector(1 downto 0);--1 for shift regB left by 1 
signal	write_on_reg_or_mem_ID_RR :  std_logic_vector(1 downto 0);-- 0 for reg and 1 for mem);
--
signal data_out1 :  std_logic_vector(15 downto 0);
signal data_out2 :  std_logic_vector(15 downto 0);
signal R0 :  std_logic_vector(15 downto 0);
signal R1 :  std_logic_vector(15 downto 0);
signal R2 :  std_logic_vector(15 downto 0);
signal R3 :  std_logic_vector(15 downto 0);
signal R4 :  std_logic_vector(15 downto 0);
signal R5 :  std_logic_vector(15 downto 0);
signal R6 :  std_logic_vector(15 downto 0);
signal R7 :  std_logic_vector(15 downto 0);

--signal register_out_demo :   reg_rom ;
signal ena_demo :  std_logic_vector(7 downto 0); 

signal source1_EX : std_logic_vector(2 downto 0):=(others=>'X');
signal source2_EX : std_logic_vector(2 downto 0):=(others=>'X');
signal destination_EX : std_logic_vector(2 downto 0):=(others=>'X');
signal shiftleftB_or_not_EX :  std_logic_vector(1 downto 0):=(others=>'X');
signal write_on_reg_or_mem_EX :  std_logic_vector(1 downto 0):= (others=> 'X');
signal alu_operation_EX :  std_logic_vector(1 downto 0):= (others=> 'X');
signal flags_EX   :  std_logic_vector(1 downto 0):= (others=> 'X');
signal whether_lw_or_sw_EX  :  std_logic_vector(1 downto 0):= (others=> 'X');
signal cond_EX  :  std_logic_vector(1 downto 0):= (others=> 'X');
signal sign_extend_EX  :   std_logic_vector(1 downto 0):= (others=> 'X');
signal instruction_EX :  std_logic_vector(15 downto 0):= (others=> 'X');
signal sign_extended_Imm_stream_EX :  std_logic_vector(15 downto 0):= (others=> 'X');
signal pc_EX :  std_logic_vector(15 downto 0):= (others=> 'X');
signal pc_plus_Imm_EX :  std_logic_vector(15 downto 0):= (others=> 'X');
 
signal data_out1_EX:  std_logic_vector(15 downto 0);
signal	 data_out2_EX:  std_logic_vector(15 downto 0);
signal shifted_data_out2_EX  : std_logic_vector(15 downto 0);
signal carry_flag :std_logic;
signal zero_flag : std_logic:='X';
signal result_alu : std_logic_vector(15 downto 0);

signal       result_alu_MM :  std_logic_vector(15 downto 0);
signal		 whether_lw_or_sw_MM :  std_logic_vector(1 downto 0);
signal		 pc_MM :  std_logic_vector(15 downto 0);
signal		 pc_plus_Imm_MM :  std_logic_vector(15 downto 0);
signal		 instruction_MM :  std_logic_vector(15 downto 0);
signal		 write_on_reg_or_mem_MM :  std_logic_vector(1 downto 0);
signal		 destination_MM :  std_logic_vector(2 downto 0);
signal       data_out1_MM: std_logic_vector(15 downto 0);
signal       carry_flag_MM : std_logic;
signal		 zero_flag_MM :  std_logic;

--signal data_in_for_memory : std_logic_vector(15 downto 0):=(others=>'X');
signal read_from_memory : std_logic;
--signal write_into_memory : std_logic;


signal data_that_came_from_memory  :  std_logic_vector(15 downto 0):=(others=>'X');

signal result_alu_WB :  std_logic_vector(15 downto 0);
		 
signal pc_WB :  std_logic_vector(15 downto 0);
signal pc_plus_Imm_WB :  std_logic_vector(15 downto 0);
		 
signal write_on_reg_or_mem_WB :  std_logic_vector(1 downto 0);
signal destination_WB :  std_logic_vector(2 downto 0); 
signal data_out1_WB :  std_logic_vector(15 downto 0);
signal whether_lw_or_sw_WB :  std_logic_vector(1 downto 0);

signal data_came_from_WB :  std_logic_vector(15 downto 0);
signal data_that_came_from_memory_WB :  std_logic_vector(15 downto 0);
signal destination_came_from_WB :  std_logic_vector(2 downto 0);
signal instruction_WB :  std_logic_vector(15 downto 0);
signal register_write_enable :  std_logic;
signal mem_write_enable :  std_logic;
signal carry_flag_WB :  std_logic;
signal zero_flag_WB  :  std_logic;
signal beq_signal : std_logic:='0';
signal jal_signal : std_logic:='0';
signal jlr_signal : std_logic:='0';
signal clear_signal_between_beq_jal_jlr_for_IF_ID : std_logic:='0';
signal clear_signal_between_jlr_beq_for_IF_ID_and_ID_RR : std_logic:='0';
signal dependency_on_op1_EX   :  std_logic:='0';
signal dependency_on_op2_EX  :  std_logic:='0';
signal data1_RR : std_logic_vector(15 downto 0);
signal data2_RR : std_logic_vector(15 downto 0);

signal dependency_on_op1_MM :  std_logic:='0';
signal dependency_on_op2_MM :  std_logic:='0';

signal dependency_on_op1_WB :  std_logic:='0';
signal dependency_on_op2_WB :  std_logic:='0';
signal opcode_and_cond_for_WB :  std_logic_vector(5 downto 0):=(others=>'X');
 
begin

 Reg0 <=R0; 
 Reg1 <=R1;
 Reg2 <=R2;
 Reg3 <=R3;
 Reg4 <=R4;
 Reg5 <=R5;
 Reg6 <=R6;
 Reg7 <=R7;
 pc_out  <=pc;
 pc_plus_out <=pc_plus;
 
-----------------------------------IF-------------------------------------------------------------------------------------
process(zero_flag,instruction_EX,pc,instruction_IF_ID,pc_plus_Imm_EX,pc_plus_Imm,data_out2,instruction_ID_RR,result_alu)begin
if(instruction_EX(15 downto 12)="1000" and zero_flag='1')then
     pc_plus<= pc_plus_Imm_EX;--------------------------------------------BEQ
	  beq_signal<='1';---------------------------------------command to clear IF,ID,RR
	  jal_signal<='0';
	  jlr_signal<='0';
elsif(instruction_EX(15 downto 12)="1011")then
     pc_plus<= result_alu;--------------------------------------------JRI
	  jal_signal<='0';
	  beq_signal<='1';-------------------------------no need to create extra signal for jri , beq will do it 
	  jlr_signal<='0';
elsif(instruction_ID_RR(15 downto 12)="1010")then
     pc_plus<= data_out2;--------------------------------------------JLR
	  jal_signal<='0';
	  beq_signal<='0';
	  jlr_signal<='1';
elsif(instruction_IF_ID(15 downto 12)="1001")then
     pc_plus<= pc_plus_Imm;--------------------------------------------JAL
	  jal_signal<='1';
	  beq_signal<='0';
	  jlr_signal<='0';
else 
     pc_plus<= std_logic_vector(unsigned(pc) +1);--- increementing pc by 1---house keeping task ;
	  beq_signal<='0';
	  jal_signal<='0';
	  jlr_signal<='0';
end if;
end process;

clear_signal_between_beq_jal_jlr_for_IF_ID<= beq_signal or jal_signal or jlr_signal;
clear_signal_between_jlr_beq_for_IF_ID_and_ID_RR<= beq_signal or jlr_signal; 

process(clk)------assigning increemented address(+1) to pc----------------------
begin
if(clk'event and clk='1')then
pc<=pc_plus;
end if;
end process;


instruction_memory_fetch : Instruction_Memory port map('1',pc,instruction);------instruction fetch
--------------------------------------------IF_ID Pipeline register --------------------------------------------------------------------------------



IF_ID_instance  : IF_ID port map ('1',clear_signal_between_beq_jal_jlr_for_IF_ID,pc_plus,pc,clk,'0',instruction,
                                        instruction_IF_ID,pc_plus_IF_ID,pc_IF_ID);

----------------------------------------------ID-------------------------------------------------------------------------------
--
ID_instance  : Instruction_decoder port map (instruction_IF_ID,sign_extend,cond,source1,source2,
destination,whether_lw_or_sw,alu_operation,flags,shiftleftB_or_not,write_on_reg_or_mem);
--
sign_extend_instance  : sign_extend_entity port map (sign_extend,sign_extended_Imm_stream,pc_IF_ID,instruction_IF_ID
                                                   ,pc_plus_Imm);
																																		
-------------------------------------------------------ID_RR Pipeline register--------------------------------------------------------------------------
--
ID_RR_instance : ID_RR port map (clk,'1',clear_signal_between_jlr_beq_for_IF_ID_and_ID_RR,instruction_IF_ID,sign_extended_Imm_stream,pc_IF_ID,pc_plus_Imm,
sign_extend,cond,source1,source2,destination,whether_lw_or_sw,alu_operation,flags,
shiftleftB_or_not,write_on_reg_or_mem,instruction_ID_RR,sign_extended_Imm_stream_ID_RR,pc_ID_RR,pc_plus_Imm_ID_RR,
sign_extend_ID_RR,cond_ID_RR,source1_ID_RR,source2_ID_RR,destination_ID_RR,whether_lw_or_sw_ID_RR,alu_operation_ID_RR,
flags_ID_RR,shiftleftB_or_not_ID_RR,write_on_reg_or_mem_ID_RR);
--
----------------------------------------------------RR---------------------------------------------------------------------
Register_file_instance : register_file port map (destination_came_from_WB,source1_ID_RR,source2_ID_RR,register_write_enable,
data_came_from_WB,'0','0',"1111111100000000",data_out1,data_out2,R0,clk,R1,R2,R3,R4,R5,R6,R7,ena_demo);
-----------------------------------------forwarding unit for RR_EX and RR_MM---------------------------------------------------------------------------------------

free  : forwarding_RR_Ex port map(destination_EX,source1_ID_RR,source2_ID_RR,dependency_on_op1_EX,dependency_on_op2_EX); 
frmm  : forwarding_RR_MM port map(destination_MM,source1_ID_RR,source2_ID_RR,dependency_on_op1_MM,dependency_on_op2_MM);
frww  : forwarding_RR_WB port map(destination_WB,source1_ID_RR,source2_ID_RR,dependency_on_op1_WB,dependency_on_op2_WB);

opcode_and_cond_for_WB<=instruction_WB(15 downto 12)&instruction_WB(1 downto 0);

process(dependency_on_op1_EX,dependency_on_op2_EX,result_alu,data_out1,data_out2,
        dependency_on_op1_MM,dependency_on_op2_MM,data_that_came_from_memory,
		  dependency_on_op1_WB,dependency_on_op2_WB,result_alu_WB,instruction_WB,
		  data_that_came_from_memory_WB,opcode_and_cond_for_WB,carry_flag_WB,zero_flag_WB)begin
if(dependency_on_op1_EX='1')then
     data1_RR<=result_alu;
elsif(dependency_on_op1_MM='1')then
     data1_RR<=data_that_came_from_memory;
elsif(dependency_on_op1_WB='1')then
       if(opcode_and_cond_for_WB="000100" or opcode_and_cond_for_WB="000111" or opcode_and_cond_for_WB="0001XX" or opcode_and_cond_for_WB="001000" )then
         data1_RR<=result_alu_WB;---------------simple instructions like ADD/NAND
		 end if;
		 if(instruction_WB(15 downto 12)="0111")then-------------ADI
		   data1_RR<=result_alu_WB;
		 end if;
		 if(instruction_WB(15 downto 12)="0011")then------------------------------LHI
			data1_RR<=instruction_WB(8 downto 0)&"0000000";
		 end if;
		 if(opcode_and_cond_for_WB="000110" or opcode_and_cond_for_WB="001010" )then-------ADC
			if(carry_flag_WB='1')then
				data1_RR<=result_alu_WB;
			end if;
		 end if;
		 if(opcode_and_cond_for_WB="000101" or opcode_and_cond_for_WB="001001")then----------ADZ
			if(zero_flag_WB='1')then
				data1_RR<=result_alu_WB;
			end if;
		 end if;
		 if(instruction_WB(15 downto 12)="0100")then------------------LW
		   data1_RR<=data_that_came_from_memory_WB;
		 end if;
else 
     data1_RR<=data_out1;
end if;
if(dependency_on_op2_EX='1')then
     data2_RR<=result_alu;
elsif(dependency_on_op2_MM='1')then
     data2_RR<=data_that_came_from_memory;
elsif(dependency_on_op2_WB='1')then
     if(opcode_and_cond_for_WB="000100" or opcode_and_cond_for_WB="000111" or opcode_and_cond_for_WB="0001XX" or opcode_and_cond_for_WB="001000" )then
         data2_RR<=result_alu_WB;---------------simple instructions like ADD/NAND
		 end if;
		 if(instruction_WB(15 downto 12)="0111")then-------------ADI
		   data2_RR<=result_alu_WB;
		 end if;
		 if(instruction_WB(15 downto 12)="0011")then------------------------------LHI
			data2_RR<=instruction_WB(8 downto 0)&"0000000";
		 end if;
		 if(opcode_and_cond_for_WB="000110" or opcode_and_cond_for_WB="001010" )then------------------ADC
			if(carry_flag_WB='1')then
				data2_RR<=result_alu_WB;
			end if;
		 end if;
		 if(opcode_and_cond_for_WB="000101" or opcode_and_cond_for_WB="001001")then-------------------ADZ
			if(zero_flag_WB='1')then
				data2_RR<=result_alu_WB;
			end if;
		 end if;
		 if(instruction_WB(15 downto 12)="0100")then------------------LW
		   data2_RR<=data_that_came_from_memory_WB;
		 end if;
else 
     data2_RR<=data_out2;
end if;
end process;

----------------------------------------------------RR_EX------------------------------------------------------------------
RR_EX_instance  : RR_EX port map (clk,'1',beq_signal,source1_ID_RR, source2_ID_RR,destination_ID_RR,source1_EX,source2_EX ,destination_EX,shiftleftB_or_not_ID_RR,
shiftleftB_or_not_EX ,write_on_reg_or_mem_ID_RR,write_on_reg_or_mem_EX ,alu_operation_ID_RR ,alu_operation_EX ,
flags_ID_RR ,flags_EX ,whether_lw_or_sw_ID_RR ,whether_lw_or_sw_EX  ,cond_ID_RR ,cond_EX ,sign_extend_ID_RR ,
sign_extend_EX ,instruction_ID_RR,instruction_EX,sign_extended_Imm_stream_ID_RR ,sign_extended_Imm_stream_EX ,
 pc_ID_RR ,pc_EX ,pc_plus_Imm_ID_RR ,pc_plus_Imm_EX ,data1_RR,data2_RR,data_out1_EX,data_out2_EX);
 ----------------------------------------------------EX---------------------------------------------------------------------------------
left_shift_instance  : left_shift port map (data_out2_EX,shiftleftB_or_not_EX,shifted_data_out2_EX);

alu_instance  : alu port map(data_out1_EX,data_out2_EX,shifted_data_out2_EX,alu_operation_EX,flags_EX,
whether_lw_or_sw_EX,cond_EX,sign_extend_EX,sign_extended_Imm_stream_EX,instruction_EX,
carry_flag,zero_flag,result_alu);
------------------------------------------------------EX_MM-----------------------------------------------------------------------------------
EX_MM_instance : EX_MM port map (clk,'1','0',result_alu,whether_lw_or_sw_EX,pc_EX,pc_plus_Imm_EX,instruction_EX ,
write_on_reg_or_mem_EX ,destination_EX ,data_out1_EX,carry_flag,zero_flag,result_alu_MM ,whether_lw_or_sw_MM ,
pc_MM ,pc_plus_Imm_MM ,instruction_MM ,write_on_reg_or_mem_MM ,destination_MM,data_out1_MM,
carry_flag_MM,zero_flag_MM);
----------------------------------------------------------------------------------------------------------------------------------
process(instruction_MM)begin
if(instruction_MM(15 downto 12)="0101")then---------------------SW
read_from_memory<='0';

elsif(instruction_MM(15 downto 12)="0100")then------------------------LW
read_from_memory<='1';

else
read_from_memory<='0';

end if;
end process;
                     
----------------------------------------------------------MM---------------------------------------------------------------------------------
data_memory_instance  : data_memory port map (data_came_from_WB,result_alu_WB(7 downto 0),result_alu_MM(7 downto 0),
data_that_came_from_memory,clk,mem_write_enable,read_from_memory,'0');
------------------------------------------------------------MM_WB-----------------------------------------------------------------------------------
MM_WB_instance : MM_WB port map (clk,'1','0',result_alu_MM ,pc_MM ,pc_plus_Imm_MM ,write_on_reg_or_mem_MM ,
destination_MM ,data_out1_MM ,whether_lw_or_sw_MM,data_that_came_from_memory,instruction_MM,carry_flag_MM,
zero_flag_MM,result_alu_WB ,pc_WB ,pc_plus_Imm_WB ,write_on_reg_or_mem_WB ,destination_WB ,
data_out1_WB,whether_lw_or_sw_WB,data_that_came_from_memory_WB,instruction_WB,carry_flag_WB,zero_flag_WB);
--------------------------------------------------------------WB-----------------------------------------------------------------------------------------------
write_back_instance : write_back port map(carry_flag_WB,zero_flag_WB,instruction_WB,data_that_came_from_memory_WB,
result_alu_WB ,pc_WB,pc_plus_Imm_WB ,write_on_reg_or_mem_WB ,destination_WB ,data_out1_WB,whether_lw_or_sw_WB ,
data_came_from_WB ,destination_came_from_WB,register_write_enable,mem_write_enable);
end pro;