library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.essential_components.all;

entity data_memory is
port(data_in : in std_logic_vector(15 downto 0);
     address_to_write : in std_logic_vector(7 downto 0);
	  address_to_read : in std_logic_vector(7 downto 0);
      data_out  : out std_logic_vector(15 downto 0);
		clk,w_ena,r_ena,clear  : in std_logic);
end data_memory;


architecture data_arch of data_memory is

type LUT_memory is array (255 downto 0) of std_logic_vector(15 downto 0);
signal memory : LUT_memory :=(others=>"0000000000000000");
signal ena : std_logic_vector(255 downto 0):=(others=>'0');
begin


data_out <= memory(to_integer(unsigned(address_to_read))) when (r_ena='1') else "XXXXXXXXXXXXXXXX";

write_on_all_mem : for i in 0 to 255 generate
    mem : reg generic map (16) port map(data_in , memory(i),clk,ena(i),clear );
end  generate ;


process(address_to_write,w_ena)------to select which memory address should be enabled to get written by data.
begin

ena <= (others => '0');
ena(to_integer(unsigned(address_to_write))) <= w_ena;

end process;




end data_arch;