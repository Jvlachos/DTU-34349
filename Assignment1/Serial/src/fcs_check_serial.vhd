Library ieee; 
USE ieee.std_logic_1164.all ;


entity fcs_check_serial is 
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


entity D_FF is
		port (
			D_in : in  std_logic;
			CLK  : in  std_logic;
			RST  : in  std_logic;
			Q_out: out std_logic
		);
end entity;



ARCHITECTURE Behavior OF fcs_check_serial IS
	constant c_REG_NUM : integer := 32;
	signal regFile : std_logic_vector(c_REG_NUM-1 downto 0);
	signal Q_out : std_logic_vector(c_REG_NUM-1 downto 0);
	signal qin   : std_logic;
BEGIN
	
	gen_registers : for i in 0 to c_REG_NUM-1 generate
		reg_instance : entity work.D_FF
			port map (
				D_in => regFile(i),
				CLK  => clk,
				RST  => reset,
				Q_out=> Q_out(i)
			);
	end generate gen_registers;
	qin <= '1';
	process(clk)
	begin
		if(reset = '1') then
			regFile <= (others => '0');
		elsif(rising_edge(clk)) then
			regFile <= regFile (c_REG_NUM-2 downto 0 ) & qin;
		end if;
	end process;
	
	
END Behavior;


	
architecture Behavior of D_FF is
begin
	process(CLK)
	begin
		if(RST = '1') then
			Q_out <= '0';
		elsif(rising_edge(CLK)) then
			Q_out <= D_in;
		end if;
	end process;
end Behavior;