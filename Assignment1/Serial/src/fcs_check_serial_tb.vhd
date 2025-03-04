
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
	signal start_of_frame: std_logic := '0';
	signal end_of_frame	: std_logic := '0';
	signal data_in			: std_logic := '0';
	signal fcs_error		: std_logic := '0';
	constant ETH_FRAME_BYTES  : integer := 64;
	constant FRAME_BITS_TOTAL : integer := ETH_FRAME_BYTES * 8;  -- 64 bytes * 8 bits
	signal frame : std_logic_vector(FRAME_BITS_TOTAL-1 downto 0) := 
       X"0010A47BEA8000123456789008004500002EB3FE000080110540C0A8002CC0A8000404000400001A2DE8000102030405060708090A0B0C0D0E0F1011E6C53DB2";
	 
    constant CHECKSUM_BITS 	: integer := 4 * 8;      -- 4 bytes * 8 bits
	 constant CLOCK_PERIOD 		: time := 5 ns;

	 
begin
	clk <= not clk after CLOCK_PERIOD;
	reset <= '1', '0' after  CLOCK_PERIOD;
	dut : entity work.fcs_check_serial 
		port map(
			clk 				=> clk,
			reset				=> reset,
			start_of_frame	=> start_of_frame,
			end_of_frame	=> end_of_frame,
			data_in			=> data_in,
			fcs_error 		=> fcs_error 
		);

	stimulus:
	process begin
		wait until (reset = '0');
		start_of_frame <= '1';
		for i in FRAME_BITS_TOTAL-1 downto 0 loop
			data_in <= frame(i);
			if( i > 31 ) then
				end_of_frame <= '0';
			else 
				end_of_frame <= '1';
			end if;
			wait until rising_edge(clk);
		end loop;
		
		wait until rising_edge(clk);
		assert false report "End of simulation" severity failure;
		wait;
	end process stimulus;
end Testbench;