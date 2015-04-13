--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:07:59 04/06/2015
-- Design Name:   
-- Module Name:   C:/Users/C16John.Terragnoli/Documents/Junior year/Academics/Second Semester/ECE 383/ISE Projects/Lab04/Lab04_tb.vhd
-- Project Name:  Lab04
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Lab04
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Lab04_tb IS
END Lab04_tb;
 

ARCHITECTURE behavior OF Lab04_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Lab04
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         btn : IN  std_logic_vector(4 downto 0);
         switches : IN  std_logic_vector(7 downto 0);
         SDATA_IN : IN  std_logic;
         BIT_CLK : IN  std_logic;
         SYNC : OUT  std_logic;
         SDATA_OUT : OUT  std_logic;
         AC97_n_RESET : OUT  std_logic;
         readyFake : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal btn : std_logic_vector(4 downto 0) := (others => '0');
   signal switches : std_logic_vector(7 downto 0) := (others => '0');
   signal SDATA_IN : std_logic := '0';
   signal BIT_CLK : std_logic := '0';
   signal readyFake : std_logic := '0';

 	--Outputs
   signal SYNC : std_logic;
   signal SDATA_OUT : std_logic;
   signal AC97_n_RESET : std_logic;
	
	
	--internal signals 
	signal ready : std_logic := '0'; 

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant BIT_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Lab04 PORT MAP (
          clk => clk,
          reset => reset,
          btn => btn,
          switches => switches,
          SDATA_IN => SDATA_IN,
          BIT_CLK => BIT_CLK,
          SYNC => SYNC,
          SDATA_OUT => SDATA_OUT,
          AC97_n_RESET => AC97_n_RESET,
          readyFake => readyFake
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   BIT_CLK_process :process
   begin
		BIT_CLK <= '0';
		wait for BIT_CLK_period/2;
		BIT_CLK <= '1';
		wait for BIT_CLK_period/2;
   end process;
	
	
	readyFake_process :process
   begin
		readyFake <= '0';
		wait for BIT_CLK_period*3;
		readyFake <= '1';
		wait for BIT_CLK_period;
   end process;

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		
		
		--fixing instantiations.  
		reset <= '1';
		switches <= "00000001";

		
--		readyFake <= '0', '1' after 20 ns, '0' after 30 ns, '1' after 50 ns, '0' after 60 ns, 
--						'1' after 80 ns, '0' after 90 ns, '1' after 110 ns, '0' after 120 ns, 
--						'1' after 140 ns, '0' after 150 ns, '1' after 170 ns, '0' after 180 ns,
--						'1' after 200 ns, '0' after 210 ns, '1' after 230 ns, '0' after 240 ns;
		
		btn <= "00000", "01000" after 20 ns, "00000" after 30 ns, "00010" after 100 ns, "00000" after 110 ns; 

      wait;
   end process;

END;
