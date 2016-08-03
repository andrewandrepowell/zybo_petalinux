----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Andrew Powell
-- 
-- Create Date: 08/02/2016 04:12:55 PM
-- Design Name: 
-- Module Name: spi_cntrl_0 - Behavioral
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

entity spi_cntrl_0 is
    generic (
        SAMPLE_WIDTH : integer := 16
    );
    port (
        s_axi_aclk: in std_logic;
        s_axi_aresetn : in std_logic;
        
        enable : in std_logic;
        ready : out std_logic;
        sample_out : out std_logic_vector( SAMPLE_WIDTH-1 downto 0 );
        
        spi_clk_in : in std_logic;
        spi_clk_out : out std_logic;
        spi_cs : out std_logic := '1';
        spi_sdata : in std_logic
    );
end spi_cntrl_0;

architecture Behavioral of spi_cntrl_0 is
    type cntrl_state_type is ( CNTRL_STATE_IDLE_0, CNTRL_STATE_WAIT_0, CNTRL_STATE_DONE_0 );
    signal cntrl_state : cntrl_state_type := CNTRL_STATE_IDLE_0;
    type spi_state_type is ( SPI_STATE_IDLE_0, SPI_STATE_SAMPLE_0, SPI_STATE_DONE_0 );
    signal spi_state : spi_state_type := SPI_STATE_IDLE_0;
    signal spi_start_req : std_logic;
    signal spi_start_ack : std_logic;
    signal spi_done_req : std_logic;
    signal spi_done_ack : std_logic;
    signal spi_clk_en : std_logic;
    signal sample_0 : std_logic_vector( SAMPLE_WIDTH-1 downto 0 );
begin

    -- Control process
    process ( s_axi_aclk )
    begin
        if ( rising_edge( s_axi_aclk ) ) then
            if ( s_axi_aresetn = '0' ) then
                cntrl_state <= CNTRL_STATE_IDLE_0;
                spi_start_req <= '0';
                spi_done_ack <= '0';
                ready <= '0';
                sample_out <= ( others => '0');
            else
                case cntrl_state is
                    when CNTRL_STATE_IDLE_0 =>
                        if ( enable = '1' and spi_start_req = spi_start_ack ) then
                            spi_start_req <= not( spi_start_req );
                            cntrl_state <= CNTRL_STATE_WAIT_0;
                        end if;
                    when CNTRL_STATE_WAIT_0 =>
                        if ( spi_done_req /= spi_done_ack ) then
                            spi_done_ack <= not( spi_done_ack );
                            sample_out <= sample_0;
                            ready <= '1';
                            cntrl_state <= CNTRL_STATE_DONE_0;
                        end if;
                    when CNTRL_STATE_DONE_0 =>
                        if ( enable = '0' ) then
                            ready <= '0';
                            cntrl_state <= CNTRL_STATE_IDLE_0;
                        end if;
                    when others => null;
                end case;
            end if;
        end if;
    end process;
    
    -- SPI process
    spi_cs <= not(spi_clk_en);
    spi_clk_out <= spi_clk_in and spi_clk_en;
    process ( spi_clk_in, s_axi_aresetn )
        variable counter_0 : integer range 0 to SAMPLE_WIDTH;
    begin
        if ( s_axi_aresetn = '0' ) then
            spi_state <= SPI_STATE_IDLE_0;
            spi_start_ack <= '0';
            spi_done_req <= '0';
            spi_clk_en <= '0';
            sample_0 <= ( others => '0' );
            counter_0 := 0;
        elsif ( rising_edge( spi_clk_in ) ) then
            case spi_state is
                when SPI_STATE_IDLE_0 =>
                    if ( spi_start_req /= spi_start_ack ) then
                        spi_start_ack <= not( spi_start_ack );
                        spi_clk_en <= '1';
                        spi_state <= SPI_STATE_SAMPLE_0;
                    end if;
                when SPI_STATE_SAMPLE_0 => 
                    if ( counter_0 /= SAMPLE_WIDTH ) then
                        sample_0( SAMPLE_WIDTH-1 downto 1 ) <= sample_0( SAMPLE_WIDTH-2 downto 0 );  
                        sample_0( 0 ) <= spi_sdata;
                        counter_0 := counter_0+1;
                    else
                        spi_clk_en <= '0';
                        spi_state <= SPI_STATE_DONE_0;
                        counter_0 := 0;
                    end if;
                when SPI_STATE_DONE_0 =>
                    if ( spi_done_req = spi_done_ack ) then
                        spi_done_req <= not( spi_done_req );
                        spi_state <= SPI_STATE_IDLE_0;
                    end if;
                when others => null;
            end case;
        end if;
    end process;

end Behavioral;
