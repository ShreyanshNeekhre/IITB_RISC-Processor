library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.essential_components.all;

entity register_file is 
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
		   -- R0 : out std_logic_vector(15 downto 0 );
			 R1 : out std_logic_vector(15 downto 0 );
			 R2 : out std_logic_vector(15 downto 0 );
			 R3 : out std_logic_vector(15 downto 0 );
			 R4 : out std_logic_vector(15 downto 0 );
			 R5 : out std_logic_vector(15 downto 0 );
			 R6 : out std_logic_vector(15 downto 0 );
			 R7 : out std_logic_vector(15 downto 0 );
			ena_demo : out std_logic_vector(7 downto 0) 
			); 
end register_file;
 
architecture reg_file of register_file is
 
signal ena : std_logic_vector(7 downto 0) := (others=>'0');
signal select1 , select2 : std_logic_vector(2 downto 0) :=(others=>'X');
signal register_out  : reg_rom  := (others=>(others=>'0'));
 signal R7_data : std_logic_vector(15 downto 0);
signal R7_t : std_logic;

begin
R7_t <= R7_ena or ena(7);--logic to select R7_enable
----logic to write on all registers whose enable is high.

write_on_all : for i in 0 to 6 generate
    register_call : reg generic map (16) port map(data_in , register_out(i),clk,ena(i),clear );
end  generate ;

----logic to write specifically on R7
R_7 : reg generic map (16) port map(R7_data , register_out(7),clk,R7_t,clear );

R7_data <= R7_in when (R7_ena ='1') else data_in;  --logic to select R7_data



data_out1 <= register_out(to_integer(unsigned(sel_out1)));
data_out2 <= register_out(to_integer(unsigned(sel_out2)));

R0 <= register_out(0);
R1 <= register_out(1);
R2 <= register_out(2);
R3 <= register_out(3);
R4 <= register_out(4);
R5 <= register_out(5);
R6 <= register_out(6);
R7 <= register_out(7);



ena_demo<=ena;


process(sel_in,write_ena)------to select which register should be enabled to get written by data.
begin
ena <= (others => '0');
ena(to_integer(unsigned(sel_in))) <= write_ena;

end process; 

end reg_file;
