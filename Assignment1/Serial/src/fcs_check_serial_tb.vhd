
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;

library STD;
use STD.textio.all;

entity fcs_check_serial_tb is
end fcs_check_serial_tb;


architecture Testbench of fcs_check_serial_tb is
	signal clk 				: std_logic := '0';
	signal reset 	 		: std_logic := '1';
	signal start_of_frame	: std_logic := '0';
	signal end_of_frame		: std_logic := '0';
	signal data_in			: std_logic := '0';
	signal fcs_error		: std_logic := '0'; 
	
begin
	clk <= not clk after 1 ns;
	reset <= '1', '0' after  5 ns;

	dut : entity work.fcs_check_serial 
		port map(
			clk 			=> clk,
			reset			=> reset,
			start_of_frame	=> start_of_frame,
			end_of_frame	=> end_of_frame,
			data_in			=> data_in,
			fcs_error 		=> fcs_error 
		);

	stimulus:
	process begin
		wait until (reset = '0');
		data_in <= '1';
		wait for 2 ns;
		data_in <= '0';
		wait for 2 ns;
		wait;
	end process stimulus;
end Testbench;