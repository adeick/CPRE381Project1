-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- control_unit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the control unit
-- for the MIPS single cycle processor
--
--
-- NOTES:
-- 03/08/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity control_unit is
	port(i_opcode  	  	: in std_logic_vector(5 downto 0);
	     i_funct	  	: in std_logic_vector(5 downto 0);
	     o_Ctrl_Unt		: out std_logic_vector(11 downto 0));
end control_unit;

-- architecture
architecture dataflow of control_unit is
signal s_RTYPE : std_logic_vector(11 downto 0);
begin

------------------------- FORMAT of o_Ctrl_Unt ----------------------------
-- "  0       0000          0        0      1       1       0       1    0"
-- "ALUSrc  ALUControl  MemtoReg  we_mem  we_reg  RegDst  PCSrc  SignExt j"
---------------------------------------------------------------------------

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