-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- mux32t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the control unit
-- for the MIPS single cycle processor
--
--
-- NOTES:
-- 3/8/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity control_unit is
	port(i_opcode  	  : in std_logic_vector(5 downto 0);
	     i_funct	  : in std_logic_vector(5 downto 0);
	     o_	  : out std_logic);
end control_unit;

-- architecture
architecture dataflow of control_unit is
begin

with i_S select o_O <=
    i_D(0)  when "00000",
    i_D(1)  when "00001",
    i_D(2)  when "00010",
    i_D(3)  when "00011",
    i_D(4)  when "00100",
    i_D(5)  when "00101",
    i_D(6)  when "00110",
    i_D(7)  when "00111",
    i_D(8)  when "01000",
    i_D(9)  when "01001",
    i_D(10) when "01010",
    i_D(11) when "01011",
    i_D(12) when "01100",
    i_D(13) when "01101",
    i_D(14) when "01110",
    i_D(15) when "01111",
    i_D(16) when "10000",
    i_D(17) when "10001",
    i_D(18) when "10010",
    i_D(19) when "10011",
    i_D(20) when "10100",
    i_D(21) when "10101",
    i_D(22) when "10110",
    i_D(23) when "10111",
    i_D(24) when "11000",
    i_D(25) when "11001",
    i_D(26) when "11010",
    i_D(27) when "11011",
    i_D(28) when "11100",
    i_D(29) when "11101",
    i_D(30) when "11110",
    i_D(31) when "11111",
    i_D(0) when others;
end dataflow;