-- (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: analogdeviceinc.com:adi:axi_i2s_adi:1.0
-- IP Revision: 10

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY adi_common_v1_00_a;
USE adi_common_v1_00_a.axi_i2s_adi;

ENTITY block_design_axi_i2s_adi_0_0 IS
  PORT (
    DATA_CLK_I : IN STD_LOGIC;
    BCLK_O : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    LRCLK_O : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    SDATA_O : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    SDATA_I : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    MUTEN_O : OUT STD_LOGIC;
    DMA_REQ_TX_ACLK : IN STD_LOGIC;
    DMA_REQ_TX_RSTN : IN STD_LOGIC;
    DMA_REQ_TX_DAVALID : IN STD_LOGIC;
    DMA_REQ_TX_DATYPE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    DMA_REQ_TX_DAREADY : OUT STD_LOGIC;
    DMA_REQ_TX_DRVALID : OUT STD_LOGIC;
    DMA_REQ_TX_DRTYPE : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    DMA_REQ_TX_DRLAST : OUT STD_LOGIC;
    DMA_REQ_TX_DRREADY : IN STD_LOGIC;
    DMA_REQ_RX_ACLK : IN STD_LOGIC;
    DMA_REQ_RX_RSTN : IN STD_LOGIC;
    DMA_REQ_RX_DAVALID : IN STD_LOGIC;
    DMA_REQ_RX_DATYPE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    DMA_REQ_RX_DAREADY : OUT STD_LOGIC;
    DMA_REQ_RX_DRVALID : OUT STD_LOGIC;
    DMA_REQ_RX_DRTYPE : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    DMA_REQ_RX_DRLAST : OUT STD_LOGIC;
    DMA_REQ_RX_DRREADY : IN STD_LOGIC;
    S_AXI_ACLK : IN STD_LOGIC;
    S_AXI_ARESETN : IN STD_LOGIC;
    S_AXI_AWADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_AWVALID : IN STD_LOGIC;
    S_AXI_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_WVALID : IN STD_LOGIC;
    S_AXI_BREADY : IN STD_LOGIC;
    S_AXI_ARADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_ARVALID : IN STD_LOGIC;
    S_AXI_RREADY : IN STD_LOGIC;
    S_AXI_ARREADY : OUT STD_LOGIC;
    S_AXI_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_RVALID : OUT STD_LOGIC;
    S_AXI_WREADY : INOUT STD_LOGIC;
    S_AXI_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_BVALID : INOUT STD_LOGIC;
    S_AXI_AWREADY : INOUT STD_LOGIC
  );
END block_design_axi_i2s_adi_0_0;

ARCHITECTURE block_design_axi_i2s_adi_0_0_arch OF block_design_axi_i2s_adi_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF block_design_axi_i2s_adi_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT axi_i2s_adi IS
    GENERIC (
      C_SLOT_WIDTH : INTEGER;
      C_LRCLK_POL : INTEGER;
      C_BCLK_POL : INTEGER;
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_DMA_TYPE : INTEGER;
      C_NUM_CH : INTEGER;
      C_HAS_TX : INTEGER;
      C_HAS_RX : INTEGER
    );
    PORT (
      DATA_CLK_I : IN STD_LOGIC;
      BCLK_O : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      LRCLK_O : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      SDATA_O : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      SDATA_I : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      MUTEN_O : OUT STD_LOGIC;
      S_AXIS_ACLK : IN STD_LOGIC;
      S_AXIS_ARESETN : IN STD_LOGIC;
      S_AXIS_TREADY : OUT STD_LOGIC;
      S_AXIS_TDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXIS_TLAST : IN STD_LOGIC;
      S_AXIS_TVALID : IN STD_LOGIC;
      M_AXIS_ACLK : IN STD_LOGIC;
      M_AXIS_TREADY : IN STD_LOGIC;
      M_AXIS_TDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      M_AXIS_TLAST : OUT STD_LOGIC;
      M_AXIS_TVALID : OUT STD_LOGIC;
      M_AXIS_TKEEP : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      DMA_REQ_TX_ACLK : IN STD_LOGIC;
      DMA_REQ_TX_RSTN : IN STD_LOGIC;
      DMA_REQ_TX_DAVALID : IN STD_LOGIC;
      DMA_REQ_TX_DATYPE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      DMA_REQ_TX_DAREADY : OUT STD_LOGIC;
      DMA_REQ_TX_DRVALID : OUT STD_LOGIC;
      DMA_REQ_TX_DRTYPE : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      DMA_REQ_TX_DRLAST : OUT STD_LOGIC;
      DMA_REQ_TX_DRREADY : IN STD_LOGIC;
      DMA_REQ_RX_ACLK : IN STD_LOGIC;
      DMA_REQ_RX_RSTN : IN STD_LOGIC;
      DMA_REQ_RX_DAVALID : IN STD_LOGIC;
      DMA_REQ_RX_DATYPE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      DMA_REQ_RX_DAREADY : OUT STD_LOGIC;
      DMA_REQ_RX_DRVALID : OUT STD_LOGIC;
      DMA_REQ_RX_DRTYPE : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      DMA_REQ_RX_DRLAST : OUT STD_LOGIC;
      DMA_REQ_RX_DRREADY : IN STD_LOGIC;
      S_AXI_ACLK : IN STD_LOGIC;
      S_AXI_ARESETN : IN STD_LOGIC;
      S_AXI_AWADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXI_AWVALID : IN STD_LOGIC;
      S_AXI_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXI_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      S_AXI_WVALID : IN STD_LOGIC;
      S_AXI_BREADY : IN STD_LOGIC;
      S_AXI_ARADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXI_ARVALID : IN STD_LOGIC;
      S_AXI_RREADY : IN STD_LOGIC;
      S_AXI_ARREADY : OUT STD_LOGIC;
      S_AXI_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXI_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      S_AXI_RVALID : OUT STD_LOGIC;
      S_AXI_WREADY : INOUT STD_LOGIC;
      S_AXI_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      S_AXI_BVALID : INOUT STD_LOGIC;
      S_AXI_AWREADY : INOUT STD_LOGIC
    );
  END COMPONENT axi_i2s_adi;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_ACLK: SIGNAL IS "xilinx.com:signal:clock:1.0 DMA_TX_CLK CLK";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_RSTN: SIGNAL IS "xilinx.com:signal:reset:1.0 DMA_TX_RST RST";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_DAVALID: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_TX_ACK TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_DATYPE: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_TX_ACK TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_DAREADY: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_TX_ACK TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_DRVALID: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_TX_REQ TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_DRTYPE: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_TX_REQ TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_DRLAST: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_TX_REQ TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_TX_DRREADY: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_TX_REQ TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_ACLK: SIGNAL IS "xilinx.com:signal:clock:1.0 DMA_RX_CLK CLK";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_RSTN: SIGNAL IS "xilinx.com:signal:reset:1.0 DMA_RX_RST RST";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_DAVALID: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_RX_ACK TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_DATYPE: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_RX_ACK TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_DAREADY: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_RX_ACK TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_DRVALID: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_RX_REQ TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_DRTYPE: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_RX_REQ TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_DRLAST: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_RX_REQ TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF DMA_REQ_RX_DRREADY: SIGNAL IS "xilinx.com:interface:axis:1.0 DMA_RX_REQ TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ACLK: SIGNAL IS "xilinx.com:signal:clock:1.0 S_AXI_CLK CLK";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ARESETN: SIGNAL IS "xilinx.com:signal:reset:1.0 S_AXI_RST RST";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_AWADDR: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_AWVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_WDATA: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_WSTRB: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_WVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_BREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ARADDR: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ARVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_RREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ARREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_RDATA: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_RRESP: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_RVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_WREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_BRESP: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_BVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_AWREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";
BEGIN
  U0 : axi_i2s_adi
    GENERIC MAP (
      C_SLOT_WIDTH => 24,
      C_LRCLK_POL => 0,
      C_BCLK_POL => 0,
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_DMA_TYPE => 1,
      C_NUM_CH => 1,
      C_HAS_TX => 1,
      C_HAS_RX => 1
    )
    PORT MAP (
      DATA_CLK_I => DATA_CLK_I,
      BCLK_O => BCLK_O,
      LRCLK_O => LRCLK_O,
      SDATA_O => SDATA_O,
      SDATA_I => SDATA_I,
      MUTEN_O => MUTEN_O,
      S_AXIS_ACLK => '0',
      S_AXIS_ARESETN => '0',
      S_AXIS_TDATA => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      S_AXIS_TLAST => '0',
      S_AXIS_TVALID => '0',
      M_AXIS_ACLK => '0',
      M_AXIS_TREADY => '0',
      DMA_REQ_TX_ACLK => DMA_REQ_TX_ACLK,
      DMA_REQ_TX_RSTN => DMA_REQ_TX_RSTN,
      DMA_REQ_TX_DAVALID => DMA_REQ_TX_DAVALID,
      DMA_REQ_TX_DATYPE => DMA_REQ_TX_DATYPE,
      DMA_REQ_TX_DAREADY => DMA_REQ_TX_DAREADY,
      DMA_REQ_TX_DRVALID => DMA_REQ_TX_DRVALID,
      DMA_REQ_TX_DRTYPE => DMA_REQ_TX_DRTYPE,
      DMA_REQ_TX_DRLAST => DMA_REQ_TX_DRLAST,
      DMA_REQ_TX_DRREADY => DMA_REQ_TX_DRREADY,
      DMA_REQ_RX_ACLK => DMA_REQ_RX_ACLK,
      DMA_REQ_RX_RSTN => DMA_REQ_RX_RSTN,
      DMA_REQ_RX_DAVALID => DMA_REQ_RX_DAVALID,
      DMA_REQ_RX_DATYPE => DMA_REQ_RX_DATYPE,
      DMA_REQ_RX_DAREADY => DMA_REQ_RX_DAREADY,
      DMA_REQ_RX_DRVALID => DMA_REQ_RX_DRVALID,
      DMA_REQ_RX_DRTYPE => DMA_REQ_RX_DRTYPE,
      DMA_REQ_RX_DRLAST => DMA_REQ_RX_DRLAST,
      DMA_REQ_RX_DRREADY => DMA_REQ_RX_DRREADY,
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_AWREADY => S_AXI_AWREADY
    );
END block_design_axi_i2s_adi_0_0_arch;
