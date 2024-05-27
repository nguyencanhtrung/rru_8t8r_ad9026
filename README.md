# Project Name

Reference design of 5G Remote Radio Unit (RRU) which uses ADRV9026 as the TRX module and AMD FPGA XZCU15EG-FFVB1156 

## Table of Contents

- [Requirements](#requirements)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Requirements

* Vivado Design Suite (version 2022.2 and upper)

## Usage

This project is used only to verify pin assignments of the customized hardware. It can be used as a start project for further development.

Please review:

* The setup of M, L in the JESD204 data link layer
* Lane mapping 
* Observation channel is missing in this version

## PS GPIO

The general purpose I/O (GPIO) is a collection of input/output signals available to software
applications. The GPIO consists of the MIO with 78 pins, and the extended multiplexed I/O
interface (EMIO) with 288 signals that are divided into 96 inputs from the programmable
logic (PL) and 192 outputs to the PL. The GPIO is organized into six banks of registers that
group related interface signals.

Key features of the GPIO peripheral are summarized as follows:
* 78 GPIO interfaces to the device pins.
    * Routed through the MIO multiplexer.
    * Programmable I/O drive strength, slew rate, and 3-state control.

* 96 GPIO interfaces to the PL (four allocated by software to reset PL logic).
    * Routed through the EMIO interface.
    * Data inputs.
    * Data outputs.
    * Output enables.

* Up to four outputs for GPIO[92:95] can act as reset signals to user-defined logic in the PL. The GPIO [92:95] channels routed to the EMIO.
    * If `Fabric Reset Enable` and `Number of Fabric Resets = 1`, then GPIO[95] is used
    * `Number of Fabric Resets = 1`, then GPIO[95:94] is used

In the implementation we have to review these 96 GPIOs, the ADI driver will utilize these GPIOs to configure TRX modules. Here is an example.

```
  ad_iobuf #(
    .DATA_WIDTH(37)
    ) i_iobuf (
    .dio_t ({gpio_t[68:51]}),
    .dio_i ({gpio_o[68:51]}),
    .dio_o ({gpio_i[68:51]}),
    .dio_p ({ ad9528_reset_b,       // 68
              ad9528_sysref_req,    // 67
              adrv9026_tx1_enable,  // 66
              adrv9026_tx2_enable,  // 65
              adrv9026_tx3_enable,  // 64
              adrv9026_tx4_enable,  // 63
              adrv9026_rx1_enable,  // 62
              adrv9026_rx2_enable,  // 61
              adrv9026_rx3_enable,  // 60
              adrv9026_rx4_enable,  // 59
              adrv9026_test,        // 58
              adrv9026_reset_b,     // 57
              adrv9026_gpint1,      // 56
              adrv9026_gpint2,      // 55
              adrv9026_orx_ctrl_a,  // 54
              adrv9026_orx_ctrl_b,  // 53
              adrv9026_orx_ctrl_c,  // 52
              adrv9026_orx_ctrl_d})); // 51
```
This setup will connect these `adrv9026_*` and `ad9528_*` signals to EMIO channels (`GPIO[68:51]`) allows PS software control TRX modules directly via this interface.

## Lanes mapping

With the following pin assignments, we have to map lanes of `TX1` and `TX2` by connecting TX ports between JESD204 Link layer and Physical layer approriately.

```
# Pin assignments
# ADRV9026-1                                                                                        ADRV9026                FPGA                    FPGA
set_property -dict {PACKAGE_PIN L31}  [get_ports rx1_data_p[0]]                             ; ## ADRV1_SERDOUTA_P      ADRV_SERDOUTA_1_P       MGTHRXP0_129
set_property -dict {PACKAGE_PIN L32}  [get_ports rx1_data_n[0]]                             ; ## ADRV1_SERDOUTA_N      ADRV_SERDOUTA_1_N       MGTHRXN0_129
set_property -dict {PACKAGE_PIN K33}  [get_ports rx1_data_p[1]]                             ; ## ADRV1_SERDOUTB_P      ADRV_SERDOUTB_1_P       MGTHRXP1_129
set_property -dict {PACKAGE_PIN K34}  [get_ports rx1_data_n[1]]                             ; ## ADRV1_SERDOUTB_N      ADRV_SERDOUTB_1_N       MGTHRXN1_129
set_property -dict {PACKAGE_PIN H33}  [get_ports rx1_data_p[2]]                             ; ## ADRV1_SERDOUTC_P      ADRV_SERDOUTC_1_P       MGTHRXP2_129
set_property -dict {PACKAGE_PIN H34}  [get_ports rx1_data_n[2]]                             ; ## ADRV1_SERDOUTC_N      ADRV_SERDOUTC_1_N       MGTHRXN2_129
set_property -dict {PACKAGE_PIN F33}  [get_ports rx1_data_p[3]]                             ; ## ADRV1_SERDOUTD_P      ADRV_SERDOUTD_1_P       MGTHRXP3_129
set_property -dict {PACKAGE_PIN F34}  [get_ports rx1_data_n[3]]                             ; ## ADRV1_SERDOUTD_N      ADRV_SERDOUTD_1_N       MGTHRXN3_129

set_property -dict {PACKAGE_PIN K29}  [get_ports tx1_data_p[0]]                             ; ## ADRV1_SERDIND_P       ADRV_SERDIND_1_P        MGTHTXP0_129
set_property -dict {PACKAGE_PIN K30}  [get_ports tx1_data_n[0]]                             ; ## ADRV1_SERDIND_N       ADRV_SERDIND_1_N        MGTHTXN0_129
set_property -dict {PACKAGE_PIN J31}  [get_ports tx1_data_p[1]]                             ; ## ADRV1_SERDINC_P       ADRV_SERDINC_1_P        MGTHTXP1_129
set_property -dict {PACKAGE_PIN J32}  [get_ports tx1_data_n[1]]                             ; ## ADRV1_SERDINC_N       ADRV_SERDINC_1_N        MGTHTXN1_129
set_property -dict {PACKAGE_PIN H29}  [get_ports tx1_data_p[2]]                             ; ## ADRV1_SERDINB_P       ADRV_SERDINB_1_P        MGTHTXP2_129
set_property -dict {PACKAGE_PIN H30}  [get_ports tx1_data_n[2]]                             ; ## ADRV1_SERDINB_N       ADRV_SERDINB_1_N        MGTHTXN2_129
set_property -dict {PACKAGE_PIN G31}  [get_ports tx1_data_p[3]]                             ; ## ADRV1_SERDINA_P       ADRV_SERDINA_1_P        MGTHTXP3_129
set_property -dict {PACKAGE_PIN G32}  [get_ports tx1_data_n[3]]                             ; ## ADRV1_SERDINA_N       ADRV_SERDINA_1_N        MGTHTXN3_129

# ADRV9026-2                                                                                        ADRV9026                FPGA                    FPGA
set_property -dict {PACKAGE_PIN E31}  [get_ports rx2_data_p[0]]                             ; ## ADRV2_SERDOUTA_P      ADRV_SERDOUTA_2_P       MGTHRXP0_130
set_property -dict {PACKAGE_PIN E32}  [get_ports rx2_data_n[0]]                             ; ## ADRV2_SERDOUTA_N      ADRV_SERDOUTA_2_N       MGTHRXN0_130
set_property -dict {PACKAGE_PIN D33}  [get_ports rx2_data_p[1]]                             ; ## ADRV2_SERDOUTB_P      ADRV_SERDOUTB_2_P       MGTHRXP1_130
set_property -dict {PACKAGE_PIN D34}  [get_ports rx2_data_n[1]]                             ; ## ADRV2_SERDOUTB_N      ADRV_SERDOUTB_2_N       MGTHRXN1_130
set_property -dict {PACKAGE_PIN C31}  [get_ports rx2_data_p[2]]                             ; ## ADRV2_SERDOUTC_P      ADRV_SERDOUTC_2_P       MGTHRXP2_130
set_property -dict {PACKAGE_PIN C32}  [get_ports rx2_data_n[2]]                             ; ## ADRV2_SERDOUTC_N      ADRV_SERDOUTC_2_N       MGTHRXN2_130
set_property -dict {PACKAGE_PIN B33}  [get_ports rx2_data_p[3]]                             ; ## ADRV2_SERDOUTD_P      ADRV_SERDOUTD_2_P       MGTHRXP3_130
set_property -dict {PACKAGE_PIN B34}  [get_ports rx2_data_n[3]]                             ; ## ADRV2_SERDOUTD_N      ADRV_SERDOUTD_2_N       MGTHRXN3_130

set_property -dict {PACKAGE_PIN F29}  [get_ports tx2_data_p[0]]                             ; ## ADRV2_SERDIND_P       ADRV_SERDIND_2_P        MGTHTXP0_130
set_property -dict {PACKAGE_PIN F30}  [get_ports tx2_data_n[0]]                             ; ## ADRV2_SERDIND_N       ADRV_SERDIND_2_N        MGTHTXN0_130
set_property -dict {PACKAGE_PIN D29}  [get_ports tx2_data_p[1]]                             ; ## ADRV2_SERDINC_P       ADRV_SERDINC_2_P        MGTHTXP1_130
set_property -dict {PACKAGE_PIN D30}  [get_ports tx2_data_n[1]]                             ; ## ADRV2_SERDINC_N       ADRV_SERDINC_2_N        MGTHTXN1_130
set_property -dict {PACKAGE_PIN B29}  [get_ports tx2_data_p[2]]                             ; ## ADRV2_SERDINB_P       ADRV_SERDINB_2_P        MGTHTXP2_130
set_property -dict {PACKAGE_PIN B30}  [get_ports tx2_data_n[2]]                             ; ## ADRV2_SERDINB_N       ADRV_SERDINB_2_N        MGTHTXN2_130
set_property -dict {PACKAGE_PIN A31}  [get_ports tx2_data_p[3]]                             ; ## ADRV2_SERDINA_P       ADRV_SERDINA_2_P        MGTHTXP3_130
set_property -dict {PACKAGE_PIN A32}  [get_ports tx2_data_n[3]]                             ; ## ADRV2_SERDINA_N       ADRV_SERDINA_2_N        MGTHTXN3_130
```

For example: Lanes mapping

```
# ADI JESD204 Transmit      UTIL_ADXCVR
  tx_phy0                     tx_3
  tx_phy1                     tx_2
  tx_phy2                     tx_1
  tx_phy3                     tx_0


# AXI ADXCVR                UTIL_ADXCVR
  up_ch_0                     up_tx_3
  up_ch_1                     up_tx_2
  up_ch_2                     up_tx_1
  up_ch_3                     up_tx_0
```


## Contributing

Guidelines for contributing to the project, including information on how to submit pull requests and report issues.

## License

Information about the project's license.
