-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the barrel 
-- shifter for ALU in the MIPS single cycle processor
--
-- The barrel shifter supports 2^5-1 shifts left or right logical or
-- arithmetic
--
-- NOTES:
-- 03/11/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity barrel_shifter is
	port(i_data		: in std_logic_vector(31 downto0);
	     i_shamt  	  	: in std_logic_vector(4 downto 0);
	     i_shft_dir	  	: in std_logic; -- 0 left, 1 right
	     i_shft_type	: in std_logic; -- 0 logical, 1 arithmetic
	     o_data     : out std_logic_vector(31 downto 0));
end barrel_shifter;

-- architecture
architecture dataflow of barrel_shifter is

signal s_RTYPE : std_logic_vector(11 downto 0);

begin


with i_funct select s_RTYPE <=
    "011010011010"  when "100000", -- add
    "000000011010"  when "100001", -- addu
    "000100011010"  when "100100", -- and
    "001010011010"  when "100111", -- nor
    "001000011010"  when "100110", -- xor
    "000110011010"  when "100101", -- or
    "001110011010"  when "101010", -- slt
    "010000011010"  when "000000", -- sll
    "010010011000"  when "000010", -- srl
    "010100011010"  when "000011", -- sra
    "011100011010"  when "100010", -- sub
    "000010011010"  when "100011", -- subu
    "000000000000"  when others;

with i_opcode select o_Ctrl_Unt <=
    s_RTYPE  	    when "000000", -- RTYPE
    "111010010010"  when "001000", -- addi
    "100000010010"  when "001001", -- addiu
    "100100010000"  when "001100", -- andi
    "101000010000"  when "001110", -- xori
    "100110010000"  when "001101", -- ori
    "101110010010"  when "001010", -- slti
    "101100010010"  when "001111", -- lui
    "110110000110"  when "000100", -- beq
    "111000000110"  when "000101", -- bne
    "100001010010"  when "100011", -- lw
    "100000100010"  when "101011", -- sw
    "000000000011"  when "000010", -- j
    "000000000000"  when others;

end dataflow;