-- MIPS_register_file.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the MIPS 
-- archutecture 32 by 32bit register file
--
--
-- NOTES:
-- 2/21/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use work.STD_LOGIC_MATRIX.all;
-- entity

entity MIPS_register_file is
  port(i_RST         : in std_logic;
       i_CLK         : in std_logic;
       i_rd          : in std_logic_vector(4 downto 0); -- write port
       i_rs          : in std_logic_vector(4 downto 0); -- read port 1
       i_rt          : in std_logic_vector(4 downto 0); -- read port 2
       i_we	     : in std_logic;
       i_rdData      : in std_logic_vector(31 downto 0);-- write port data
       o_rsData      : out std_logic_vector(31 downto 0);-- read port 1 data
       o_rtData      : out std_logic_vector(31 downto 0));-- read port 2 data
end MIPS_register_file;

-- architecture
architecture structural of MIPS_register_file is

  component mux32t1_N is
  port(i_S          : in std_logic_vector(4 downto 0);
       i_D          : in std_logic_matrix(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;

  component dffg_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;

  component decoder_5t32 is
  port(i_A          : in std_logic_vector(4 downto 0);	-- write address
       o_Y          : out std_logic_vector(31 downto 0));
  end component;

  component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  signal s_Y,s_we_input : std_logic_vector(31 downto 0);
  signal s_dff_0 : std_logic_vector(31 downto 0) := (others => '0');
  signal s_D : std_logic_matrix(31 downto 0);

begin

  x1: decoder_5t32
	port map(i_A => i_rd,
		 o_Y => s_we_input);



  G_32_WE: for i in 0 to 31 generate
    write_enable: andg2
	port map(i_A => i_we,
		 i_B => s_we_input(i),
		 o_Y => s_Y(i));
  end generate G_32_WE;


  x2: dffg_N -- $0 special case reg
	generic map(N=>32)
        port map(i_CLK => i_CLK,
		 i_RST => i_RST,
		 i_WE  => s_Y(0),
		 i_D   => s_dff_0,
		 o_Q   => s_D(0));

  -- Instantiate N 32 bit dff instances.
  BIT31_DFF: for i in 1 to 31 generate
    x3: dffg_N
	generic map(N=>32)
        port map(i_CLK => i_CLK,
		 i_RST => i_RST,
		 i_WE  => s_Y(i),
		 i_D   => i_rdData,
		 o_Q   => s_D(i));
  end generate BIT31_DFF;

  x4: mux32t1_N
	port map(i_S => i_rs,
		 i_D => s_D,
		 o_O => o_rsData);
  x5: mux32t1_N
	port map(i_S => i_rt,
		 i_D => s_D,
		 o_O => o_rtData);
  
end structural;