//-----------------------------------------------------------------------------
// 
// Project   : 5G RRU 8T8R
// Filename  : system_top
// 
// Author    : Nguyen Canh Trung
// Email     : nguyencanhtrung 'at' me 'dot' com
// Date      : 2024-05-15 15:16:46
// Last Modified : 2024-05-17 18:16:06
// Modified By   : Nguyen Canh Trung
// 
// Description: 
// 
// HISTORY:
// Date      	By	Comments
// ----------	---	---------------------------------------------------------
// 2024-05-17	NCT	Change .dac_fifo_bypass(gpio_o[69]) to .dac_fifo_bypass(gpio_o[70])
// 2024-05-16	NCT	File created!
//-----------------------------------------------------------------------------
`timescale 1ns / 100ps

module system_top (
    input                   ref_clk_p,
    input                   ref_clk_n,
    input                   ref_clk2_p,         // Will not use
    input                   ref_clk2_n,         // Will not use
    input                   core_clk_p,
    input                   core_clk_n,
    input                   core_clk2_p,        // Will not use
    input                   core_clk2_n,        // Will not use
  
    input       [3:0]       rx1_data_p,
    input       [3:0]       rx1_data_n,
    output      [3:0]       tx1_data_p,
    output      [3:0]       tx1_data_n,
    input       [3:0]       rx2_data_p,
    input       [3:0]       rx2_data_n,
    output      [3:0]       tx2_data_p,
    output      [3:0]       tx2_data_n,

    output                  rx1_sync_p,
    output                  rx1_sync_n,
    output                  rx1_os_sync_p,
    output                  rx1_os_sync_n,
    input                   tx1_sync_p,
    input                   tx1_sync_n,
    input                   tx1_sync_1_p,       // Will not use
    input                   tx1_sync_1_n,       // Will not use

    output                  rx2_sync_p,
    output                  rx2_sync_n,
    output                  rx2_os_sync_p,
    output                  rx2_os_sync_n,
    input                   tx2_sync_p,
    input                   tx2_sync_n,
    input                   tx2_sync_1_p,       // Will not use
    input                   tx2_sync_1_n,       // Will not use

    input                   sysref_p,
    input                   sysref_n,

    output                  spi2_csn_hmc7044,
    output                  spi2_csn_adrv1,
    output                  spi2_csn_adrv2,
    output                  spi2_clk,
    output                  spi2_mosi,
    input                   spi2_miso,

    inout                   hmc7044_reset,
    inout                   hmc7044_gpio3,
    inout                   hmc7044_sync,
    
    inout                   adrv1_tx1_enable,
    inout                   adrv1_tx2_enable,
    inout                   adrv1_tx3_enable,
    inout                   adrv1_tx4_enable,
    inout                   adrv1_rx1_enable,
    inout                   adrv1_rx2_enable,
    inout                   adrv1_rx3_enable,
    inout                   adrv1_rx4_enable,
    inout                   adrv1_test,
    inout                   adrv1_reset_b,
    inout                   adrv1_gpint1,
    inout                   adrv1_gpint2,
    inout                   adrv1_orx_ctrl_a,
    inout                   adrv1_orx_ctrl_b,
    inout                   adrv1_orx_ctrl_c,
    inout                   adrv1_orx_ctrl_d,

    inout                   adrv1_gpio_00,
    inout                   adrv1_gpio_01,
    inout                   adrv1_gpio_02,
    inout                   adrv1_gpio_03,
    inout                   adrv1_gpio_04,
    inout                   adrv1_gpio_05,
    inout                   adrv1_gpio_06,
    inout                   adrv1_gpio_07,

    inout                   adrv2_tx1_enable,
    inout                   adrv2_tx2_enable,
    inout                   adrv2_tx3_enable,
    inout                   adrv2_tx4_enable,
    inout                   adrv2_rx1_enable,
    inout                   adrv2_rx2_enable,
    inout                   adrv2_rx3_enable,
    inout                   adrv2_rx4_enable,
    inout                   adrv2_test,
    inout                   adrv2_reset_b,
    inout                   adrv2_gpint1,
    inout                   adrv2_gpint2,
    inout                   adrv2_orx_ctrl_a,
    inout                   adrv2_orx_ctrl_b,
    inout                   adrv2_orx_ctrl_c,
    inout                   adrv2_orx_ctrl_d,

    inout                   adrv2_gpio_00,
    inout                   adrv2_gpio_01,
    inout                   adrv2_gpio_02,
    inout                   adrv2_gpio_03,
    inout                   adrv2_gpio_04,
    inout                   adrv2_gpio_05,
    inout                   adrv2_gpio_06,
    inout                   adrv2_gpio_07

    // sfp interface
//    input                   sfp_refclk_p,
//    input                   sfp_refclk_n,
//    output                  sfp_tx_p,
//    output                  sfp_tx_n,
//    input                   sfp_rx_p,
//    input                   sfp_rx_n,
//    output                  sfp_tx_disable,
//    input                   sfp_rx_los,
//    input                   sfp_mod_abs,
//    input                   sfp_tx_fault
);

  // internal signals
  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;

  wire        [ 2:0]      spi2_csn;
  wire ref_clk;
  wire rx1_sync;
  wire rx2_sync;
  wire rx1_os_sync;
  wire rx2_os_sync;
  
  wire tx1_sync;
  wire tx1_sync_1;
  wire tx2_sync;
  wire tx2_sync_1;
  wire sysref;
  
  wire sfp_refclk;

  assign gpio_i[94:70] = gpio_o[94:70];
  assign gpio_i[18: 0] = gpio_o[18: 0];
  
  
//  assign sfp_tx_disable = 1'b1;     // Active low
  assign rx1_os_sync = 1'b0;        // Why?
  assign rx2_os_sync = 1'b0;        // Why?

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (ref_clk_p),
    .IB (ref_clk_n),
    .O (ref_clk),
    .ODIV2 ());
    
//  IBUFDS_GTE4 i_ibufds_sfp_ref_clk (
//    .CEB (1'd0),
//    .I (sfp_refclk_p),
//    .IB (sfp_refclk_n),
//    .O (sfp_refclk),
//    .ODIV2 ());

  IBUFDS i_core_clk_ibufds_1 (
    .I (core_clk_p),
    .IB (core_clk_n),
    .O (core_clk_in));

  BUFG i_core_clk_bufg (
    .I (core_clk_in),
    .O (core_clk));

  OBUFDS i_obufds_rx1_sync (
    .I (~rx1_sync),
    .O (rx1_sync_p),
    .OB (rx1_sync_n));

  OBUFDS i_obufds_rx2_sync (
      .I (~rx2_sync),
      .O (rx2_sync_p),
      .OB(rx2_sync_n)
  );
  
  OBUFDS i_obufds_rx1_os_sync (
    .I (rx1_os_sync),
    .O (rx1_os_sync_p),
    .OB (rx1_os_sync_n));

  OBUFDS i_obufds_rx2_os_sync (
      .I (rx2_os_sync),
      .O (rx2_os_sync_p),
      .OB(rx2_os_sync_n)
  );

  IBUFDS i_ibufds_tx1_sync (
    .I (tx1_sync_p),
    .IB (tx1_sync_n),
    .O (tx1_sync));
  IBUFDS i_ibufds_tx1_sync_1 (
    .I (tx1_sync_1_p),
    .IB (tx1_sync_1_n),
    .O (tx1_sync_1));

  IBUFDS i_ibufds_tx2_sync (
      .I (tx2_sync_p),
      .IB(tx2_sync_n),
      .O (tx2_sync)
  );
  IBUFDS i_ibufds_tx2_sync_1 (
      .I (tx2_sync_1_p),
      .IB(tx2_sync_1_n),
      .O (tx2_sync_1)
  );

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  ad_iobuf #(
    .DATA_WIDTH(51)
    ) i_iobuf (
    .dio_t ({gpio_t[69:19]}),
    .dio_i ({gpio_o[69:19]}),
    .dio_o ({gpio_i[69:19]}),
    .dio_p ({   hmc7044_sync,      // 69
                hmc7044_reset,     // 68
                hmc7044_gpio3,     // 67
                adrv1_tx1_enable,  // 66
                adrv1_tx2_enable,  // 65
                adrv1_tx3_enable,  // 64
                adrv1_tx4_enable,  // 63
                adrv1_rx1_enable,  // 62
                adrv1_rx2_enable,  // 61
                adrv1_rx3_enable,  // 60
                adrv1_rx4_enable,  // 59
                adrv1_test,        // 58
                adrv1_reset_b,     // 57
                adrv1_gpint1,      // 56
                adrv1_gpint2,      // 55
                adrv1_orx_ctrl_a,  // 54
                adrv1_orx_ctrl_b,  // 53
                adrv1_orx_ctrl_c,  // 52
                adrv1_orx_ctrl_d,  // 51
                adrv1_gpio_00,     // 50
                adrv1_gpio_01,     // 49
                adrv1_gpio_02,     // 48
                adrv1_gpio_03,     // 47
                adrv1_gpio_04,     // 46
                adrv1_gpio_05,     // 45
                adrv1_gpio_06,     // 44
                adrv1_gpio_07,     // 43
                adrv2_tx1_enable,  // 42
                adrv2_tx2_enable,  // 41 
                adrv2_tx3_enable,  // 40 
                adrv2_tx4_enable,  // 39
                adrv2_rx1_enable,  // 38
                adrv2_rx2_enable,  // 37
                adrv2_rx3_enable,  // 36
                adrv2_rx4_enable,  // 35
                adrv2_test,        // 34
                adrv2_reset_b,     // 33
                adrv2_gpint1,      // 32 
                adrv2_gpint2,      // 31
                adrv2_orx_ctrl_a,  // 30
                adrv2_orx_ctrl_b,  // 29 
                adrv2_orx_ctrl_c,  // 28 
                adrv2_orx_ctrl_d,  // 27 
                adrv2_gpio_00,     // 26 
                adrv2_gpio_01,     // 25 
                adrv2_gpio_02,     // 24 
                adrv2_gpio_03,     // 23 
                adrv2_gpio_04,     // 22 
                adrv2_gpio_05,     // 21 
                adrv2_gpio_06,     // 20 
                adrv2_gpio_07}));  // 19


  assign spi2_csn_hmc7044   =  spi2_csn[0];
  assign spi2_csn_adrv1     =  spi2_csn[1];
  assign spi2_csn_adrv2     =  spi2_csn[2];

  system_wrapper i_system_wrapper (
    .dac_fifo_bypass(gpio_o[70]),
    .gpio_i         (gpio_i),
    .gpio_o         (gpio_o),
    .gpio_t         (gpio_t),
    .core_clk       (core_clk),
    
    .rx_data_0_n    (rx1_data_n[0]),
    .rx_data_0_p    (rx1_data_p[0]),
    .rx_data_1_n    (rx1_data_n[1]),
    .rx_data_1_p    (rx1_data_p[1]),
    .rx_data_2_n    (rx1_data_n[2]),
    .rx_data_2_p    (rx1_data_p[2]),
    .rx_data_3_n    (rx1_data_n[3]),
    .rx_data_3_p    (rx1_data_p[3]),

    .rx_data_4_n    (rx2_data_n[0]),
    .rx_data_4_p    (rx2_data_p[0]),
    .rx_data_5_n    (rx2_data_n[1]),
    .rx_data_5_p    (rx2_data_p[1]),
    .rx_data_6_n    (rx2_data_n[2]),
    .rx_data_6_p    (rx2_data_p[2]),
    .rx_data_7_n    (rx2_data_n[3]),
    .rx_data_7_p    (rx2_data_p[3]),
    
    .rx_ref_clk_0   (ref_clk),
    .rx_sync_0      (rx1_sync),
    .rx_sync_1      (rx2_sync),
    .rx_sysref_0    (sysref),
    
    .tx_data_0_n    (tx1_data_n[0]),
    .tx_data_0_p    (tx1_data_p[0]),
    .tx_data_1_n    (tx1_data_n[1]),
    .tx_data_1_p    (tx1_data_p[1]),
    .tx_data_2_n    (tx1_data_n[2]),
    .tx_data_2_p    (tx1_data_p[2]),
    .tx_data_3_n    (tx1_data_n[3]),
    .tx_data_3_p    (tx1_data_p[3]),

    .tx_data_4_n    (tx2_data_n[0]),
    .tx_data_4_p    (tx2_data_p[0]),
    .tx_data_5_n    (tx2_data_n[1]),
    .tx_data_5_p    (tx2_data_p[1]),
    .tx_data_6_n    (tx2_data_n[2]),
    .tx_data_6_p    (tx2_data_p[2]),
    .tx_data_7_n    (tx2_data_n[3]),
    .tx_data_7_p    (tx2_data_p[3]),

    .tx_ref_clk_0   (ref_clk),
    .tx_sync_0      (tx1_sync),
    .tx_sync_1      (tx2_sync),
    .tx_sysref_0    (sysref),

    .spi0_sclk      (spi2_clk),
    .spi0_csn       (spi2_csn),
    .spi0_miso      (spi2_miso),
    .spi0_mosi      (spi2_mosi),
    .spi1_sclk      (),
    .spi1_csn       (),
    .spi1_miso      (1'b0),
    .spi1_mosi      ()
    );

endmodule
