library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;





entity alu is 
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
			result_alu : buffer std_logic_vector(15 downto 0));



end alu;


architecture alu_arch of alu is
signal opcode_cond  : std_logic_vector(5 downto 0);
signal operand_A  : std_logic_vector(15 downto 0);
signal operand_B  : std_logic_vector(15 downto 0);
signal ADL_data : std_logic_vector(15 downto 0);
signal check : integer;
begin
 
opcode_cond<=instruction_EX(15 downto 12) & cond_EX;
ADL_data<=shifted_data_out2_EX when cond_EX="11" else data_out2_EX;
		 
process(opcode_cond,instruction_EX,data_out1_EX,data_out2_EX,ADL_data,sign_extended_Imm_stream_EX)
begin
if (instruction_EX(15 downto 12)="0001")then--------------------ADD/ADZ/ADC/ADL
       operand_A<=data_out1_EX;
	    operand_B<=ADL_data;
		 
elsif (instruction_EX(15 downto 12)="0111")then-----------------ADI
       operand_A<=data_out1_EX;
	    operand_B<=sign_extended_Imm_stream_EX;
elsif (instruction_EX(15 downto 12)="0010")then------------------------NDU/NDC/NDZ
       operand_A<=data_out1_EX;
	    operand_B<=data_out2_EX;
elsif (instruction_EX(15 downto 12)="1000")then------------------------BEQ
       operand_A<=data_out1_EX;
	    operand_B<=data_out2_EX;
elsif (instruction_EX(15 downto 12)="0100")then------------------------LW
       operand_A<=data_out1_EX;
	    operand_B<=sign_extended_Imm_stream_EX;
elsif (instruction_EX(15 downto 12)="0101")then-----------------------SW
       operand_A<=data_out2_EX;
	    operand_B<=sign_extended_Imm_stream_EX;
elsif (instruction_EX(15 downto 12)="1011")then-----------------------JRI
       operand_A<=data_out1_EX;
	    operand_B<=sign_extended_Imm_stream_EX;
else
       operand_A<="XXXXXXXXXXXXXXXX";
	    operand_B<="XXXXXXXXXXXXXXXX";
end if;
end process;

process(operand_A,operand_B,alu_operation_EX)---01 for add and 10 for nand 
begin

if (alu_operation_EX="01")then
    result_alu<=std_logic_vector(unsigned(operand_A) + unsigned(operand_B));
elsif(alu_operation_EX="10")then
    result_alu<= not (operand_A and operand_B);
elsif(alu_operation_EX="11")then
    result_alu<= std_logic_vector(unsigned(operand_A) - unsigned(operand_B));
else
    result_alu<="XXXXXXXXXXXXXXXX";
end if;
end process;


check<=to_integer(unsigned(result_alu));



process(flags_EX,check)
begin
case (flags_EX) is

when "01"=>    
       
		 if(check=0)then
		 zero_flag <= '1';
		 else 
		 zero_flag <= '0';
		 end if;
				
when "10"=> 
 
      if(check>255)then
		 carry_flag <= '1';
		 else 
		 carry_flag <= '0';
		 end if;

when "11"=> 
       if(check>255)then
		 carry_flag <= '1';
		 else 
		 carry_flag <= '0';
		 end if;
		 if(check=0)then
		 zero_flag <= '1';
		 else 
		 zero_flag <= '0';
		 end if;

when others => null ;
end case;			
end process;				
				
end alu_arch;
