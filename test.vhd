library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity test is

end test;


architecture test_arch of test is 


component processor_iitb is 
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
 pc_plus_out : out std_logic_vector(15 downto 0));
end component;


signal clk : std_logic:='0';
signal R0 :  std_logic_vector(15 downto 0);
signal R1 :  std_logic_vector(15 downto 0);
signal R2 :  std_logic_vector(15 downto 0);
signal R3 :  std_logic_vector(15 downto 0);
signal R4 :  std_logic_vector(15 downto 0);
signal R5 :  std_logic_vector(15 downto 0);
signal R6 :  std_logic_vector(15 downto 0);
signal R7 :  std_logic_vector(15 downto 0);
signal pc : std_logic_vector(15 downto 0);
signal pc_plus : std_logic_vector(15 downto 0);

begin
clk<= not clk after 50 ps;

test_instance  : processor_iitb port map (clk,R0,R1,R2,R3 ,R4,R5,R6 ,R7 ,pc,pc_plus );

end test_arch;