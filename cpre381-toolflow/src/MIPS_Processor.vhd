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

entity MIPS_processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); 
end  MIPS_processor;


architecture structure of MIPS_processor is

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


--Added Signals  
  signal s_RegOutReadData1 : std_logic_vector(N-1 downto 0);
    --Data2 is named s_DMemData
  signal s_RegInReadData1,    s_RegInReadData2,            s_RegD: std_logic_vector(4 downto 0);
  --rs(instructions [25-21]), rt(instructions [20-16]),     rd (instructions [15-11])
  signal s_shamt: std_logic_vector(4 downto 0);

  signal s_imm16 : std_logic_vector(15 downto 0); --instruction bits [15-0]
  signal s_imm32 : std_logic_vector(31 downto 0); --after extension
  signal s_imm32x4 : std_logic_vector(31 downto 0); --after multiplication
  signal s_immMuxOut : std_logic_vector(N-1 downto 0); --Output of Immediate Mux (ALU 2nd input)

  signal s_opCode   : std_logic_vector(5 downto 0);--instruction bits[31-26] 
  signal s_funcCode : std_logic_vector(5 downto 0);--instruction bits[5-0]
  
  signal s_inputPC: std_logic_vector(31 downto 0); --wire from the jump mux
  signal s_Ctrl  : std_logic_vector(14 downto 0); --Control Brick Output, each bit is a different switch
--Control Signals
signal s_ALUSrc    : std_logic; 
signal s_jr    : std_logic; 
signal s_jal    : std_logic; 
signal s_ALUOp     : std_logic_vector(3 downto 0); --ALU Code
signal s_MemtoReg    : std_logic; 
-- s_MemWrite this is s_DMemWr 
--signal s_RegWrite    : std_logic;
--this is s_RegWr 
signal s_RegDst       : std_logic;
signal s_Branch        : std_logic;
signal s_SignExt     : std_logic; 
signal s_jump     : std_logic; 

--Addressing Signals
signal s_PCPlusFour   : std_logic_vector(N-1 downto 0);
signal s_jumpAddress  : std_logic_vector(N-1 downto 0);
signal s_branchAddress: std_logic_vector(N-1 downto 0);
signal s_MemToReg0    : std_logic_vector(31 downto 0);
signal s_RegDst0      : std_logic_vector(4 downto 0);

signal s_normalOrBranch,s_finalJumpAddress : std_logic_vector(31 downto 0);
  
--ALU Items
--Inputs:
  -- s_RegOutReadData1 and s_immMuxOut
  -- s_ALUOp
--Outputs:
signal s_ALUBranch: std_logic;
--  s_ALUResult is named s_DMemAddr

signal s1, s2, s3 : std_logic; --don't care output from adder and ALU
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
  component control_unit is
    port( i_opcode  	: in std_logic_vector(5 downto 0);
	        i_funct	  	: in std_logic_vector(5 downto 0);
	        o_Ctrl_Unt	: out std_logic_vector(14 downto 0));
  end component;

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

  component extender is
  port(i_I          : in std_logic_vector(15 downto 0);     -- Data value input
	     i_C		      : in std_logic; --0 for zero, 1 for signextension
       o_O          : out std_logic_vector(31 downto 0));   -- Data value output
  end component; --Andrew's component

  component mux2t1_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

  component addersubtractor is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port( nAdd_Sub: in std_logic;
	        i_A 	  : in std_logic_vector(N-1 downto 0);
		      i_B		  : in std_logic_vector(N-1 downto 0);
		      o_Y		  : out std_logic_vector(N-1 downto 0);
		      o_Cout	: out std_logic);
  end component;

  component alu is
    port(i_A    : in std_logic_vector(31 downto 0);
           i_B        : in std_logic_vector(31 downto 0);
           i_aluOp    : in std_logic_vector(3 downto 0);
           i_shamt    : in std_logic_vector(4 downto 0);
           o_F        : out std_logic_vector(31 downto 0);
           overFlow   : out std_logic;
           zero       : out std_logic);
  end component;

  component MIPS_pc is 
  port(
    i_CLK : in std_logic; --=> iClk,
    i_RST : in std_logic; --=> iRST,
    i_D   : in std_logic_vector(31 downto 0); --s_inputPC, 
    o_Q   : out std_logic_vector(31 downto 0));--=> s_NextInstAddr);
  end component;

begin
  
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;
  -- TODO: This is required to be your final input to your instruction memory. 
  -- This provides a feasible method to externally load the memory module which means that the 
  -- synthesis tool must assume it knows nothing about the values stored in the instruction memory. 
  -- If this is not included, much, if not all of the design is optimized out because the synthesis 
  -- tool will believe the memory to be all zeros.

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

  instructionSlice: process(s_Inst) --snip the Instruction data into smaller parts
  begin

			s_imm16(15 downto 0) <= s_Inst(15 downto 0); --bits[15-0] into Sign Extender
			s_funcCode(5 downto 0) <= s_Inst(5 downto 0); --bits[5-0] into ALU Control 
			s_shamt(4 downto 0) <= s_Inst(10 downto 6); --bits[1--6] into ALU (for Barrel Shifter) 
			s_regD(4 downto 0) <= s_Inst(15 downto 11); --bits[11-15] into RegDstMux bits[4-0]
			s_RegInReadData2(4 downto 0) <= s_Inst(20 downto 16); --bits[16-20] into RegDstMux and Register (bits[4-0])
			s_RegInReadData1(4 downto 0) <= s_Inst(25 downto 21); --bits[25-21] into Register (bits[4-0])
			s_opCode(5 downto 0) <= s_Inst(31 downto 26); --bits[26-31] into Control Brick (bits[5-0)

      s_jumpAddress(0) <= '0';
      s_jumpAddress(1) <= '0'; --Set first two bits to zero
      s_jumpAddress(27 downto 2) <= s_Inst(25 downto 0); --Instruction bits[25-0] into bits[27-2] of jumpAddr
    end process;
    
    oALUOut <= s_DMemAddr; --oALU is for synthesis
    
  control: control_unit
  port map(i_opcode  	=> s_opCode, --in std_logic_vector(5 downto 0);
          i_funct	  	=> s_funcCode, --in std_logic_vector(5 downto 0);
          o_Ctrl_Unt	=> s_Ctrl); --out std_logic_vector(11 downto 0));

    controlSlice: process(s_Ctrl)
    begin
    --Control Signals
    s_jr <= s_Ctrl(14);
    s_jal <= s_Ctrl(13);
    s_ALUSrc <= s_Ctrl(12);
    s_ALUOp(3 downto 0) <= s_Ctrl(11 downto 8);
    s_MemtoReg <= s_Ctrl(7);
    s_DMemWr <= s_Ctrl(6); 
    s_RegWr <= s_Ctrl(5);
    s_RegDst   <= s_Ctrl(4);
    s_Branch    <= s_Ctrl(3);
    s_SignExt  <= s_Ctrl(2);
    s_jump     <= s_Ctrl(1);

    s_Halt <= s_Ctrl(0);
    end process;

  addFour: addersubtractor
  generic map(N => 32)
  port map( nAdd_Sub => '0',--in std_logic;
            i_A 	   => s_IMemAddr,--in std_logic_vector(N-1 downto 0);
            i_B		   => x"00000004",--in std_logic_vector(N-1 downto 0);
            o_Y		   => s_PCPlusFour,--out std_logic_vector(N-1 downto 0);
            o_Cout	 => s1);--out std_logic);

  signExtender: extender
  port map( i_I     => s_imm16, --in std_logic_vector(15 downto 0);     -- Data value input
	          i_C			=> s_SignExt, --in std_logic; --0 for zero, 1 for sign-extension
            o_O     => s_imm32); --out std_logic_vector(31 downto 0));   -- Data value output);

  jumpAddresses: process(s_PCPlusFour, s_imm32)
  begin
    --Calculate Jump Address
      s_jumpAddress(31 downto 28) <= s_PCPlusFour(31 downto 28); --PC+4 bits[31-28] into bits[31-28] of jumpAddr

    --Calculate Branch Address Offset
    s_imm32x4(0) <= '0';
    s_imm32x4(1) <= '0'; --Set first two bits to zero
    s_imm32x4(31 downto 2) <= s_imm32(29 downto 0); --imm32 bits[29-0] into bits[31-2] of jumpAddr
	end process;

  pcReg: MIPS_pc
  port map(
    i_CLK => iClk,
    i_RST => iRST,
    i_D => s_inputPC, 
    o_Q => s_NextInstAddr);

  --RegFile: --
  registers: regfile 
  port map(clk			=> iCLK,--std_logic;
		i_wA	        	=> s_RegWrAddr,--std_logic_vector(4 downto 0);
		i_wD	        	=> s_RegWrData,--std_logic_vector(31 downto 0);
		i_wC	        	=> s_RegWr,--std_logic;
		i_r1	        	=> s_RegInReadData1,--std_logic_vector(4 downto 0);
		i_r2	        	=> s_RegInReadData2,--std_logic_vector(4 downto 0);
		reset	        	=> iRST,--std_logic;
    o_d1            => s_RegOutReadData1,-- std_logic_vector(31 downto 0);
    o_d2            => s_DMemData);-- std_logic_vector(31 downto 0));

  branchAdder: addersubtractor
  generic map(N => 32)
  port map( nAdd_Sub => '0',--in std_logic;
            i_A 	   => s_PCPlusFour,--in std_logic_vector(N-1 downto 0);
            i_B		   => s_imm32x4,--in std_logic_vector(N-1 downto 0);
            o_Y		   => s_branchAddress,--out std_logic_vector(N-1 downto 0);
            o_Cout	 => s2);--out std_logic);


  mainALU: alu
    port map( i_A        => s_RegOutReadData1, -- in std_logic_vector(31 downto 0);
              i_B        => s_immMuxOut, -- in std_logic_vector(31 downto 0);
              i_aluOp    => s_ALUOp, -- in std_logic_vector(3 downto 0);
              i_shamt    => s_shamt, -- in std_logic_vector(4 downto 0);
              o_F        => s_DMemAddr, -- out std_logic_vector(31 downto 0);
              overFlow   => s_Ovfl, -- out std_logic;
              zero       => s_ALUBranch);-- out std_logic);

  -- Muxes
  ALUSrc: mux2t1_N
  generic map(N => 32) -- Generic of type integer for input/output data width. Default value is 32.
  port map(i_S   => s_ALUSrc,
        i_D0      => s_DMemData,
        i_D1      => s_imm32,
        o_O       => s_immMuxOut);

  jumpReg: mux2t1_N
  generic map(N => 32) 
  port map(i_S   => s_jr,
        i_D0      => s_jumpAddress,
        i_D1      => s_RegOutReadData1,
        o_O       => s_finalJumpAddress);
        
  jalData: mux2t1_N
  generic map(N => 32) 
  port map(i_S   => s_jal,
        i_D0      => s_DMemAddr, --This is the ALU Output
        i_D1      => s_PCPlusFour,
        o_O       => s_MemToReg0);
        
  jalAddr: mux2t1_N
  generic map(N => 5) 
  port map(i_S   => s_jal,
        i_D0      => s_RegInReadData2, --rt is taking the place of rd,
        i_D1      => "11111", -- register 31
        o_O       => s_RegDst0);

  RegDst: mux2t1_N
  generic map(N => 5) -- Generic of type integer for input/output data width. Default value is 32.
  port map(i_S   => s_RegDst,
        i_D0      => s_RegDst0, --output of jalAddr mux
        i_D1      => s_RegD, --rd
        o_O       => s_RegWrAddr);
  Branch: mux2t1_N
  generic map(N => 32) 
  port map(i_S    => (s_Branch AND s_ALUBranch),
        i_D0      => s_PCPlusFour, 
        i_D1      => s_branchAddress,
        o_O       => s_normalOrBranch);
  Jump: mux2t1_N
  generic map(N => 32) 
  port map(i_S    => s_jump,
        i_D0      => s_normalOrBranch, 
        i_D1      => s_finalJumpAddress,
        o_O       => s_inputPC);
  MemtoReg: mux2t1_N
  generic map(N => 32) 
  port map(i_S    => s_MemtoReg,
        i_D0      => s_MemToReg0, 
        i_D1      => s_DMemOut,
        o_O       => s_RegWrData);
  
  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

end structure;
