Library ieee; 
USE ieee.std_logic_1164.all ;
use IEEE.NUMERIC_STD.ALL;


entity fcs_check_parallel is 
	generic (
		FRAME_BITS : integer := 512;
		CRC_SIZE   : integer := 32
		
	);
	port (
		clk            : in std_logic; -- system clock
		reset          : in std_logic; -- asynchronous reset
		start_of_frame : in std_logic; -- arrival of the first bit.
		end_of_frame   : in std_logic; -- arrival of the first bit in FCS.
		data_in  		: in std_logic_vector(7 downto 0); -- serial input data.
		fcs_error      : out std_logic -- indicates an error.
	);

end fcs_check_parallel;

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
			data_out : out std_logic_vector(REG_NUM-1 downto 0);
			comp_crc : in  std_logic
			);	
	signal regFile : std_logic_vector(REG_NUM-1 downto 0);
end entity;



ARCHITECTURE Behavior OF fcs_check_parallel IS
	constant C_REG_NUM : integer := CRC_SIZE;
	constant POLY 		 : std_logic_vector(CRC_SIZE-1 downto 0) := x"04C11DB7";
	signal regFileOut	 : std_logic_vector(c_REG_NUM-1 downto 0);
	signal g 			 : std_logic_vector(c_REG_NUM-1 downto 0);
	signal bit_count   : unsigned (9 downto 0);
	signal bitCountReg : unsigned (9 downto 0);
	signal compute_crc : std_logic := '0';
	signal compl_en 	 : std_logic := '0';
	signal data 		 : std_logic_vector (7 downto 0);
	
BEGIN

	compute_crc <= '1' when (start_of_frame = '1' or compute_crc = '1') and (bit_count < FRAME_BITS) else '0';
	compl_en    <= '1' when (bit_count < 32) or ( end_of_frame = '1') else '0'; 
	data 			<= not data_in when compl_en = '1' else data_in;
	fcs_error   <= '0' when (bit_count = FRAME_BITS-8 and g = x"00000000") else '1';  
	
	
	
	g(0)  <= regFileOut(24) xor regFileOut(30) xor data(0);
	g(1)  <= regFileOut(24) xor regFileOut(25) xor regFileOut(30) xor regFileOut(31) xor data(1);
	g(2)  <= regFileOut(24) xor regFileOut(25) xor regFileOut(26) xor regFileOut(30) xor regFileOut(31) xor data(2);
	g(3)  <= regFileOut(25) xor regFileOut(26) xor regFileOut(27) xor regFileOut(31) xor data(3);
	g(4)  <= regFileOut(24) xor regFileOut(26) xor regFileOut(27) xor regFileOut(28) xor regFileOut(30) xor data(4);
	g(5)  <= regFileOut(24) xor regFileOut(25) xor regFileOut(27) xor regFileOut(28) xor regFileOut(29) xor regFileOut(30) xor regFileOut(31) xor data(5);
	g(6)  <= regFileOut(25) xor regFileOut(26) xor regFileOut(28) xor regFileOut(29) xor regFileOut(30) xor regFileOut(31) xor data(6);
	g(7)  <= regFileOut(24) xor regFileOut(26) xor regFileOut(27) xor regFileOut(29) xor regFileOut(31) xor data(7);
	g(8)  <= regFileOut(0) xor regFileOut(24) xor regFileOut(25) xor regFileOut(27) xor regFileOut(28);
	g(9)  <= regFileOut(1) xor regFileOut(25) xor regFileOut(26) xor regFileOut(28) xor regFileOut(29);
	g(10) <= regFileOut(2) xor regFileOut(24) xor regFileOut(26) xor regFileOut(27) xor regFileOut(29);
	g(11) <= regFileOut(3) xor regFileOut(24) xor regFileOut(25) xor regFileOut(27) xor regFileOut(28);
	g(12) <= regFileOut(4) xor regFileOut(24) xor regFileOut(25) xor regFileOut(26) xor regFileOut(28) xor regFileOut(29) xor regFileOut(30);
	g(13) <= regFileOut(5) xor regFileOut(25) xor regFileOut(26) xor regFileOut(27) xor regFileOut(29) xor regFileOut(30) xor regFileOut(31);
	g(14) <= regFileOut(6) xor regFileOut(26) xor regFileOut(27) xor regFileOut(28) xor regFileOut(30) xor regFileOut(31);
	g(15) <= regFileOut(7) xor regFileOut(27) xor regFileOut(28) xor regFileOut(29) xor regFileOut(31);
	g(16) <= regFileOut(8) xor regFileOut(24) xor regFileOut(28) xor regFileOut(29);
	g(17) <= regFileOut(9) xor regFileOut(25) xor regFileOut(29) xor regFileOut(30);
	g(18) <= regFileOut(10) xor regFileOut(26) xor regFileOut(30) xor regFileOut(31);
	g(19) <= regFileOut(11) xor regFileOut(27) xor regFileOut(31);
	g(20) <= regFileOut(12) xor regFileOut(28);
	g(21) <= regFileOut(13) xor regFileOut(29);
	g(22) <= regFileOut(14) xor regFileOut(24);
	g(23) <= regFileOut(15) xor regFileOut(24) xor regFileOut(25) xor regFileOut(30);
	g(24) <= regFileOut(16) xor regFileOut(25) xor regFileOut(26) xor regFileOut(31);
	g(25) <= regFileOut(17) xor regFileOut(26) xor regFileOut(27);
	g(26) <= regFileOut(18) xor regFileOut(24) xor regFileOut(27) xor regFileOut(28) xor regFileOut(30);
	g(27) <= regFileOut(19) xor regFileOut(25) xor regFileOut(28) xor regFileOut(29) xor regFileOut(31);
	g(28) <= regFileOut(20) xor regFileOut(26) xor regFileOut(29) xor regFileOut(30);
	g(29) <= regFileOut(21) xor regFileOut(27) xor regFileOut(30) xor regFileOut(31);
	g(30) <= regFileOut(22) xor regFileOut(28) xor regFileOut(31);
	g(31) <= regFileOut(23) xor regFileOut(29);

	
	reg_instance : entity work.Regs
			generic map (
				REG_NUM => C_REG_NUM
			
			)
			port map (
				data_in 	=> g,
				clk  		=> clk,
				reset  	=> reset,
				data_out => regFileOut,
				comp_crc => compute_crc
			);
	
	
	process(reset,clk)
	begin
		if(reset = '1') then
			bitCountReg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(compute_crc = '1') then
				bitCountReg <= bitCountReg + 8;
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
		  if(comp_crc = '1') then
			regFile <= data_in;
		  else
			 regFile <= regFile;
		  end if;
		end if;
	end process;
	data_out <= regFile;
end Behavior;