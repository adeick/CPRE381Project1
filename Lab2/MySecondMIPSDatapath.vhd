-- MyFirstMIPSDatapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the MIPS 
-- datapath
--
--
-- NOTES:
-- 2/21/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity

entity MySecondMIPSDatapath is
  port(i_RST         : in std_logic;
       i_rdDataSel   : in std_logic; -- rdData select
       i_we	     : in std_logic; -- mem write enable
       i_SignSel     : in std_logic; -- determine if sign extension or 0 extension
       i_CLK         : in std_logic;
       i_ALUSrc	     : in std_logic;
       i_nAdd_Sub    : in std_logic;
       i_rd          : in std_logic_vector(4 downto 0); -- write port
       i_rs          : in std_logic_vector(4 downto 0); -- read port 1
       i_rt          : in std_logic_vector(4 downto 0); -- read port 2
       i_immediate   : in std_logic_vector(15 downto 0);
       o_rsData      : out std_logic_vector(31 downto 0);-- read port 1 data
       o_mem      : out std_logic_vector(31 downto 0);-- memory output based off of input address
       o_rtData      : out std_logic_vector(31 downto 0));-- read port 2 data
end MySecondMIPSDatapath;

-- architecture
architecture structural of MySecondMIPSDatapath is

  component mux2t1_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component MIPS_register_file is
  port(i_RST         : in std_logic;
       i_CLK         : in std_logic;
       i_rd          : in std_logic_vector(4 downto 0); -- write port
       i_rs          : in std_logic_vector(4 downto 0); -- read port 1
       i_rt          : in std_logic_vector(4 downto 0); -- read port 2
       i_rdData      : in std_logic_vector(31 downto 0);-- write port data
       o_rsData      : out std_logic_vector(31 downto 0);-- read port 1 data
       o_rtData      : out std_logic_vector(31 downto 0));-- read port 2 data
  end component;

  component AddSub_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub   : in std_logic;
       o_S	    : out std_logic_vector(N-1 downto 0);
       o_C          : out std_logic);
  end component;

  component dmem is
	generic (
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10);

	port(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
  end component;

  component bit_extender_16t32 is
  port(i_SignSel    : in std_logic;
       i_D          : in std_logic_vector(15 downto 0);
       o_D          : out std_logic_vector(31 downto 0));
  end component;


  signal s_B : std_logic_vector(31 downto 0);
  signal o_ALU : std_logic_vector(31 downto 0);
  signal s_dff_0 : std_logic_vector(31 downto 0) := (others => '0');
  signal s_rdDataMux : std_logic_vector(31 downto 0);
  signal s_bit_encoderOut : std_logic_vector(31 downto 0);

begin

  x1: MIPS_register_file
  port map(
       i_RST => i_RST,
       i_CLK => i_CLK,
       i_rd  => i_rd,
       i_rs  => i_rs,
       i_rt  => i_rt,
       i_rdData => s_rdDataMux,
       o_rsData => o_rsData,
       o_rtData => o_rtData);

  x1_5: bit_extender_16t32
  port map(
       i_SignSel => i_SignSel,
       i_D	 => i_immediate,
       o_D	 => s_bit_encoderOut);

  x2: mux2t1_N
	generic map(N=>32)
	port map(i_S => i_ALUSrc,
		 i_D0 => o_rtData,
		 i_D1 => s_bit_encoderOut,
		 o_O => s_B);

  x3: AddSub_N
  generic map(N => 32)
  port map(i_A => o_rsData,
       i_B => s_B,
       i_nAdd_Sub => i_nAdd_Sub,
       o_S	  => o_ALU);

  x4: mux2t1_N;
	generic map(N=>32)
	port map(i_S => i_rdDataSel,
		 i_D0 => o_ALU,
		 i_D1 => o_mem,
		 o_O => s_rdDataMux);
  x5: dmem
	port map(addr => o_ALU(9 downto 0),
		 we => i_we,
		 data => o_rtData,
		 clk  => i_CLK,
		 q => o_mem);
  
end structural;