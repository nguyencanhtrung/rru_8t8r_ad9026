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


## Contributing

Guidelines for contributing to the project, including information on how to submit pull requests and report issues.

## License

Information about the project's license.
