----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/02/2016 06:44:29 PM
-- Design Name: 
-- Module Name: generate_spi_clk_0 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity generate_spi_clk_0 is
    generic (
        C_S_AXI_DATA_WIDTH : integer := 32
    );
    port (
        s_axi_aclk : in std_logic;
        s_axi_aresetn : in std_logic;
        
        enable : in std_logic;
        spi_clk : out std_logic;
        
        reg_spi_clk_period_0 : in std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 )
    );
end generate_spi_clk_0;

architecture Behavioral of generate_spi_clk_0 is
    signal spi_clk_buff : std_logic;
begin
    
    spi_clk <= spi_clk_buff;
    process ( s_axi_aclk )
        variable counter_0 : integer;
    begin
        if ( rising_edge( s_axi_aclk ) ) then
            if ( s_axi_aresetn = '0' or enable = '0' ) then
                spi_clk_buff <= '0';
                counter_0 := 0;
            else
                if ( counter_0 = to_integer( unsigned( reg_spi_clk_period_0 ) ) ) then
                    spi_clk_buff <= not( spi_clk_buff );
                    counter_0 := 0;
                else
                    counter_0 := counter_0+1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
