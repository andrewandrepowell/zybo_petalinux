----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/02/2016 05:47:20 PM
-- Design Name: 
-- Module Name: ip_cntrl_0 - Behavioral
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

entity update_fifo_0 is
    generic (
        SAMPLE_WIDTH : integer := 16;
        C_S_AXI_DATA_WIDTH : integer := 32
    );
    port (
        s_axi_aclk : in std_logic;
        s_axi_aresetn : in std_logic;
        
        enable : in std_logic;
        
        spi_cntrl_0_enable : out std_logic;
        spi_cntrl_0_ready : in std_logic;
        spi_cntrl_0_sample : in std_logic_vector( SAMPLE_WIDTH-1 downto 0 );
        
        fifo_adi_0_in_stb : out std_logic;
        fifo_adi_0_in_data : out std_logic_vector( SAMPLE_WIDTH-1 downto 0 );
        
        reg_sample_period_0 : in std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 )
    );
end update_fifo_0;

architecture Behavioral of update_fifo_0 is
    signal spi_cntrl_0_enable_buff : std_logic;
    signal sample_start_req : std_logic;
    signal sample_start_ack : std_logic;
    type sample_state_type is ( SAMPLE_STATE_IDLE_0, SAMPLE_STATE_GET_SAMPLE_0, SAMPLE_STATE_BUFFER_SAMPLE_0 );
    signal sample_state : sample_state_type;
    signal sample_0 : std_logic_vector( SAMPLE_WIDTH downto 0 );
    signal fifo_adi_0_in_stb_buff : std_logic;
begin
    
    process ( s_axi_aclk )
        variable counter_0 : integer;
    begin
        if ( rising_edge( s_axi_aclk ) ) then
            if ( s_axi_aresetn = '0' or enable = '0' ) then
                sample_start_req <= '0';
                counter_0 := 0;
            else
                if ( counter_0 = to_integer( unsigned( reg_sample_period_0 ) ) ) then
                    sample_start_req <= not( sample_start_req );
                    counter_0 := 0;
                else
                    counter_0 := counter_0+1;
                end if;
            end if;
        end if;
    end process;
    
    spi_cntrl_0_enable <= spi_cntrl_0_enable_buff;
    fifo_adi_0_in_stb <= fifo_adi_0_in_stb_buff;
    process ( s_axi_aclk )
    begin
        if ( rising_edge( s_axi_aclk ) ) then
            if ( s_axi_aresetn = '0' ) then
                sample_start_ack <= '0';
                spi_cntrl_0_enable_buff <= '0';
                fifo_adi_0_in_data <= ( others => '0' );
                fifo_adi_0_in_stb_buff <= '0';
            else
                case sample_state is
                    when SAMPLE_STATE_IDLE_0 =>
                        if ( sample_start_req /= sample_start_ack ) then
                            sample_start_ack <= not( sample_start_ack );
                            sample_state <= SAMPLE_STATE_GET_SAMPLE_0;
                        end if;
                    when SAMPLE_STATE_GET_SAMPLE_0 =>
                        if ( spi_cntrl_0_enable_buff = '1' and spi_cntrl_0_ready = '1' ) then
                            spi_cntrl_0_enable_buff <= '0';
                            fifo_adi_0_in_data <= spi_cntrl_0_sample;
                            sample_state <= SAMPLE_STATE_BUFFER_SAMPLE_0;
                        else
                            spi_cntrl_0_enable_buff <= '1';
                        end if;
                    when SAMPLE_STATE_BUFFER_SAMPLE_0 =>
                        if ( fifo_adi_0_in_stb_buff = '1' ) then
                            fifo_adi_0_in_stb_buff <= '0';
                            sample_state <= SAMPLE_STATE_IDLE_0;
                        else
                            fifo_adi_0_in_stb_buff <= '1';
                        end if;
                end case;
            end if;
        end if;
    end process;
    
end Behavioral;
