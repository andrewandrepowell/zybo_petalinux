library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_pmodmic_spi_0_v1_0 is
	generic (
		-- Parameters of Axi Slave Bus Interface S_AXI
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 32
	);
	port (
		-- Ports of Axi Slave Bus Interface S_AXI
		s_axi_aclk	: in std_logic;
		s_axi_aresetn	: in std_logic;
		s_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;
		s_axi_wdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;
		s_axi_bresp	: out std_logic_vector(1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;
		s_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;
		s_axi_rdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp	: out std_logic_vector(1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: in std_logic;
		
		spi_clk : out std_logic;
		spi_cs : out std_logic;
		spi_sdata : in std_logic
	);
end axi_pmodmic_spi_0_v1_0;

architecture arch_imp of axi_pmodmic_spi_0_v1_0 is
    constant SAMPLE_WIDTH : integer := 16;
    constant FIFO_AWIDTH : integer := 3;
    constant REG_TOTAL : integer := 5;
    signal spi_cntrl_0_enable : std_logic;
    signal spi_cntrl_0_ready: std_logic;
    signal spi_sample : std_logic_vector( SAMPLE_WIDTH-1 downto 0 );
    signal generate_spi_clk_0_enable : std_logic;
    signal generated_spi_clk : std_logic;
    signal fifo_adi_0_in_stb : std_logic;
    signal fifo_adi_0_enable : std_logic;
    signal fifo_adi_0_in_data : std_logic_vector( SAMPLE_WIDTH-1 downto 0 );
    signal wr_addr : integer range 0 to REG_TOTAL;
    signal wr_data : std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
    signal wr_stb : std_logic;
    signal rd_addr : integer range 0 to REG_TOTAL;
    signal rd_data : std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
    signal rd_ack : std_logic;
    signal rx_fifo_ack: std_logic;
    signal rx_out_stb: std_logic;
    signal rx_ack : std_logic;
    signal rx_sample : std_logic_vector( SAMPLE_WIDTH-1 downto 0 );
    signal update_fifo_0_enable : std_logic;
    
    signal reg_enable_0 : std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
    signal reg_spi_clk_period_0 : std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
    signal reg_sample_period_0 : std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
    signal reg_fifo_state_0 : std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
    signal reg_sample_0 : std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
    
    component spi_cntrl_0 is
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
    end component spi_cntrl_0;
    
    component fifo_adi_0 is
        generic (
            RAM_ADDR_WIDTH : integer := 3;
            FIFO_DWIDTH : integer := 16
        );
        port (
            clk        : in  std_logic;
            resetn        : in  std_logic;
            fifo_reset    : in  std_logic;
            in_stb        : in  std_logic;
            in_ack        : out std_logic;
            in_data        : in  std_logic_vector(FIFO_DWIDTH-1 downto 0);
            out_stb        : out std_logic;    
            out_ack        : in  std_logic;
            out_data    : out std_logic_vector(FIFO_DWIDTH-1 downto 0)
        );
    end component fifo_adi_0;
    
    component generate_spi_clk_0 is
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
    end component generate_spi_clk_0;
    
    component update_fifo_0 is
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
    end component update_fifo_0;
    
    component axi_ctrlif is
        generic
        (
            C_NUM_REG            : integer            := 32;
            C_S_AXI_DATA_WIDTH    : integer            := 32;
            C_S_AXI_ADDR_WIDTH    : integer            := 32;
            C_FAMILY        : string            := "virtex6"
        );
        port
        (
            -- AXI bus interface
            S_AXI_ACLK        : in  std_logic;
            S_AXI_ARESETN        : in  std_logic;
            S_AXI_AWADDR        : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_AWVALID        : in  std_logic;
            S_AXI_WDATA        : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_WSTRB        : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            S_AXI_WVALID        : in  std_logic;
            S_AXI_BREADY        : in  std_logic;
            S_AXI_ARADDR        : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_ARVALID        : in  std_logic;
            S_AXI_RREADY        : in  std_logic;
            S_AXI_ARREADY        : out std_logic;
            S_AXI_RDATA        : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_RRESP        : out std_logic_vector(1 downto 0);
            S_AXI_RVALID        : out std_logic;
            S_AXI_WREADY        : out std_logic;
            S_AXI_BRESP        : out std_logic_vector(1 downto 0);
            S_AXI_BVALID        : out std_logic;
            S_AXI_AWREADY        : out std_logic;
    
            rd_addr : out integer range 0 to C_NUM_REG - 1;
            rd_data : in  std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
            rd_ack  : out std_logic;
            rd_stb  : in  std_logic;
    
            wr_addr : out integer range 0 to C_NUM_REG - 1;
            wr_data : out std_logic_vector( C_S_AXI_DATA_WIDTH-1 downto 0 );
            wr_ack  : in  std_logic;
            wr_stb  : out std_logic
        );
    end component axi_ctrlif;

begin

    generate_spi_clk_0_enable <= reg_enable_0( 0 );
    fifo_adi_0_enable <= reg_enable_0( 1 );
    update_fifo_0_enable <= reg_enable_0( 2 );
    
    reg_fifo_state_0( 0 ) <= not( rx_out_stb ); -- full
    reg_fifo_state_0( 1 ) <= not( rx_ack ); -- empty
    reg_fifo_state_0( C_S_AXI_DATA_WIDTH-1 downto 2 ) <= ( others => '0' ); 
    

    process( rd_addr )
	begin
		case rd_addr is
			when 0 => rd_data <= reg_enable_0;
			when 1 => rd_data <= reg_spi_clk_period_0;
			when 2 => rd_data <= reg_sample_period_0;
			when 3 => rd_data <= reg_fifo_state_0;
			when 4 => rd_data <= std_logic_vector( to_unsigned( 0 , C_S_AXI_DATA_WIDTH-SAMPLE_WIDTH ) ) & rx_sample;
			when others => rd_data <= (others => '0');
		end case;
	end process;

	process( s_axi_aclk ) is
	begin
		if rising_edge( s_axi_aclk ) then
			if ( s_axi_aresetn = '0' ) then
				reg_enable_0 <= (others => '0');
				reg_spi_clk_period_0 <= (others => '0');
				reg_sample_period_0 <= (others => '0');
			else
				if ( wr_stb = '1' ) then
					case wr_addr is
						when 0 => reg_enable_0 <= wr_data;
						when 1 => reg_spi_clk_period_0 <= wr_data;
						when 2 => reg_sample_period_0 <= wr_data;
						when others => null;
					end case;
				end if;
			end if;
		end if;
	end process;

    axi_ctrlif_inst : axi_ctrlif
        generic map (
            C_NUM_REG => REG_TOTAL,
            C_S_AXI_DATA_WIDTH =>  C_S_AXI_DATA_WIDTH,
            C_S_AXI_ADDR_WIDTH  => C_S_AXI_ADDR_WIDTH
        )
        port map
        (
            S_AXI_ACLK => s_axi_aclk,
            S_AXI_ARESETN => s_axi_aresetn,
            S_AXI_AWADDR => s_axi_awaddr,
            S_AXI_AWVALID => s_axi_awvalid,
            S_AXI_WDATA => s_axi_wdata,
            S_AXI_WSTRB => s_axi_wstrb,
            S_AXI_WVALID => s_axi_wvalid,
            S_AXI_BREADY => s_axi_bready,
            S_AXI_ARADDR => s_axi_araddr,
            S_AXI_ARVALID => s_axi_arvalid,
            S_AXI_RREADY => s_axi_rready,
            S_AXI_ARREADY => s_axi_arready,
            S_AXI_RDATA => s_axi_rdata,
            S_AXI_RRESP => s_axi_rresp,
            S_AXI_RVALID => s_axi_rvalid,
            S_AXI_WREADY => s_axi_wready,
            S_AXI_BRESP => s_axi_bresp,
            S_AXI_BVALID => s_axi_bvalid,
            S_AXI_AWREADY => s_axi_awready,
            rd_addr => rd_addr,
            rd_data => rd_data,
            rd_ack => rd_ack,
            rd_stb => '1',
            wr_addr => wr_addr,
            wr_data => wr_data,
            wr_ack => '1',
            wr_stb => wr_stb
        );

    update_fifo_0_inst : update_fifo_0 
        generic map (
            SAMPLE_WIDTH => SAMPLE_WIDTH,
            C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH
        )
        port map (
            s_axi_aclk => s_axi_aclk,
            s_axi_aresetn => s_axi_aresetn,
            enable => update_fifo_0_enable,
            spi_cntrl_0_enable => spi_cntrl_0_enable,
            spi_cntrl_0_ready => spi_cntrl_0_ready,
            spi_cntrl_0_sample => spi_sample,
            fifo_adi_0_in_stb => fifo_adi_0_in_stb,
            fifo_adi_0_in_data => fifo_adi_0_in_data,
            reg_sample_period_0 => reg_sample_period_0
        );

    rx_fifo_ack <= '1' when rd_addr = 4 and rd_ack = '1' else '0';
    fifo_adi_0_inst : fifo_adi_0 
        generic map (
            RAM_ADDR_WIDTH => FIFO_AWIDTH,
            FIFO_DWIDTH => SAMPLE_WIDTH
        )
        port map (
            clk => s_axi_aclk,
            resetn => s_axi_aresetn,
            fifo_reset => "not"( fifo_adi_0_enable ),
            in_stb => fifo_adi_0_in_stb,
            in_ack => rx_ack,
            in_data => fifo_adi_0_in_data,
            out_stb => rx_out_stb,
            out_ack => rx_fifo_ack,
            out_data => rx_sample
        );
        
    generate_spi_clk_0_inst : generate_spi_clk_0
        generic map (
            C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH
        )
        port map (
            s_axi_aclk => s_axi_aclk,
            s_axi_aresetn => s_axi_aresetn,
            enable => generate_spi_clk_0_enable,
            spi_clk => generated_spi_clk,
            reg_spi_clk_period_0 => reg_spi_clk_period_0
        );

    spi_cntrl_0_inst : spi_cntrl_0 
        generic map (
            SAMPLE_WIDTH => SAMPLE_WIDTH
        )
        port map (
            s_axi_aclk => s_axi_aclk,
            s_axi_aresetn => s_axi_aresetn,
            enable => spi_cntrl_0_enable,
            ready => spi_cntrl_0_ready,
            sample_out => spi_sample, 
            spi_clk_in => generated_spi_clk,
            spi_clk_out => spi_clk,
            spi_cs => spi_cs,
            spi_sdata => spi_sdata
        );
    
end arch_imp;
