Library ieee; 
USE ieee.std_logic_1164.all ;
use IEEE.NUMERIC_STD.ALL;


entity fcs_check_serial is 
	generic (
		FRAME_BITS : integer := 512
	);
	port (
		clk            : in std_logic; -- system clock
		reset          : in std_logic; -- asynchronous reset
		start_of_frame : in std_logic; -- arrival of the first bit.
		end_of_frame   : in std_logic; -- arrival of the first bit in FCS.
		data_in  		: in std_logic; -- serial input data.
		fcs_error      : out std_logic -- indicates an error.
	);

end fcs_check_serial;

Library ieee; 
USE ieee.std_logic_1164.all ;
use IEEE.NUMERIC_STD.ALL;

entity Regs is
	generic (
		REG_NUM : integer := 32
	);
	port (
			data_in 	: in  std_logic_vector(REG_NUM-1 downto 0);
			clk  		: in  std_logic;
			reset  	: in  std_logic;
			data_out : out std_logic_vector(REG_NUM-1 downto 0)
			);	
	signal regFile : std_logic_vector(REG_NUM-1 downto 0);
end entity;



ARCHITECTURE Behavior OF fcs_check_serial IS
	constant C_REG_NUM : integer := 32;
	signal regFileOut	 : std_logic_vector(c_REG_NUM-1 downto 0);
	signal Gx			 : std_logic_vector(c_REG_NUM-1 downto 0) := x"04C11DB7"; -- CRC-32 polynomial
	signal g 			 : std_logic_vector(c_REG_NUM-1 downto 0);
	signal bit_count   : unsigned (FRAME_BITS downto 0);
	signal bitCountReg : unsigned (FRAME_BITS downto 0) := (others => '0');
	signal compute_crc : std_logic := '0';
	signal compl_en 	 : std_logic := '0';
	signal data 		 : std_logic;
	
BEGIN

	compute_crc <= '1' when (start_of_frame = '1' or compute_crc = '1') and (bit_count < FRAME_BITS) else '0';
	compl_en    <= '1' when (bit_count < 32) or ( end_of_frame = '1') else '0'; 
	data 			<= not data_in when compl_en = '1' else data_in;
	fcs_error   <= '0' when (bit_count = FRAME_BITS and regFileOut = x"00000000") else '1';  
	
	g(0) <= regFileOut(0) when compute_crc = '0' else 
			data xor regFileOut(C_REG_NUM-1) when Gx(0) = '1';
	
	gen_gAssign : for i in 1 to C_REG_NUM-1 generate
		g(i) <= regFileOut(i) when compute_crc = '0' else 
					regFileOut(i-1) xor regFileOut(C_REG_NUM-1) when Gx(i) = '1'
					else regFileOut(i-1);
	end generate;
	
	reg_instance : entity work.Regs
			generic map (
				REG_NUM => C_REG_NUM
			
			)
			port map (
				data_in 	=> g,
				clk  		=> clk,
				reset  	=> reset,
				data_out => regFileOut
			);
	
	
	process(reset,clk)
	begin
		if(reset = '1') then
			bitCountReg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(compute_crc = '1') then
				bitCountReg <= bitCountReg + 1;
			else 
				bitCountReg <= bitCountReg;
			end if;
		end if;
		bit_count <= bitCountReg;
	end process;

END Behavior;


	
architecture Behavior of Regs is
begin
	process(reset,clk)
	begin
		if(reset = '1') then
			regFile<= (others => '0');
		elsif (rising_edge(clk)) then
			regFile <= data_in;
		end if;
	end process;
	data_out <= regFile;
end Behavior;