// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module tx_tb;
  parameter VCD_FILE = "tx_tb.vcd";
  parameter NUM_LANES = 4;
  parameter NUM_LINKS = 2;
  parameter OCTETS_PER_FRAME = 4;
  parameter FRAMES_PER_MULTIFRAME = 32;

  `include "tb_base.v"

  reg [NUM_LINKS-1:0] sync = {NUM_LINKS{1'b1}};
  reg [31:0] counter = 'h00;
  reg [31:0] tx_data = 'h00000000;

  wire tx_ready;
  wire tx_valid = 1'b1;
  wire [NUM_LANES-1:0] cfg_lanes_disable;
  wire [NUM_LINKS-1:0] cfg_links_disable;
  wire [9:0] cfg_octets_per_multiframe;
  wire [7:0] cfg_octets_per_frame;
  wire [7:0] device_cfg_lmfc_offset;
  wire [9:0] device_cfg_octets_per_multiframe;
  wire [7:0] device_cfg_octets_per_frame;
  wire [7:0] device_cfg_beats_per_multiframe;
  wire device_cfg_sysref_disable;
  wire device_cfg_sysref_oneshot;
  wire cfg_continuous_cgs;
  wire cfg_continuous_ilas;
  wire cfg_skip_ilas;
  wire [7:0] cfg_mframes_per_ilas;
  wire cfg_disable_char_replacement;
  wire cfg_disable_scrambler;
  wire tx_ilas_config_rd;
  wire [1:0] tx_ilas_config_addr;
  wire [32*NUM_LANES-1:0] tx_ilas_config_data;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      tx_data <= 'h00000000;
    end else if (tx_ready == 1'b1) begin
      tx_data <= tx_data + 1'b1;
    end
  end

  /* Generate independent SYNCs
  *
  *  Each SYNC will be asserted/deasserted at different clock edges.
  *  The assertion/deassertion order: first SYNC[0], ..., last SYNC[NUM_LINKS-1]
  */
  always @(posedge clk) begin
    counter <= counter + 1'b1;
  end

  genvar i;
  generate
    for (i=1; i<=NUM_LINKS; i=i+1) begin: SYNC_GENERATOR
      always @(posedge clk) begin
        if (counter >= (32'h100 | (i << 4)) && counter <= (32'h300 | (i << 4))) begin
          sync[i-1] <= 1'b0;
        end else begin
          sync[i-1] <= 1'b1;
        end
      end
    end
  endgenerate

  // DUT with static configuration

  jesd204_tx_static_config #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .OCTETS_PER_FRAME(OCTETS_PER_FRAME),
    .FRAMES_PER_MULTIFRAME(FRAMES_PER_MULTIFRAME)
  ) i_cfg (
    .clk(clk),

    .cfg_lanes_disable(cfg_lanes_disable),
    .cfg_links_disable(cfg_links_disable),
    .cfg_octets_per_multiframe(cfg_octets_per_multiframe),
    .cfg_octets_per_frame(cfg_octets_per_frame),
    .cfg_continuous_cgs(cfg_continuous_cgs),
    .cfg_continuous_ilas(cfg_continuous_ilas),
    .cfg_skip_ilas(cfg_skip_ilas),
    .cfg_mframes_per_ilas(cfg_mframes_per_ilas),
    .cfg_disable_char_replacement(cfg_disable_char_replacement),
    .cfg_disable_scrambler(cfg_disable_scrambler),

    .device_cfg_octets_per_multiframe(device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame(device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe(device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset(device_cfg_lmfc_offset),
    .device_cfg_sysref_disable(device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot(device_cfg_sysref_oneshot),

    .ilas_config_rd(tx_ilas_config_rd),
    .ilas_config_addr(tx_ilas_config_addr),
    .ilas_config_data(tx_ilas_config_data));

  jesd204_tx #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS),
    .ASYNC_CLK(0)
  ) i_tx (
    .clk(clk),
    .reset(reset),

    .device_clk(clk),
    .device_reset(reset),

    .phy_data(),
    .phy_charisk(),
    .phy_header(),

    .sysref(sysref),
    .lmfc_edge(),
    .lmfc_clk(),

    .sync(sync),

    .tx_data({NUM_LANES{tx_data}}),
    .tx_ready(tx_ready),
    .tx_eof(),
    .tx_sof(),
    .tx_somf(),
    .tx_eomf(),
    .tx_valid(1'b1),

    .cfg_lanes_disable(cfg_lanes_disable),
    .cfg_links_disable(cfg_links_disable),
    .cfg_octets_per_multiframe(cfg_octets_per_multiframe),
    .cfg_octets_per_frame(cfg_octets_per_frame),
    .cfg_continuous_cgs(cfg_continuous_cgs),
    .cfg_continuous_ilas(cfg_continuous_ilas),
    .cfg_skip_ilas(cfg_skip_ilas),
    .cfg_mframes_per_ilas(cfg_mframes_per_ilas),
    .cfg_disable_char_replacement(cfg_disable_char_replacement),
    .cfg_disable_scrambler(cfg_disable_scrambler),

    .device_cfg_octets_per_multiframe(device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame(device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe(device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset(device_cfg_lmfc_offset),
    .device_cfg_sysref_disable(device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot(device_cfg_sysref_oneshot),

    .ilas_config_rd(tx_ilas_config_rd),
    .ilas_config_addr(tx_ilas_config_addr),
    .ilas_config_data(tx_ilas_config_data),

    .ctrl_manual_sync_request (1'b0),

    .device_event_sysref_edge (),
    .device_event_sysref_alignment_error (),

    .status_sync (),
    .status_state (),

    .status_synth_params0(),
    .status_synth_params1(),
    .status_synth_params2());

endmodule
