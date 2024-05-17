# ----------------------------------------------------------------------------
# 
# Project   : 5G RRU 8T8R
# Filename  : system_constr
# 
# Author    : Nguyen Canh Trung
# Email     : nguyencanhtrung 'at' me 'dot' com
# Date      : 2024-05-15 15:16:46
# Last Modified : 2024-05-16 00:50:14
# Modified By   : Nguyen Canh Trung
# 
# Description: 
#   FPGA constraints file for a customized hardware platform
#   XCZU15EG-2FFVB1156I
#
# HISTORY:
# Date      	By	Comments
# ----------	---	---------------------------------------------------------
# 2024-05-16	NCT	File created
# ----------------------------------------------------------------------------
# clocks
create_clock -name ref_clk      -period  4.00 [get_ports ref_clk_p]                         ; ## 250 MHz
create_clock -name ref_clk2     -period  4.00 [get_ports ref_clk2_p]                        ; ## 250 MHz
create_clock -name core_clk     -period  4.00 [get_ports core_clk_p]                        ; ## 250 MHz
create_clock -name core_clk2    -period  4.00 [get_ports core_clk2_p]                       ; ## 250 MHz

#create_clock -name sfp_refclk  -period  4.00 [get_ports sfp_refclk_p]                      ; ## 250 MHz?

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]              ;
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]              ;

###############################
# Clocking HMC7044
# BANK 129 - GTH                                                                                HMC7044                     FPGA                    FPGA
set_property -dict {PACKAGE_PIN L27}                 [get_ports ref_clk_p]                  ; ## CLKOUT0                FPGA_REFCLK1_P          MGTREFCLK0P_129
set_property -dict {PACKAGE_PIN L28}                 [get_ports ref_clk_n]                  ; ##                        FPGA_REFCLK1_N          MGTREFCLK0N_129

# BANK 130 - GTH
set_property -dict {PACKAGE_PIN G27}                 [get_ports ref_clk2_p]                 ; ## SCLKOUT11              FPGA_REFCLK2_P          MGTREFCLK0P_130
set_property -dict {PACKAGE_PIN G28}                 [get_ports ref_clk2_n]                 ; ##                        FPGA_REFCLK2_N          MGTREFCLK0N_130

# BANK 67
set_property -dict {PACKAGE_PIN P11 IOSTANDARD LVDS} [get_ports core_clk_p]                 ; ## SCLKOUT1               FPGA_CORECLK1_P         IO_L13P_T2L_N0_GC_QBC_67
set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVDS} [get_ports core_clk_n]                 ; ##                        FPGA_CORECLK1_N         IO_L13N_T2L_N1_GC_QBC_67
set_property -dict {PACKAGE_PIN T8  IOSTANDARD LVDS} [get_ports core_clk2_p]                ; ## SCLKOUT3               FPGA_CORECLK2_P         IO_L12P_T1U_N10_GC_67
set_property -dict {PACKAGE_PIN R8  IOSTANDARD LVDS} [get_ports core_clk2_n]                ; ##                        FPGA_CORECLK2_N         IO_L12N_T1U_N11_GC_67
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports sysref_p]    ; ## CLKOUT2                FPGA_SYSREF_P           IO_L11P_T1U_N8_GC_67
set_property -dict {PACKAGE_PIN R9  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports sysref_n]    ; ##                        FPGA_SYSREF_N           IO_L11N_T1U_N9_GC_67

###############################
# SERDES
#   Not matching between rx[*] or tx[*] and the actual SERDES lanes yet
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

###############################
# ADRVx_SYNC 
# Direction: from RX to TX
# ADRV1
# SYNCIN1: RX (N12 - N13)
# SYNCIN2: ORX (P7 - P8)
# SYNCIN3: Reserved
#
# SYNCOUT1: tx_sync
# SYNCOUT2: tx_sync_1
set_property -dict {PACKAGE_PIN U9  IOSTANDARD LVDS} [get_ports rx1_sync_p]                     ; ## N12            ADRV_SYNCIN1_1_P    IO_L9P_T1L_N4_AD12P_67
set_property -dict {PACKAGE_PIN U8  IOSTANDARD LVDS} [get_ports rx1_sync_n]                     ; ## N13            ADRV_SYNCIN1_1_N    IO_L9P_T1L_N4_AD12N_67
set_property -dict {PACKAGE_PIN V8  IOSTANDARD LVDS} [get_ports rx1_os_sync_p]                  ; ## P7             ADRV_SYNCIN2_1_P    IO_L7P_T1L_N0_QBC_AD13P_67
set_property -dict {PACKAGE_PIN V7  IOSTANDARD LVDS} [get_ports rx1_os_sync_n]                  ; ## P8             ADRV_SYNCIN2_1_N    IO_L7P_T1L_N0_QBC_AD13N_67

set_property -dict {PACKAGE_PIN M11  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx1_sync_p]     ; ## P15            ADRV_SYNCOUT1_1_P   IO_L17P_T2U_N8_AD10P_67
set_property -dict {PACKAGE_PIN L11  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx1_sync_n]     ; ## R15            ADRV_SYNCOUT1_1_N   IO_L17P_T2U_N8_AD10N_67
set_property -dict {PACKAGE_PIN N9   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx1_sync_1_p]   ; ## N14            ADRV_SYNCOUT2_1_P   IO_L16P_T2U_N6_QBC_AD3P_67
set_property -dict {PACKAGE_PIN N8   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx1_sync_1_n]   ; ## N15            ADRV_SYNCOUT2_1_N   IO_L16P_T2U_N6_QBC_AD3N_67

# ADRV2
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVDS} [get_ports rx2_sync_p]                    ; ## N12            ADRV_SYNCIN1_2_P    IO_L6P_T0U_N10_AD6P_66
set_property -dict {PACKAGE_PIN Y9  IOSTANDARD LVDS}  [get_ports rx2_sync_n]                    ; ## N13            ADRV_SYNCIN1_2_N    IO_L6N_T0U_N11_AD6N_66
set_property -dict {PACKAGE_PIN AB8  IOSTANDARD LVDS} [get_ports rx2_os_sync_p]                 ; ## P7             ADRV_SYNCIN2_2_P    IO_L8P_T1L_N2_AD5P_66
set_property -dict {PACKAGE_PIN AC8  IOSTANDARD LVDS} [get_ports rx2_os_sync_n]                 ; ## P8             ADRV_SYNCIN2_2_N    IO_L8N_T1L_N3_AD5N_66

set_property -dict {PACKAGE_PIN W5  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx2_sync_p]      ; ## P15            ADRV_SYNCOUT1_2_P   IO_L15P_T2L_N4_AD11P_66
set_property -dict {PACKAGE_PIN W4  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx2_sync_n]      ; ## R15            ADRV_SYNCOUT1_2_N   IO_L15P_T2L_N4_AD11N_66
set_property -dict {PACKAGE_PIN Y5  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx2_sync_1_p]    ; ## N14            ADRV_SYNCOUT2_2_P   IO_L14P_T2L_N2_GC_66        (not differential pair)      
set_property -dict {PACKAGE_PIN AA5 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx2_sync_1_n]    ; ## N15            ADRV_SYNCOUT2_2_N   IO_L14N_T2L_N3_GC_66        (not differential pair)

###############################
# HMC CTRL
# SPI2
set_property -dict {PACKAGE_PIN AA10  IOSTANDARD LVCMOS18} [get_ports spi2_clk]                 ; ## SPI2_CLK                           IO_L3N_T0L_N5_AD15N_66
set_property -dict {PACKAGE_PIN AB11  IOSTANDARD LVCMOS18} [get_ports spi2_miso]                ; ## SPI2_MISO                          IO_L2P_T0L_N2_66
set_property -dict {PACKAGE_PIN AB10  IOSTANDARD LVCMOS18} [get_ports spi2_mosi]                ; ## SPI2_MOSI                          IO_L2N_T0L_N3_66
set_property -dict {PACKAGE_PIN W9    IOSTANDARD LVCMOS18} [get_ports spi2_csn_hmc7044]         ; ## SPI2_HMC7044_CS                    IO_T0U_N12_VRP_66
set_property -dict {PACKAGE_PIN M15   IOSTANDARD LVCMOS18} [get_ports spi2_csn_adrv1]           ; ## SPI ENABLE       ADRV_SPI_ENb_1    IO_L20P_T3L_N2_AD1P_67
set_property -dict {PACKAGE_PIN AA3   IOSTANDARD LVCMOS18} [get_ports spi2_csn_adrv2]           ; ## SPI_EN           ADRV_SPI_ENb_2    IO_T2U_N12_66

# HMC7044_CONFIG
set_property -dict {PACKAGE_PIN Y8    IOSTANDARD LVCMOS18} [get_ports hmc7044_gpio3]            ; ## HMC7044_GPIO3                      IO_L11P_T1U_N8_GC_66
set_property -dict {PACKAGE_PIN AA11  IOSTANDARD LVCMOS18} [get_ports hmc7044_sync]             ; ## HMC7044_SYNC                       IO_L3P_T0L_N4_AD15P_66    
set_property -dict {PACKAGE_PIN AC12  IOSTANDARD LVCMOS18} [get_ports hmc7044_reset]            ; ## HMC7044_RESET                      IO_L1P_T0L_N0_DBC_66      -- ad9528 resetb?

###############################
# ADRVx_CTRL
# ADRV1                                                                                             ADRV9026                FPGA             FPGA
set_property -dict {PACKAGE_PIN W10  IOSTANDARD LVCMOS18}   [get_ports adrv1_orx_ctrl_a]        ; ## ORX_CTRL_A     ADRV_ORX_CTRL_A_1   IO_T0U_N12_VRP_67
set_property -dict {PACKAGE_PIN N13  IOSTANDARD LVCMOS18}   [get_ports adrv1_orx_ctrl_b]        ; ## ORX_CTRL_B     ADRV_ORX_CTRL_B_1   IO_L22P_T3U_N6_DBC_AD0P_67
set_property -dict {PACKAGE_PIN K10  IOSTANDARD LVCMOS18}   [get_ports adrv1_orx_ctrl_c]        ; ## ORX_CTRL_C     ADRV_ORX_CTRL_C_1   IO_T2U_N12_67
set_property -dict {PACKAGE_PIN R13  IOSTANDARD LVCMOS18}   [get_ports adrv1_orx_ctrl_d]        ; ## ORX_CTRL_D     ADRV_ORX_CTRL_D_1   IO_L2N_T0L_N3_67
set_property -dict {PACKAGE_PIN V9   IOSTANDARD LVCMOS18}   [get_ports adrv1_rx1_enable]        ; ## RX1_EN         ADRV_RX1_EN_1       IO_T1U_N12_67
set_property -dict {PACKAGE_PIN W12  IOSTANDARD LVCMOS18}   [get_ports adrv1_rx2_enable]        ; ## RX2_EN         ADRV_RX2_EN_1       IO_L1P_T0L_N0_DBC_67
set_property -dict {PACKAGE_PIN L12  IOSTANDARD LVCMOS18}   [get_ports adrv1_rx3_enable]        ; ## RX3_EN         ADRV_RX3_EN_1       IO_L18P_T2U_N10_AD2P_67
set_property -dict {PACKAGE_PIN N12  IOSTANDARD LVCMOS18}   [get_ports adrv1_rx4_enable]        ; ## RX4_EN         ADRV_RX4_EN_1       IO_L21N_T3L_N5_AD8N_67
set_property -dict {PACKAGE_PIN R12  IOSTANDARD LVCMOS18}   [get_ports adrv1_tx1_enable]        ; ## TX1_EN         ADRV_TX1_EN_1       IO_L4N_T0U_N7_DBC_AD7N_67
set_property -dict {PACKAGE_PIN K14  IOSTANDARD LVCMOS18}   [get_ports adrv1_tx2_enable]        ; ## TX2_EN         ADRV_TX2_EN_1       IO_T3U_N12_67
set_property -dict {PACKAGE_PIN P12  IOSTANDARD LVCMOS18}   [get_ports adrv1_tx3_enable]        ; ## TX3_EN         ADRV_TX3_EN_1       IO_L21P_T3L_N4_AD8P_67
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18}   [get_ports adrv1_tx4_enable]        ; ## TX4_EN         ADRV_TX4_EN_1       IO_L23P_T3U_N8_67
set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS18}   [get_ports adrv1_gpint1]            ; ## GPINT1         ADRV_GPINT1_1       IO_L23N_T3U_N9_67
set_property -dict {PACKAGE_PIN T10  IOSTANDARD LVCMOS18}   [get_ports adrv1_gpint2]            ; ## GPINT2         ADRV_GPINT2_1       IO_L2P_T0L_N2_67
set_property -dict {PACKAGE_PIN U10  IOSTANDARD LVCMOS18}   [get_ports adrv1_test]              ; ## TEST           ADRV_TEST_1         IO_L3P_T0L_N4_AD15P_67
set_property -dict {PACKAGE_PIN T12  IOSTANDARD LVCMOS18}   [get_ports adrv1_reset_b]           ; ## RESET          ADRV_RESET_1        IO_L4P_T0U_N6_DBC_AD7P_67

# ADRV2
set_property -dict {PACKAGE_PIN W7   IOSTANDARD LVCMOS18}   [get_ports adrv2_orx_ctrl_a]        ; ## ORX_CTRL_A     ADRV_ORX_CTRL_A_2   IO_L9P_T1L_N4_AD12P_66
set_property -dict {PACKAGE_PIN W1   IOSTANDARD LVCMOS18}   [get_ports adrv2_orx_ctrl_b]        ; ## ORX_CTRL_B     ADRV_ORX_CTRL_B_2   IO_L24N_T3U_N11_66
set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS18}   [get_ports adrv2_orx_ctrl_c]        ; ## ORX_CTRL_C     ADRV_ORX_CTRL_C_2   IO_L19N_T3L_N1_DBC_AD9N_66
set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVCMOS18}   [get_ports adrv2_orx_ctrl_d]        ; ## ORX_CTRL_D     ADRV_ORX_CTRL_D_2   IO_L20N_T3L_N3_AD1N_66
set_property -dict {PACKAGE_PIN AA6  IOSTANDARD LVCMOS18}   [get_ports adrv2_rx1_enable]        ; ## RX1_EN         ADRV_RX1_EN_2       IO_L12N_T1U_N11_GC_66
set_property -dict {PACKAGE_PIN AA7  IOSTANDARD LVCMOS18}   [get_ports adrv2_rx2_enable]        ; ## RX2_EN         ADRV_RX2_EN_2       IO_L12N_T1U_N11_GC_66
set_property -dict {PACKAGE_PIN AB1  IOSTANDARD LVCMOS18}   [get_ports adrv2_rx3_enable]        ; ## RX3_EN         ADRV_RX3_EN_2       IO_T3U_N12_66
set_property -dict {PACKAGE_PIN AC4  IOSTANDARD LVCMOS18}   [get_ports adrv2_rx4_enable]        ; ## RX4_EN         ADRV_RX4_EN_2       IO_L16N_T2U_N7_QBC_AD3N_66
set_property -dict {PACKAGE_PIN U5   IOSTANDARD LVCMOS18}   [get_ports adrv2_tx1_enable]        ; ## TX1_EN         ADRV_TX1_EN_2       IO_L18P_T2U_N10_AD2P_66
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVCMOS18}   [get_ports adrv2_tx2_enable]        ; ## TX2_EN         ADRV_TX2_EN_2       IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS18}   [get_ports adrv2_tx3_enable]        ; ## TX3_EN         ADRV_TX3_EN_2       IO_L19P_T3L_N0_DBC_AD9P_66
set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVCMOS18}   [get_ports adrv2_tx4_enable]        ; ## TX4_EN         ADRV_TX4_EN_2       IO_L16P_T2U_N6_QBC_AD3P_66
set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVCMOS18}   [get_ports adrv2_gpint1]            ; ## GPINT1         ADRV_GPINT1_2       IO_L20P_T3L_N2_AD1P_66
set_property -dict {PACKAGE_PIN AB5  IOSTANDARD LVCMOS18}   [get_ports adrv2_gpint2]            ; ## GPINT2         ADRV_GPINT2_2       IO_L10N_T1U_N7_QBC_AD4N_66
set_property -dict {PACKAGE_PIN AB6  IOSTANDARD LVCMOS18}   [get_ports adrv2_test]              ; ## TEST           ADRV_TEST_2         IO_L10P_T1U_N6_QBC_AD4P_66
set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS18}   [get_ports adrv2_reset_b]           ; ## RESET          ADRV_RESET_2        IO_T1U_N12_66

###############################
# ADRVx_GPIO
# ADRV1
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS18}    [get_ports adrv1_gpio_00]           ; ## GPIO0          ADRV_GPIO0_1        IO_L1N_T0L_N1_DBC_67
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS18}    [get_ports adrv1_gpio_01]           ; ## GPIO1          ADRV_GPIO1_1        IO_L20N_T3L_N3_AD1N_67
set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS18}    [get_ports adrv1_gpio_02]           ; ## GPIO2          ADRV_GPIO2_1        IO_L2P_T0L_N2_67
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS18}    [get_ports adrv1_gpio_03]           ; ## GPIO3          ADRV_GPIO3_1        IO_L22N_T3U_N7_DBC_AD0N_67
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18}    [get_ports adrv1_gpio_04]           ; ## GPIO4          ADRV_GPIO4_1        IO_L24N_T3U_N11_67
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS18}    [get_ports adrv1_gpio_05]           ; ## GPIO5          ADRV_GPIO5_1        IO_L19N_T3L_N1_DBC_AD9N_67
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS18}    [get_ports adrv1_gpio_06]           ; ## GPIO6          ADRV_GPIO6_1        IO_L24P_T3U_N10_67
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS18}    [get_ports adrv1_gpio_07]           ; ## GPIO7          ADRV_GPIO7_1        IO_L19P_T3L_N0_DBC_AD9P_67

# ADRV2
set_property -dict {PACKAGE_PIN Y7  IOSTANDARD LVCMOS18}    [get_ports adrv2_gpio_00]           ; ## GPIO0          ADRV_GPIO0_2        IO_L11N_T1U_N9_GC_66
set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS18}    [get_ports adrv2_gpio_01]           ; ## GPIO1          ADRV_GPIO1_2        IO_L23P_T3U_N8_66
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS18}    [get_ports adrv2_gpio_02]           ; ## GPIO2          ADRV_GPIO2_2        IO_L4P_T0U_N6_DBC_AD7P_66
set_property -dict {PACKAGE_PIN W2  IOSTANDARD LVCMOS18}    [get_ports adrv2_gpio_03]           ; ## GPIO3          ADRV_GPIO3_2        IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN Y1  IOSTANDARD LVCMOS18}    [get_ports adrv2_gpio_04]           ; ## GPIO4          ADRV_GPIO4_2        IO_L22N_T3U_N7_DBC_AD0N_66
set_property -dict {PACKAGE_PIN Y2  IOSTANDARD LVCMOS18}    [get_ports adrv2_gpio_05]           ; ## GPIO5          ADRV_GPIO5_2        IO_L22P_T3U_N6_DBC_AD0P_66
set_property -dict {PACKAGE_PIN AA1 IOSTANDARD LVCMOS18}    [get_ports adrv2_gpio_06]           ; ## GPIO6          ADRV_GPIO6_2        IO_L21N_T3L_N5_AD8N_66
set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVCMOS18}    [get_ports adrv2_gpio_07]           ; ## GPIO7          ADRV_GPIO7_2        IO_L21P_T3L_N4_AD8P_66

###############################
# FPGA CRD
set_property -dict {PACKAGE_PIN Y4  IOSTANDARD LVCMOS18}    [get_ports fpga_crd_p]              ; ##                FPGA_CRD_P          IO_L13P_T2L_N0_GC_QBC_66
set_property -dict {PACKAGE_PIN Y3  IOSTANDARD LVCMOS18}    [get_ports fpga_crd_n]              ; ##                FPGA_CRD_N          IO_L13N_T2L_N1_GC_QBC_66




###############################
# SFP - BANK 128 - GTH
set_property -dict {PACKAGE_PIN R27} [get_ports sfp_refclk_p]                                   ; # SFP_REFCLK_P    MGTREFCLK0P_128
set_property -dict {PACKAGE_PIN R28} [get_ports sfp_refclk_n]                                   ; # SFP_REFCLK_N    MGTREFCLK0N_128
set_property -dict {PACKAGE_PIN T29} [get_ports sfp_tx_p]                                       ; # SFP_TX_P        MGTHTXP0_128
set_property -dict {PACKAGE_PIN T30} [get_ports sfp_tx_n]                                       ; # SFP_TX_N        MGTHTXN0_128
set_property -dict {PACKAGE_PIN T33} [get_ports sfp_rx_p]                                       ; # SFP_RX_P        MGTHRXP0_128
set_property -dict {PACKAGE_PIN T34} [get_ports sfp_rx_n]                                       ; # SFP_RX_N        MGTHRXN0_128

# SFP_CTRL
set_property -dict {PACKAGE_PIN AP14 IOSTANDARD LVCMOS33} [get_ports sfp_tx_fault]              ; ## Schematic 3V3 - please check
set_property -dict {PACKAGE_PIN AN14 IOSTANDARD LVCMOS33} [get_ports sfp_tx_disable]            ; ## Schematic 3V3 - please check
set_property -dict {PACKAGE_PIN AN13 IOSTANDARD LVCMOS33} [get_ports sfp_mod_abs]               ; ## Schematic 3V3 - please check
set_property -dict {PACKAGE_PIN AM14 IOSTANDARD LVCMOS33} [get_ports sfp_rx_los]                ; ## Schematic 3V3 - please check

###############################
# DDS1_CTRL
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS33} [get_ports dds1_ps0]                   ; ## PS0            DDS_PS0_1
set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVCMOS33} [get_ports dds1_ps1]                   ; ## PS1            DDS_PS1_1
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33} [get_ports dds1_ps2]                   ; ## PS2            DDS_PS2_1
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports dds1_d0]                    ; ## D0             DDS_D0_1
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports dds1_d1]                    ; ## D1             DDS_D1_1
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports dds1_d2]                    ; ## D2             DDS_D2_1
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS33} [get_ports dds1_d3]                    ; ## D3             DDS_D3_1
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports dds1_d4]                    ; ## D4             DDS_D4_1
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports dds1_d5]                    ; ## D5             DDS_D5_1
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports dds1_d6]                    ; ## D6             DDS_D6_1
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVCMOS33} [get_ports dds1_d7]                    ; ## D7             DDS_D7_1
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports dds1_d8]                    ; ## D8             DDS_D8_1
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports dds1_d9]                    ; ## D9             DDS_D9_1
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports dds1_d10]                   ; ## D10            DDS_D10_1
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports dds1_d11]                   ; ## D11            DDS_D11_1
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS33} [get_ports dds1_d12]                   ; ## D12            DDS_D12_1
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports dds1_d13]                   ; ## D13            DDS_D13_1
set_property -dict {PACKAGE_PIN F11 IOSTANDARD LVCMOS33} [get_ports dds1_d14]                   ; ## D14            DDS_D14_1
set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVCMOS33} [get_ports dds1_d15]                   ; ## D15            DDS_D15_1
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports dds1_d16]                   ; ## D16            DDS_D16_1
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS33} [get_ports dds1_d17]                   ; ## D17            DDS_D17_1
set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVCMOS33} [get_ports dds1_d18]                   ; ## D18            DDS_D18_1
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports dds1_d19]                   ; ## D19            DDS_D19_1
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports dds1_d20]                   ; ## D20            DDS_D20_1
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS33} [get_ports dds1_d21]                   ; ## D21            DDS_D21_1
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS33} [get_ports dds1_d22]                   ; ## D22            DDS_D22_1
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports dds1_d23]                   ; ## D23            DDS_D23_1
set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVCMOS33} [get_ports dds1_d24]                   ; ## D24            DDS_D24_1
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports dds1_d25]                   ; ## D25            DDS_D25_1
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports dds1_d26]                   ; ## D26            DDS_D26_1
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports dds1_d27]                   ; ## D27            DDS_D27_1
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports dds1_d28]                   ; ## D28            DDS_D28_1
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports dds1_d29]                   ; ## D29            DDS_D29_1
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports dds1_d30]                   ; ## D30            DDS_D30_1
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports dds1_d31]                   ; ## D31            DDS_D31_1
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports dds1_osk]                   ; ## OSK            DDS_OSK_1
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports dds1_drctl]                 ; ## DRCTL          DDS_DRCTL_1
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports dds1_drhold]                ; ## DRHOLD         DDS_DRHOLD_1
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports dds1_drover]                ; ## DROVER         DDS_DROVER_1
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports dds1_f0]                    ; ## F0             DDS_F0_1
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports dds1_f1]                    ; ## F1             DDS_F1_1
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports dds1_f2]                    ; ## F2             DDS_F2_1
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports dds1_f3]                    ; ## F3             DDS_F3_1
set_property -dict {PACKAGE_PIN H10 IOSTANDARD LVCMOS33} [get_ports dds1_ioup]                  ; ## IOUP           DDS_IOUP_1
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports dds1_drst]                  ; ## DRST           DDS_DRST_1
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports dds1_pdn]                   ; ## PDN            DDS_PDN_1
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports dds1_mrst]                  ; ## MRST           DDS_MRST_1
set_property -dict {PACKAGE_PIN J10 IOSTANDARD LVCMOS33} [get_ports dds1_sclk]                  ; ## SCLK           DDS_SCLK_1

###############################
# DDS2_CTRL
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS33} [get_ports dds2_ps0]                   ; ## DDS_PS0_2
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports dds2_ps1]                   ; ## DDS_PS1_2
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports dds2_ps2]                   ; ## DDS_PS2_2
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports dds2_d0]                    ; ## DDS_D0_2
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS33} [get_ports dds2_d1]                    ; ## DDS_D1_2
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports dds2_d2]                    ; ## DDS_D2_2
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports dds2_d3]                    ; ## DDS_D3_2
set_property -dict {PACKAGE_PIN H21 IOSTANDARD LVCMOS33} [get_ports dds2_d4]                    ; ## DDS_D4_2
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports dds2_d5]                    ; ## DDS_D5_2
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33} [get_ports dds2_d6]                    ; ## DDS_D6_2
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports dds2_d7]                    ; ## DDS_D7_2
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33} [get_ports dds2_d8]                    ; ## DDS_D8_2
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS33} [get_ports dds2_d9]                    ; ## DDS_D9_2
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports dds2_d10]                   ; ## DDS_D10_2
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports dds2_d11]                   ; ## DDS_D11_2
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports dds2_d12]                   ; ## DDS_D12_2
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS33} [get_ports dds2_d13]                   ; ## DDS_D13_2
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports dds2_d14]                   ; ## DDS_D14_2
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS33} [get_ports dds2_d15]                   ; ## DDS_D15_2
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33} [get_ports dds2_d16]                   ; ## DDS_D16_2
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS33} [get_ports dds2_d17]                   ; ## DDS_D17_2
set_property -dict {PACKAGE_PIN C21 IOSTANDARD LVCMOS33} [get_ports dds2_d18]                   ; ## DDS_D18_2
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports dds2_d19]                   ; ## DDS_D19_2
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports dds2_d20]                   ; ## DDS_D20_2
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports dds2_d21]                   ; ## DDS_D21_2
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports dds2_d22]                   ; ## DDS_D22_2
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports dds2_d23]                   ; ## DDS_D23_2
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports dds2_d24]                   ; ## DDS_D24_2
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports dds2_d25]                   ; ## DDS_D25_2
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports dds2_d26]                   ; ## DDS_D26_2
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports dds2_d27]                   ; ## DDS_D27_2
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports dds2_d28]                   ; ## DDS_D28_2
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports dds2_d29]                   ; ## DDS_D29_2
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports dds2_d30]                   ; ## DDS_D30_2
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports dds2_d31]                   ; ## DDS_D31_2
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports dds2_osk]                   ; ## DDS_OSK_2
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports dds2_drctl]                 ; ## DDS_DRCTL_2
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports dds2_drhold]                ; ## DDS_DRHOLD_2
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports dds2_drover]                ; ## DDS_DROVER_2
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports dds2_f0]                    ; ## DDS_F0_2
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports dds2_f1]                    ; ## DDS_F1_2
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVCMOS33} [get_ports dds2_f2]                    ; ## DDS_F2_2
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports dds2_f3]                    ; ## DDS_F3_2
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports dds2_ioup]                  ; ## DDS_IOUP_2
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports dds2_drst]                  ; ## DDS_DRST_2
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports dds2_pdn]                   ; ## DDS_PDN_2
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports dds2_mrst]                  ; ## DDS_MRST_2
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports dds2_sclk]                  ; ## DDS_SCLK_2

###############################
# ADCx_CTRL
set_property -dict {PACKAGE_PIN AJ12    IOSTANDARD LVCMOS18}    [get_ports adc1_pre]            ; # PRE     ADC_PRE_1       
set_property -dict {PACKAGE_PIN AM11    IOSTANDARD LVCMOS18}    [get_ports adc1_busy]           ; # BUSY    ADC_BUSY_1      
set_property -dict {PACKAGE_PIN AK4     IOSTANDARD LVCMOS18}    [get_ports adc1_mclk]           ; # MCLK    ADC_MCLK_1      
set_property -dict {PACKAGE_PIN AK7     IOSTANDARD LVCMOS18}    [get_ports adc1_sckb]           ; # SCKB    ADC_SCKB_1      
set_property -dict {PACKAGE_PIN AL8     IOSTANDARD LVCMOS18}    [get_ports adc1_scka]           ; # SCKA    ADC_SCKA_1      
set_property -dict {PACKAGE_PIN AN11    IOSTANDARD LVCMOS18}    [get_ports adc1_sdob]           ; # SDOB    ADC_SDOB_1      
set_property -dict {PACKAGE_PIN AM10    IOSTANDARD LVCMOS18}    [get_ports adc1_sdoa]           ; # SDOA    ADC_SDOA_1      
set_property -dict {PACKAGE_PIN AK5     IOSTANDARD LVCMOS18}    [get_ports adc1_drl]            ; # DRL     ADC_DRL_1       
set_property -dict {PACKAGE_PIN AL7     IOSTANDARD LVCMOS18}    [get_ports adc1_sdi]            ; # SDI     ADC_SDI_1       
set_property -dict {PACKAGE_PIN AN6     IOSTANDARD LVCMOS18}    [get_ports adc1_rdlb]           ; # RDLB    ADC_RDLB_1      
set_property -dict {PACKAGE_PIN AK9     IOSTANDARD LVCMOS18}    [get_ports adc1_rdla]           ; # RDLA    ADC_RDLA_1      
set_property -dict {PACKAGE_PIN AM9     IOSTANDARD LVCMOS18}    [get_ports adc1_sync]           ; # SYNC    ADC_SYNC_1      

set_property -dict {PACKAGE_PIN AK12    IOSTANDARD LVCMOS18}    [get_ports adc2_pre]            ; # PRE     ADC_PRE_2
set_property -dict {PACKAGE_PIN AM8     IOSTANDARD LVCMOS18}    [get_ports adc2_busy]           ; # BUSY    ADC_BUSY_2
set_property -dict {PACKAGE_PIN AM3     IOSTANDARD LVCMOS18}    [get_ports adc2_mclk]           ; # MCLK    ADC_MCLK_2
set_property -dict {PACKAGE_PIN AK2     IOSTANDARD LVCMOS18}    [get_ports adc2_sckb]           ; # SCKB    ADC_SCKB_2
set_property -dict {PACKAGE_PIN AL1     IOSTANDARD LVCMOS18}    [get_ports adc2_scka]           ; # SCKA    ADC_SCKA_2
set_property -dict {PACKAGE_PIN AK1     IOSTANDARD LVCMOS18}    [get_ports adc2_sdob]           ; # SDOB    ADC_SDOB_2
set_property -dict {PACKAGE_PIN AK3     IOSTANDARD LVCMOS18}    [get_ports adc2_sdoa]           ; # SDOA    ADC_SDOA_2
set_property -dict {PACKAGE_PIN AM1     IOSTANDARD LVCMOS18}    [get_ports adc2_drl]            ; # DRL     ADC_DRL_2
set_property -dict {PACKAGE_PIN AL2     IOSTANDARD LVCMOS18}    [get_ports adc2_sdi]            ; # SDI     ADC_SDI_2
set_property -dict {PACKAGE_PIN AJ9     IOSTANDARD LVCMOS18}    [get_ports adc2_rdlb]           ; # RDLB    ADC_RDLB_2
set_property -dict {PACKAGE_PIN AL11    IOSTANDARD LVCMOS18}    [get_ports adc2_rdla]           ; # RDLA    ADC_RDLA_2
set_property -dict {PACKAGE_PIN AL3     IOSTANDARD LVCMOS18}    [get_ports adc2_sync]           ; # SYNC    ADC_SYNC_2

set_property -dict {PACKAGE_PIN AP9     IOSTANDARD LVCMOS18}    [get_ports adc3_pre]            ; # PRE     ADC_PRE_3
set_property -dict {PACKAGE_PIN AN1     IOSTANDARD LVCMOS18}    [get_ports adc3_busy]           ; # BUSY    ADC_BUSY_3
set_property -dict {PACKAGE_PIN AP3     IOSTANDARD LVCMOS18}    [get_ports adc3_mclk]           ; # MCLK    ADC_MCLK_3
set_property -dict {PACKAGE_PIN AN2     IOSTANDARD LVCMOS18}    [get_ports adc3_sckb]           ; # SCKB    ADC_SCKB_3
set_property -dict {PACKAGE_PIN AP1     IOSTANDARD LVCMOS18}    [get_ports adc3_scka]           ; # SCKA    ADC_SCKA_3
set_property -dict {PACKAGE_PIN AM4     IOSTANDARD LVCMOS18}    [get_ports adc3_sdob]           ; # SDOB    ADC_SDOB_3
set_property -dict {PACKAGE_PIN AN4     IOSTANDARD LVCMOS18}    [get_ports adc3_sdoa]           ; # SDOA    ADC_SDOA_3
set_property -dict {PACKAGE_PIN AP2     IOSTANDARD LVCMOS18}    [get_ports adc3_drl]            ; # DRL     ADC_DRL_3
set_property -dict {PACKAGE_PIN AL5     IOSTANDARD LVCMOS18}    [get_ports adc3_sdi]            ; # SDI     ADC_SDI_3
set_property -dict {PACKAGE_PIN AJ7     IOSTANDARD LVCMOS18}    [get_ports adc3_rdlb]           ; # RDLB    ADC_RDLB_3
set_property -dict {PACKAGE_PIN AL10    IOSTANDARD LVCMOS18}    [get_ports adc3_rdla]           ; # RDLA    ADC_RDLA_3
set_property -dict {PACKAGE_PIN AM6     IOSTANDARD LVCMOS18}    [get_ports adc3_sync]           ; # SYNC    ADC_SYNC_3

set_property -dict {PACKAGE_PIN AJ10    IOSTANDARD LVCMOS18}    [get_ports adc4_pre]            ; # PRE     ADC_PRE_4
set_property -dict {PACKAGE_PIN AP4     IOSTANDARD LVCMOS18}    [get_ports adc4_busy]           ; # BUSY    ADC_BUSY_4
set_property -dict {PACKAGE_PIN AP11    IOSTANDARD LVCMOS18}    [get_ports adc4_mclk]           ; # MCLK    ADC_MCLK_4
set_property -dict {PACKAGE_PIN AP6     IOSTANDARD LVCMOS18}    [get_ports adc4_sckb]           ; # SCKB    ADC_SCKB_4
set_property -dict {PACKAGE_PIN AN7     IOSTANDARD LVCMOS18}    [get_ports adc4_scka]           ; # SCKA    ADC_SCKA_4
set_property -dict {PACKAGE_PIN AP5     IOSTANDARD LVCMOS18}    [get_ports adc4_sdob]           ; # SDOB    ADC_SDOB_4
set_property -dict {PACKAGE_PIN AP7     IOSTANDARD LVCMOS18}    [get_ports adc4_sdoa]           ; # SDOA    ADC_SDOA_4
set_property -dict {PACKAGE_PIN AN9     IOSTANDARD LVCMOS18}    [get_ports adc4_drl]            ; # DRL     ADC_DRL_4
set_property -dict {PACKAGE_PIN AN8     IOSTANDARD LVCMOS18}    [get_ports adc4_sdi]            ; # SDI     ADC_SDI_4
set_property -dict {PACKAGE_PIN AK10    IOSTANDARD LVCMOS18}    [get_ports adc4_rdlb]           ; # RDLB    ADC_RDLB_4
set_property -dict {PACKAGE_PIN AK8     IOSTANDARD LVCMOS18}    [get_ports adc4_rdla]           ; # RDLA    ADC_RDLA_4
set_property -dict {PACKAGE_PIN AP10    IOSTANDARD LVCMOS18}    [get_ports adc4_sync]           ; # SYNC    ADC_SYNC_4

###############################
# EX1_SE
set_property -dict {PACKAGE_PIN AF10    IOSTANDARD LVCMOS18}   [get_ports ex1_se4]              ;          
set_property -dict {PACKAGE_PIN AE10    IOSTANDARD LVCMOS18}   [get_ports ex1_se6]              ;          
set_property -dict {PACKAGE_PIN AH11    IOSTANDARD LVCMOS18}   [get_ports ex1_se3]              ;          
set_property -dict {PACKAGE_PIN AH12    IOSTANDARD LVCMOS18}   [get_ports ex1_se8]              ;          
set_property -dict {PACKAGE_PIN AF12    IOSTANDARD LVCMOS18}   [get_ports ex1_se9]              ;          
set_property -dict {PACKAGE_PIN AE12    IOSTANDARD LVCMOS18}   [get_ports ex1_se10]             ;              
set_property -dict {PACKAGE_PIN AG11    IOSTANDARD LVCMOS18}   [get_ports ex1_se5]              ;          
set_property -dict {PACKAGE_PIN AF11    IOSTANDARD LVCMOS18}   [get_ports ex1_se7]              ;          
set_property -dict {PACKAGE_PIN AG9     IOSTANDARD LVCMOS18}   [get_ports ex1_se2]              ;          
set_property -dict {PACKAGE_PIN AG10    IOSTANDARD LVCMOS18}   [get_ports ex1_se1]              ;          
set_property -dict {PACKAGE_PIN AE9     IOSTANDARD LVCMOS18}   [get_ports ex1_pair1_n]          ;              
set_property -dict {PACKAGE_PIN AD10    IOSTANDARD LVCMOS18}   [get_ports ex1_pair1_p]          ;              
set_property -dict {PACKAGE_PIN AH6     IOSTANDARD LVCMOS18}   [get_ports ex1_pair5_n]          ;              
set_property -dict {PACKAGE_PIN AH7     IOSTANDARD LVCMOS18}   [get_ports ex1_pair5_p]          ;              
set_property -dict {PACKAGE_PIN AH8     IOSTANDARD LVCMOS18}   [get_ports ex1_pair7_n]          ;              
set_property -dict {PACKAGE_PIN AG8     IOSTANDARD LVCMOS18}   [get_ports ex1_pair7_p]          ;              
set_property -dict {PACKAGE_PIN AD6     IOSTANDARD LVCMOS18}   [get_ports ex1_pair2_n]          ;              
set_property -dict {PACKAGE_PIN AD7     IOSTANDARD LVCMOS18}   [get_ports ex1_pair2_p]          ;              
set_property -dict {PACKAGE_PIN AF8     IOSTANDARD LVCMOS18}   [get_ports ex1_pair8_n]          ;              
set_property -dict {PACKAGE_PIN AE8     IOSTANDARD LVCMOS18}   [get_ports ex1_pair8_p]          ;              
set_property -dict {PACKAGE_PIN AG6     IOSTANDARD LVCMOS18}   [get_ports ex1_pair4_n]          ;              
set_property -dict {PACKAGE_PIN AF6     IOSTANDARD LVCMOS18}   [get_ports ex1_pair4_p]          ;              
set_property -dict {PACKAGE_PIN AF7     IOSTANDARD LVCMOS18}   [get_ports ex1_pair6_n]          ;              
set_property -dict {PACKAGE_PIN AE7     IOSTANDARD LVCMOS18}   [get_ports ex1_pair6_p]          ;              
set_property -dict {PACKAGE_PIN AF5     IOSTANDARD LVCMOS18}   [get_ports ex1_pair3_n]          ;              
set_property -dict {PACKAGE_PIN AE5     IOSTANDARD LVCMOS18}   [get_ports ex1_pair3_p]          ;    

###############################
# EX_SE
set_property -dict {PACKAGE_PIN AG1     IOSTANDARD LVCMOS18}   [get_ports ex_se20]              ;
set_property -dict {PACKAGE_PIN AD5     IOSTANDARD LVCMOS18}   [get_ports ex_se14]              ;
set_property -dict {PACKAGE_PIN AH9     IOSTANDARD LVCMOS18}   [get_ports ex_se18]              ;
set_property -dict {PACKAGE_PIN AD9     IOSTANDARD LVCMOS18}   [get_ports ex_se17]              ;
set_property -dict {PACKAGE_PIN AE2     IOSTANDARD LVCMOS18}   [get_ports ex_se10]              ;
set_property -dict {PACKAGE_PIN AE1     IOSTANDARD LVCMOS18}   [get_ports ex_se11]              ;
set_property -dict {PACKAGE_PIN AD2     IOSTANDARD LVCMOS18}   [get_ports ex_se12]              ;
set_property -dict {PACKAGE_PIN AD1     IOSTANDARD LVCMOS18}   [get_ports ex_se13]              ;
set_property -dict {PACKAGE_PIN AH1     IOSTANDARD LVCMOS18}   [get_ports ex_se19]              ;
set_property -dict {PACKAGE_PIN AJ1     IOSTANDARD LVCMOS18}   [get_ports ex_se25]              ;
set_property -dict {PACKAGE_PIN AF2     IOSTANDARD LVCMOS18}   [get_ports ex_se21]              ;
set_property -dict {PACKAGE_PIN AF1     IOSTANDARD LVCMOS18}   [get_ports ex_se9]               ;
set_property -dict {PACKAGE_PIN AG3     IOSTANDARD LVCMOS18}   [get_ports ex_se3]               ;
set_property -dict {PACKAGE_PIN AH3     IOSTANDARD LVCMOS18}   [get_ports ex_se2]               ;
set_property -dict {PACKAGE_PIN AH2     IOSTANDARD LVCMOS18}   [get_ports ex_se26]              ;
set_property -dict {PACKAGE_PIN AJ2     IOSTANDARD LVCMOS18}   [get_ports ex_se24]              ;
set_property -dict {PACKAGE_PIN AD4     IOSTANDARD LVCMOS18}   [get_ports ex_se15]              ;
set_property -dict {PACKAGE_PIN AE4     IOSTANDARD LVCMOS18}   [get_ports ex_se8]               ;
set_property -dict {PACKAGE_PIN AE3     IOSTANDARD LVCMOS18}   [get_ports ex_se23]              ;
set_property -dict {PACKAGE_PIN AF3     IOSTANDARD LVCMOS18}   [get_ports ex_se1]               ;
set_property -dict {PACKAGE_PIN AJ6     IOSTANDARD LVCMOS18}   [get_ports ex_se16]              ;
set_property -dict {PACKAGE_PIN AJ5     IOSTANDARD LVCMOS18}   [get_ports ex_se7]               ;
set_property -dict {PACKAGE_PIN AH4     IOSTANDARD LVCMOS18}   [get_ports ex_se5]               ;
set_property -dict {PACKAGE_PIN AJ4     IOSTANDARD LVCMOS18}   [get_ports ex_se4]               ;
set_property -dict {PACKAGE_PIN AG5     IOSTANDARD LVCMOS18}   [get_ports ex_se22]              ;
set_property -dict {PACKAGE_PIN AG4     IOSTANDARD LVCMOS18}   [get_ports ex_se6]               ;

###############################
# PS : JTAG |UART |DDR4 |EMMC | FLASH |SD | I2CMUX | SATA | USB
