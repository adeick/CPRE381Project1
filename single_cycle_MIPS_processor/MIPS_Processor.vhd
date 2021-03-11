-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

-- Added Control Signals
  signal s_ALUSrc    : std_logic; -- TODO: use this signal as the final data memory data input

--Added Signals  
  signal s_RegOutReadData1, s_RegOutReadData2 : std_logic_vector(N-1 downto 0); 
  signal s_RegInReadData1,    s_RegInReadData2,            s_RegD: std_logic_vector(4 downto 0);
  --rs(instructions [25-21]), rt(instructions [20-16]),     rd (instructions [15-11])
  signal s_imm32 : std_logic_vector(31 downto 0);
  signal s_imm16 : std_logic_vector(15 downto 0); 
  signal s_immMuxOut : std_logic_vector(N-1 downto 0); --Output of Immediate Mux

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
  component regfile is 
  port(clk			: in std_logic;
      i_wA		: in std_logic_vector(4 downto 0); --Write Address
      i_wD		: in std_logic_vector(31 downto 0); --Write Data
      i_wC		: in std_logic; --WriteControl aka RegWrite
      i_r1		: in std_logic_vector(4 downto 0); --Read 1
      i_r2		: in std_logic_vector(4 downto 0); --Read 2
      reset		: in std_logic;           --Reset
      o_d1        : out std_logic_vector(31 downto 0); --Output Data 1
      o_d2        : out std_logic_vector(31 downto 0)); --Output Data 2
  end component; --Andrew's component

  component mux2t1_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  --RegFile: --
  registers: regfile 
  port map(clk			=> iCLK,--std_logic;
		i_wA	        	=> s_RegWrAddr,--std_logic_vector(4 downto 0);
		i_wD	        	=> s_RegWrData,--std_logic_vector(31 downto 0);
		i_wC	        	=> s_RegWr,--std_logic;
		i_r1	        	=> s_RegInReadData1,--std_logic_vector(4 downto 0);
		i_r2	        	=> s_RegInReadData2,--std_logic_vector(4 downto 0);
		reset	        	=> s_,--std_logic;
    o_d1            => s_RegOutReadData1,-- std_logic_vector(31 downto 0);
    o_d2            => s_RegOutReadData2);-- std_logic_vector(31 downto 0));

  --AddSub: --

  immediateMux: mux2t1_N
  generic map(32 => N) -- Generic of type integer for input/output data width. Default value is 32.
  port map(i_S   => s_ALUSrc,
       i_D0      => s_RegOutReadData2,
       i_D1      => s_imm32,
       o_O       => s_immMuxOut);

  regDstMux: mux2t1_N
  generic map(5 => N) -- Generic of type integer for input/output data width. Default value is 32.
  port map(i_S   => s_RegDst,
       i_D0      => s_RegInReadData2, --rt is taking the place of rd
       i_D1      => s_RegD, --rd
       o_O       => s_RegWrData);
  --SignExtender

  
  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

end structure;
