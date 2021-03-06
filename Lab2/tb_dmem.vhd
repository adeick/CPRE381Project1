-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_dmem.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for data memory 
-- implemenation of ram             
--
-- 02/22/2021 by JB::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_dmem is
  generic(gCLK_HPER   : time := 50 ns);
end tb_dmem;

architecture behavior of tb_dmem is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component dmem
	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);

	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_we    : std_logic := '0';
  signal s_addr  : std_logic_vector(9 downto 0) := (others => '0');
  signal s_data  : std_logic_vector(31 downto 0);
  signal s_q     : std_logic_vector(31 downto 0);

begin

  DUT: dmem 
  --generic map(N => 32)
  port map(clk  => s_CLK,
           we   => s_we,
           addr => s_addr,
	   data => s_data,
	   q    => s_q);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

    for i in 0 to 9 loop
      -- read value thats in correct address
      s_addr   <= std_logic_vector(to_unsigned(i,s_addr'length));

      -- write to 0x100+i
      wait for cCLK_PER;
      s_data <= s_q;
      s_addr   <= std_logic_vector(to_unsigned(i+256,s_addr'length));
      s_we <= '1'; --enable write
      wait for cCLK_PER; 
      s_we <= '0'; --disable write after written
    end loop;


    wait;
  end process;
  
end behavior;