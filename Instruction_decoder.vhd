library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;



library work;
use work.essential_components.all;
use work.pipeline_registers.all;


entity Instruction_decoder is 
port (instruction_IF_ID : in std_logic_vector(15 downto 0);--incoming inst
sign_extend  : out  std_logic_vector(1 downto 0):= (others=> 'X');--01 for 6 and 10 for 9
cond  : out std_logic_vector(1 downto 0):= (others=> 'X');--00,01,10,11
source1 : out std_logic_vector(2 downto 0):= (others=> 'X');
source2 : out std_logic_vector(2 downto 0):= (others=> 'X');
destination : out std_logic_vector(2 downto 0):= (others=> 'X');
whether_lw_or_sw  : out std_logic_vector(1 downto 0):= (others=> 'X');--01 for lw and 10 for sw
alu_operation : out std_logic_vector(1 downto 0):= (others=> 'X');---01 for add and 10 for nand 11 for sub
flags   : out std_logic_vector(1 downto 0):= (others=> 'X');--00(),01(z),10(c),11(cz)
shiftleftB_or_not  : out std_logic_vector(1 downto 0):= (others=> 'X');--10 for shift regB left by 1 
write_on_reg_or_mem : out std_logic_vector(1 downto 0):= (others=> 'X')-- 01 for reg and 10 for mem
);
end Instruction_decoder;


architecture Ind of Instruction_decoder is
signal RA,RB,RC : std_LOGIC_VECTOR(2 downto 0);
signal condition : std_logic_vector(1 downto 0);
begin

process(instruction_IF_ID,RA,RB,RC,condition)
begin
RA<=instruction_IF_ID(11 downto 9);
RB<=instruction_IF_ID(8 downto 6);
RC<=instruction_IF_ID(5 downto 3);

condition <= instruction_IF_ID(1 downto 0);


case (instruction_IF_ID(15 downto 12)) is

when "0001"=>     destination <= RC;------------------ADD/ADZ/ADC/ADL
                  source1 <= RA;
                  source2 <= RB;
						sign_extend<="XX";
                  cond<=condition; 
                  whether_lw_or_sw<= "XX";
                  alu_operation<="01";
                  flags<= "11"; 						
                  shiftleftB_or_not<=(instruction_IF_ID(1) and instruction_IF_ID(0))&'0';
						write_on_reg_or_mem<="01";
						
when "0111"=>     destination <= RB;----------------------ADI
                  source1 <= RA;
                  source2 <= "XXX";
						sign_extend<="01";
                  cond<="XX"; 
                  whether_lw_or_sw<="XX";
                  alu_operation<="01";
                  flags<= "11"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="01";
												
when "0010"=>     destination <= RC;-------------------------NDU/NDC/NDZ
                  source1 <= RA;
                  source2 <= RB;
						sign_extend<="XX";
                  cond<= condition; 
                  whether_lw_or_sw<="XX";
                  alu_operation<="10";
                  flags<= "01"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="01";
						
when "0100"=>     destination <= RA;-----------------------------LW
                  source1 <= RB;
                  source2 <= "XXX";
						sign_extend<="01";
                  cond<= "XX"; 
                  whether_lw_or_sw<="01";
                  alu_operation<="01";
                  flags<= "01"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="01";	

when "0101"=>     destination <= "XXX";---------------------------SW
                  source1 <= RA;
                  source2 <= RB;
						sign_extend<="01";
                  cond<= "XX"; 
                  whether_lw_or_sw<="10";
                  alu_operation<="01";
                  flags<= "00"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="10";	
						
when "0011"=>     destination <= RA;---------------------------LHI
                  source1 <= "XXX";
                  source2 <= "XXX";
						sign_extend<="XX";
                  cond<= "XX"; 
                  whether_lw_or_sw<=(others=>'X');
                  alu_operation<=(others=>'X');
                  flags<= "00"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="01";
						
when "1000"=>     destination <= "XXX";---------------------------BEQ
                  source1 <= RA;
                  source2 <= RB;
						sign_extend<="01";
                  cond<= "XX"; 
                  whether_lw_or_sw<=(others=>'X');
                  alu_operation<="11";
                  flags<= "01"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="00";
						
when "1001"=>     destination <=RA;---------------------------JAL
                  source1 <= "XXX";
                  source2 <= "XXX";
						sign_extend<="10";
                  cond<= "XX"; 
                  whether_lw_or_sw<="XX";
                  alu_operation<="XX";
                  flags<= "00"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="01";						
						
when "1010"=>     destination <=RA;---------------------------JLR
                  source1 <= "XXX";
                  source2 <= RB;
						sign_extend<="XX";
                  cond<= "XX"; 
                  whether_lw_or_sw<=(others=>'X');
                  alu_operation<="XX";
                  flags<= "00"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="01";		
		
when "1011"=>     destination <="XXX";---------------------------JRI
                  source1 <= RA;
                  source2 <= "XXX";
						sign_extend<="10";
                  cond<= "XX"; 
                  whether_lw_or_sw<=(others=>'X');
                  alu_operation<="01";
                  flags<= "00"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<="00";			
						
when others=>     destination <= "XXX";
                  source1 <= "XXX";
                  source2 <= "XXX";
						sign_extend<="XX";
                  cond<= "XX"; 
                  whether_lw_or_sw<=(others=>'X');
                  alu_operation<=(others=>'X');
                  flags<= "XX"; 						
                  shiftleftB_or_not<=(others=>'X');
						write_on_reg_or_mem<=(others=>'X');
end case;

end process;







end Ind;  