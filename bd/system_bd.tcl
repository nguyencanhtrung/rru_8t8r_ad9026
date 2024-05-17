
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu15eg-ffvb1156-2-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
analog.com:user:util_dacfifo:1.0\
analog.com:user:axi_dmac:1.0\
analog.com:user:util_cpack2:1.0\
analog.com:user:util_upack2:1.0\
analog.com:user:axi_adxcvr:1.0\
analog.com:user:util_adxcvr:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:zynq_ultra_ps_e:3.4\
xilinx.com:ip:proc_sys_reset:5.0\
analog.com:user:axi_sysid:1.0\
analog.com:user:sysid_rom:1.0\
xilinx.com:ip:xlslice:1.0\
analog.com:user:jesd204_rx:1.0\
analog.com:user:axi_jesd204_rx:1.0\
analog.com:user:jesd204_tx:1.0\
analog.com:user:axi_jesd204_tx:1.0\
analog.com:user:ad_ip_jesd204_tpl_adc:1.0\
analog.com:user:ad_ip_jesd204_tpl_dac:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: tx_adrv_tpl_core
proc create_hier_cell_tx_adrv_tpl_core { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_tx_adrv_tpl_core() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 link

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi


  # Create pins
  create_bd_pin -dir I -from 15 -to 0 dac_data_0
  create_bd_pin -dir I -from 15 -to 0 dac_data_1
  create_bd_pin -dir I -from 15 -to 0 dac_data_2
  create_bd_pin -dir I -from 15 -to 0 dac_data_3
  create_bd_pin -dir I -from 15 -to 0 dac_data_4
  create_bd_pin -dir I -from 15 -to 0 dac_data_5
  create_bd_pin -dir I -from 15 -to 0 dac_data_6
  create_bd_pin -dir I -from 15 -to 0 dac_data_7
  create_bd_pin -dir I dac_dunf
  create_bd_pin -dir O -from 0 -to 0 dac_enable_0
  create_bd_pin -dir O -from 0 -to 0 dac_enable_1
  create_bd_pin -dir O -from 0 -to 0 dac_enable_2
  create_bd_pin -dir O -from 0 -to 0 dac_enable_3
  create_bd_pin -dir O -from 0 -to 0 dac_enable_4
  create_bd_pin -dir O -from 0 -to 0 dac_enable_5
  create_bd_pin -dir O -from 0 -to 0 dac_enable_6
  create_bd_pin -dir O -from 0 -to 0 dac_enable_7
  create_bd_pin -dir O -from 0 -to 0 dac_valid_0
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: dac_tpl_core, and set properties
  set dac_tpl_core [ create_bd_cell -type ip -vlnv analog.com:user:ad_ip_jesd204_tpl_dac:1.0 dac_tpl_core ]
  set_property -dict [list \
    CONFIG.BITS_PER_SAMPLE {16} \
    CONFIG.CONVERTER_RESOLUTION {16} \
    CONFIG.DMA_BITS_PER_SAMPLE {16} \
    CONFIG.NUM_CHANNELS {16} \
    CONFIG.NUM_LANES {8} \
    CONFIG.OCTETS_PER_BEAT {4} \
    CONFIG.SAMPLES_PER_FRAME {1} \
  ] $dac_tpl_core


  # Create instance: data_concat0, and set properties
  set data_concat0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 data_concat0 ]
  set_property CONFIG.NUM_PORTS {8} $data_concat0


  # Create instance: enable_slice_0, and set properties
  set enable_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_0


  # Create instance: enable_slice_1, and set properties
  set enable_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_1


  # Create instance: enable_slice_2, and set properties
  set enable_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_2


  # Create instance: enable_slice_3, and set properties
  set enable_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_3


  # Create instance: enable_slice_4, and set properties
  set enable_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_4 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {4} \
    CONFIG.DIN_TO {4} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_4


  # Create instance: enable_slice_5, and set properties
  set enable_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_5 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {5} \
    CONFIG.DIN_TO {5} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_5


  # Create instance: enable_slice_6, and set properties
  set enable_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_6 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {6} \
    CONFIG.DIN_TO {6} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_6


  # Create instance: enable_slice_7, and set properties
  set enable_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_7 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {7} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_7


  # Create instance: valid_slice_0, and set properties
  set valid_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {16} \
  ] $valid_slice_0


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net dac_tpl_core_link [get_bd_intf_pins link] [get_bd_intf_pins dac_tpl_core/link]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins dac_tpl_core/s_axi]

  # Create port connections
  connect_bd_net -net dac_data_0_1 [get_bd_pins dac_data_0] [get_bd_pins data_concat0/In0]
  connect_bd_net -net dac_data_1_1 [get_bd_pins dac_data_1] [get_bd_pins data_concat0/In1]
  connect_bd_net -net dac_data_2_1 [get_bd_pins dac_data_2] [get_bd_pins data_concat0/In2]
  connect_bd_net -net dac_data_3_1 [get_bd_pins dac_data_3] [get_bd_pins data_concat0/In3]
  connect_bd_net -net dac_data_4_1 [get_bd_pins dac_data_4] [get_bd_pins data_concat0/In4]
  connect_bd_net -net dac_data_5_1 [get_bd_pins dac_data_5] [get_bd_pins data_concat0/In5]
  connect_bd_net -net dac_data_6_1 [get_bd_pins dac_data_6] [get_bd_pins data_concat0/In6]
  connect_bd_net -net dac_data_7_1 [get_bd_pins dac_data_7] [get_bd_pins data_concat0/In7]
  connect_bd_net -net dac_dunf_1 [get_bd_pins dac_dunf] [get_bd_pins dac_tpl_core/dac_dunf]
  connect_bd_net -net dac_tpl_core_dac_valid [get_bd_pins dac_tpl_core/dac_valid] [get_bd_pins valid_slice_0/Din]
  connect_bd_net -net dac_tpl_core_enable [get_bd_pins dac_tpl_core/enable] [get_bd_pins enable_slice_0/Din] [get_bd_pins enable_slice_1/Din] [get_bd_pins enable_slice_2/Din] [get_bd_pins enable_slice_3/Din] [get_bd_pins enable_slice_4/Din] [get_bd_pins enable_slice_5/Din] [get_bd_pins enable_slice_6/Din] [get_bd_pins enable_slice_7/Din]
  connect_bd_net -net data_concat0_dout [get_bd_pins data_concat0/dout] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net enable_slice_0_Dout [get_bd_pins dac_enable_0] [get_bd_pins enable_slice_0/Dout]
  connect_bd_net -net enable_slice_1_Dout [get_bd_pins dac_enable_1] [get_bd_pins enable_slice_1/Dout]
  connect_bd_net -net enable_slice_2_Dout [get_bd_pins dac_enable_2] [get_bd_pins enable_slice_2/Dout]
  connect_bd_net -net enable_slice_3_Dout [get_bd_pins dac_enable_3] [get_bd_pins enable_slice_3/Dout]
  connect_bd_net -net enable_slice_4_Dout [get_bd_pins dac_enable_4] [get_bd_pins enable_slice_4/Dout]
  connect_bd_net -net enable_slice_5_Dout [get_bd_pins dac_enable_5] [get_bd_pins enable_slice_5/Dout]
  connect_bd_net -net enable_slice_6_Dout [get_bd_pins dac_enable_6] [get_bd_pins enable_slice_6/Dout]
  connect_bd_net -net enable_slice_7_Dout [get_bd_pins dac_enable_7] [get_bd_pins enable_slice_7/Dout]
  connect_bd_net -net link_clk_1 [get_bd_pins link_clk] [get_bd_pins dac_tpl_core/link_clk]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins dac_tpl_core/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins dac_tpl_core/s_axi_aresetn]
  connect_bd_net -net valid_slice_0_Dout [get_bd_pins dac_valid_0] [get_bd_pins valid_slice_0/Dout]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dac_tpl_core/dac_ddata] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: rx_adrv_tpl_core
proc create_hier_cell_rx_adrv_tpl_core { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_rx_adrv_tpl_core() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi


  # Create pins
  create_bd_pin -dir O -from 15 -to 0 adc_data_0
  create_bd_pin -dir O -from 15 -to 0 adc_data_1
  create_bd_pin -dir O -from 15 -to 0 adc_data_2
  create_bd_pin -dir O -from 15 -to 0 adc_data_3
  create_bd_pin -dir O -from 15 -to 0 adc_data_4
  create_bd_pin -dir O -from 15 -to 0 adc_data_5
  create_bd_pin -dir O -from 15 -to 0 adc_data_6
  create_bd_pin -dir O -from 15 -to 0 adc_data_7
  create_bd_pin -dir I adc_dovf
  create_bd_pin -dir O -from 0 -to 0 adc_enable_0
  create_bd_pin -dir O -from 0 -to 0 adc_enable_1
  create_bd_pin -dir O -from 0 -to 0 adc_enable_2
  create_bd_pin -dir O -from 0 -to 0 adc_enable_3
  create_bd_pin -dir O -from 0 -to 0 adc_enable_4
  create_bd_pin -dir O -from 0 -to 0 adc_enable_5
  create_bd_pin -dir O -from 0 -to 0 adc_enable_6
  create_bd_pin -dir O -from 0 -to 0 adc_enable_7
  create_bd_pin -dir O -from 0 -to 0 adc_valid_0
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -from 255 -to 0 link_data
  create_bd_pin -dir I -from 3 -to 0 link_sof
  create_bd_pin -dir I link_valid
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: adc_tpl_core, and set properties
  set adc_tpl_core [ create_bd_cell -type ip -vlnv analog.com:user:ad_ip_jesd204_tpl_adc:1.0 adc_tpl_core ]
  set_property -dict [list \
    CONFIG.BITS_PER_SAMPLE {16} \
    CONFIG.CONVERTER_RESOLUTION {16} \
    CONFIG.DMA_BITS_PER_SAMPLE {16} \
    CONFIG.NUM_CHANNELS {16} \
    CONFIG.NUM_LANES {8} \
    CONFIG.OCTETS_PER_BEAT {4} \
    CONFIG.SAMPLES_PER_FRAME {1} \
  ] $adc_tpl_core


  # Create instance: data_slice_0, and set properties
  set data_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {15} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {256} \
    CONFIG.DOUT_WIDTH {16} \
  ] $data_slice_0


  # Create instance: data_slice_1, and set properties
  set data_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {31} \
    CONFIG.DIN_TO {16} \
    CONFIG.DIN_WIDTH {256} \
    CONFIG.DOUT_WIDTH {16} \
  ] $data_slice_1


  # Create instance: data_slice_2, and set properties
  set data_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {47} \
    CONFIG.DIN_TO {32} \
    CONFIG.DIN_WIDTH {256} \
    CONFIG.DOUT_WIDTH {16} \
  ] $data_slice_2


  # Create instance: data_slice_3, and set properties
  set data_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {63} \
    CONFIG.DIN_TO {48} \
    CONFIG.DIN_WIDTH {256} \
    CONFIG.DOUT_WIDTH {16} \
  ] $data_slice_3


  # Create instance: data_slice_4, and set properties
  set data_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_4 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {79} \
    CONFIG.DIN_TO {64} \
    CONFIG.DIN_WIDTH {256} \
    CONFIG.DOUT_WIDTH {16} \
  ] $data_slice_4


  # Create instance: data_slice_5, and set properties
  set data_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_5 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {95} \
    CONFIG.DIN_TO {80} \
    CONFIG.DIN_WIDTH {256} \
    CONFIG.DOUT_WIDTH {16} \
  ] $data_slice_5


  # Create instance: data_slice_6, and set properties
  set data_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_6 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {111} \
    CONFIG.DIN_TO {96} \
    CONFIG.DIN_WIDTH {256} \
    CONFIG.DOUT_WIDTH {16} \
  ] $data_slice_6


  # Create instance: data_slice_7, and set properties
  set data_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_7 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {127} \
    CONFIG.DIN_TO {112} \
    CONFIG.DIN_WIDTH {256} \
    CONFIG.DOUT_WIDTH {16} \
  ] $data_slice_7


  # Create instance: enable_slice_0, and set properties
  set enable_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_0


  # Create instance: enable_slice_1, and set properties
  set enable_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_1


  # Create instance: enable_slice_2, and set properties
  set enable_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_2


  # Create instance: enable_slice_3, and set properties
  set enable_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_3


  # Create instance: enable_slice_4, and set properties
  set enable_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_4 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {4} \
    CONFIG.DIN_TO {4} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_4


  # Create instance: enable_slice_5, and set properties
  set enable_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_5 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {5} \
    CONFIG.DIN_TO {5} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_5


  # Create instance: enable_slice_6, and set properties
  set enable_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_6 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {6} \
    CONFIG.DIN_TO {6} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_6


  # Create instance: enable_slice_7, and set properties
  set enable_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_7 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {7} \
    CONFIG.DIN_WIDTH {16} \
  ] $enable_slice_7


  # Create instance: valid_slice_0, and set properties
  set valid_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {16} \
  ] $valid_slice_0


  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins adc_tpl_core/s_axi]

  # Create port connections
  connect_bd_net -net adc_dovf_1 [get_bd_pins adc_dovf] [get_bd_pins adc_tpl_core/adc_dovf]
  connect_bd_net -net adc_tpl_core_adc_data [get_bd_pins adc_tpl_core/adc_data] [get_bd_pins data_slice_0/Din] [get_bd_pins data_slice_1/Din] [get_bd_pins data_slice_2/Din] [get_bd_pins data_slice_3/Din] [get_bd_pins data_slice_4/Din] [get_bd_pins data_slice_5/Din] [get_bd_pins data_slice_6/Din] [get_bd_pins data_slice_7/Din]
  connect_bd_net -net adc_tpl_core_adc_valid [get_bd_pins adc_tpl_core/adc_valid] [get_bd_pins valid_slice_0/Din]
  connect_bd_net -net adc_tpl_core_enable [get_bd_pins adc_tpl_core/enable] [get_bd_pins enable_slice_0/Din] [get_bd_pins enable_slice_1/Din] [get_bd_pins enable_slice_2/Din] [get_bd_pins enable_slice_3/Din] [get_bd_pins enable_slice_4/Din] [get_bd_pins enable_slice_5/Din] [get_bd_pins enable_slice_6/Din] [get_bd_pins enable_slice_7/Din]
  connect_bd_net -net data_slice_0_Dout [get_bd_pins adc_data_0] [get_bd_pins data_slice_0/Dout]
  connect_bd_net -net data_slice_1_Dout [get_bd_pins adc_data_1] [get_bd_pins data_slice_1/Dout]
  connect_bd_net -net data_slice_2_Dout [get_bd_pins adc_data_2] [get_bd_pins data_slice_2/Dout]
  connect_bd_net -net data_slice_3_Dout [get_bd_pins adc_data_3] [get_bd_pins data_slice_3/Dout]
  connect_bd_net -net data_slice_4_Dout [get_bd_pins adc_data_4] [get_bd_pins data_slice_4/Dout]
  connect_bd_net -net data_slice_5_Dout [get_bd_pins adc_data_5] [get_bd_pins data_slice_5/Dout]
  connect_bd_net -net data_slice_6_Dout [get_bd_pins adc_data_6] [get_bd_pins data_slice_6/Dout]
  connect_bd_net -net data_slice_7_Dout [get_bd_pins adc_data_7] [get_bd_pins data_slice_7/Dout]
  connect_bd_net -net enable_slice_0_Dout [get_bd_pins adc_enable_0] [get_bd_pins enable_slice_0/Dout]
  connect_bd_net -net enable_slice_1_Dout [get_bd_pins adc_enable_1] [get_bd_pins enable_slice_1/Dout]
  connect_bd_net -net enable_slice_2_Dout [get_bd_pins adc_enable_2] [get_bd_pins enable_slice_2/Dout]
  connect_bd_net -net enable_slice_3_Dout [get_bd_pins adc_enable_3] [get_bd_pins enable_slice_3/Dout]
  connect_bd_net -net enable_slice_4_Dout [get_bd_pins adc_enable_4] [get_bd_pins enable_slice_4/Dout]
  connect_bd_net -net enable_slice_5_Dout [get_bd_pins adc_enable_5] [get_bd_pins enable_slice_5/Dout]
  connect_bd_net -net enable_slice_6_Dout [get_bd_pins adc_enable_6] [get_bd_pins enable_slice_6/Dout]
  connect_bd_net -net enable_slice_7_Dout [get_bd_pins adc_enable_7] [get_bd_pins enable_slice_7/Dout]
  connect_bd_net -net link_clk_1 [get_bd_pins link_clk] [get_bd_pins adc_tpl_core/link_clk]
  connect_bd_net -net link_data_1 [get_bd_pins link_data] [get_bd_pins adc_tpl_core/link_data]
  connect_bd_net -net link_sof_1 [get_bd_pins link_sof] [get_bd_pins adc_tpl_core/link_sof]
  connect_bd_net -net link_valid_1 [get_bd_pins link_valid] [get_bd_pins adc_tpl_core/link_valid]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins adc_tpl_core/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins adc_tpl_core/s_axi_aresetn]
  connect_bd_net -net valid_slice_0_Dout [get_bd_pins adc_valid_0] [get_bd_pins valid_slice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: axi_adrv_tx_jesd
proc create_hier_cell_axi_adrv_tx_jesd { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_axi_adrv_tx_jesd() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_data

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy7


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 adrv1_sync
  create_bd_pin -dir I -from 0 -to 0 adrv2_sync
  create_bd_pin -dir I -type clk device_clk
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I sysref

  # Create instance: sync, and set properties
  set sync [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sync ]

  # Create instance: tx, and set properties
  set tx [ create_bd_cell -type ip -vlnv analog.com:user:jesd204_tx:1.0 tx ]
  set_property -dict [list \
    CONFIG.LINK_MODE {1} \
    CONFIG.NUM_LANES {8} \
    CONFIG.NUM_LINKS {2} \
  ] $tx


  # Create instance: tx_axi, and set properties
  set tx_axi [ create_bd_cell -type ip -vlnv analog.com:user:axi_jesd204_tx:1.0 tx_axi ]
  set_property -dict [list \
    CONFIG.LINK_MODE {1} \
    CONFIG.NUM_LANES {8} \
    CONFIG.NUM_LINKS {2} \
  ] $tx_axi


  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins tx_axi/s_axi]
  connect_bd_intf_net -intf_net tx_axi_tx_cfg [get_bd_intf_pins tx/tx_cfg] [get_bd_intf_pins tx_axi/tx_cfg]
  connect_bd_intf_net -intf_net tx_axi_tx_ctrl [get_bd_intf_pins tx/tx_ctrl] [get_bd_intf_pins tx_axi/tx_ctrl]
  connect_bd_intf_net -intf_net tx_data_1 [get_bd_intf_pins tx_data] [get_bd_intf_pins tx/tx_data]
  connect_bd_intf_net -intf_net tx_tx_event [get_bd_intf_pins tx/tx_event] [get_bd_intf_pins tx_axi/tx_event]
  connect_bd_intf_net -intf_net tx_tx_ilas_config [get_bd_intf_pins tx/tx_ilas_config] [get_bd_intf_pins tx_axi/tx_ilas_config]
  connect_bd_intf_net -intf_net tx_tx_phy0 [get_bd_intf_pins tx_phy0] [get_bd_intf_pins tx/tx_phy0]
  connect_bd_intf_net -intf_net tx_tx_phy1 [get_bd_intf_pins tx_phy1] [get_bd_intf_pins tx/tx_phy1]
  connect_bd_intf_net -intf_net tx_tx_phy2 [get_bd_intf_pins tx_phy2] [get_bd_intf_pins tx/tx_phy2]
  connect_bd_intf_net -intf_net tx_tx_phy3 [get_bd_intf_pins tx_phy3] [get_bd_intf_pins tx/tx_phy3]
  connect_bd_intf_net -intf_net tx_tx_phy4 [get_bd_intf_pins tx_phy4] [get_bd_intf_pins tx/tx_phy4]
  connect_bd_intf_net -intf_net tx_tx_phy5 [get_bd_intf_pins tx_phy5] [get_bd_intf_pins tx/tx_phy5]
  connect_bd_intf_net -intf_net tx_tx_phy6 [get_bd_intf_pins tx_phy6] [get_bd_intf_pins tx/tx_phy6]
  connect_bd_intf_net -intf_net tx_tx_phy7 [get_bd_intf_pins tx_phy7] [get_bd_intf_pins tx/tx_phy7]
  connect_bd_intf_net -intf_net tx_tx_status [get_bd_intf_pins tx/tx_status] [get_bd_intf_pins tx_axi/tx_status]

  # Create port connections
  connect_bd_net -net adrv2_sync_1 [get_bd_pins adrv2_sync] [get_bd_pins sync/In1]
  connect_bd_net -net device_clk_1 [get_bd_pins device_clk] [get_bd_pins tx/device_clk] [get_bd_pins tx_axi/device_clk]
  connect_bd_net -net link_clk_1 [get_bd_pins link_clk] [get_bd_pins tx/clk] [get_bd_pins tx_axi/core_clk]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins tx_axi/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins tx_axi/s_axi_aresetn]
  connect_bd_net -net sync_1 [get_bd_pins adrv1_sync] [get_bd_pins sync/In0]
  connect_bd_net -net sysref_1 [get_bd_pins sysref] [get_bd_pins tx/sysref]
  connect_bd_net -net tx_axi_core_reset [get_bd_pins tx/reset] [get_bd_pins tx_axi/core_reset]
  connect_bd_net -net tx_axi_device_reset [get_bd_pins tx/device_reset] [get_bd_pins tx_axi/device_reset]
  connect_bd_net -net tx_axi_irq [get_bd_pins irq] [get_bd_pins tx_axi/irq]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins sync/dout] [get_bd_pins tx/sync]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: axi_adrv_rx_jesd
proc create_hier_cell_axi_adrv_rx_jesd { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_axi_adrv_rx_jesd() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 adrv1_rx_sync
  create_bd_pin -dir O -from 0 -to 0 adrv2_rx_sync
  create_bd_pin -dir I -type clk device_clk
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir O phy_en_char_align
  create_bd_pin -dir O -from 255 -to 0 rx_data_tdata
  create_bd_pin -dir O rx_data_tvalid
  create_bd_pin -dir O -from 3 -to 0 rx_eof
  create_bd_pin -dir O -from 3 -to 0 rx_sof
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I sysref

  # Create instance: lsb, and set properties
  set lsb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 lsb ]
  set_property CONFIG.DIN_WIDTH {2} $lsb


  # Create instance: msb, and set properties
  set msb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 msb ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {2} \
  ] $msb


  # Create instance: rx, and set properties
  set rx [ create_bd_cell -type ip -vlnv analog.com:user:jesd204_rx:1.0 rx ]
  set_property -dict [list \
    CONFIG.LINK_MODE {1} \
    CONFIG.NUM_LANES {8} \
    CONFIG.NUM_LINKS {2} \
  ] $rx


  # Create instance: rx_axi, and set properties
  set rx_axi [ create_bd_cell -type ip -vlnv analog.com:user:axi_jesd204_rx:1.0 rx_axi ]
  set_property -dict [list \
    CONFIG.LINK_MODE {1} \
    CONFIG.NUM_LANES {8} \
    CONFIG.NUM_LINKS {2} \
  ] $rx_axi


  # Create interface connections
  connect_bd_intf_net -intf_net rx_axi_rx_cfg [get_bd_intf_pins rx/rx_cfg] [get_bd_intf_pins rx_axi/rx_cfg]
  connect_bd_intf_net -intf_net rx_phy0_1 [get_bd_intf_pins rx_phy0] [get_bd_intf_pins rx/rx_phy0]
  connect_bd_intf_net -intf_net rx_phy1_1 [get_bd_intf_pins rx_phy1] [get_bd_intf_pins rx/rx_phy1]
  connect_bd_intf_net -intf_net rx_phy2_1 [get_bd_intf_pins rx_phy2] [get_bd_intf_pins rx/rx_phy2]
  connect_bd_intf_net -intf_net rx_phy3_1 [get_bd_intf_pins rx_phy3] [get_bd_intf_pins rx/rx_phy3]
  connect_bd_intf_net -intf_net rx_phy4_1 [get_bd_intf_pins rx_phy4] [get_bd_intf_pins rx/rx_phy4]
  connect_bd_intf_net -intf_net rx_phy5_1 [get_bd_intf_pins rx_phy5] [get_bd_intf_pins rx/rx_phy5]
  connect_bd_intf_net -intf_net rx_phy6_1 [get_bd_intf_pins rx_phy6] [get_bd_intf_pins rx/rx_phy6]
  connect_bd_intf_net -intf_net rx_phy7_1 [get_bd_intf_pins rx_phy7] [get_bd_intf_pins rx/rx_phy7]
  connect_bd_intf_net -intf_net rx_rx_event [get_bd_intf_pins rx/rx_event] [get_bd_intf_pins rx_axi/rx_event]
  connect_bd_intf_net -intf_net rx_rx_ilas_config [get_bd_intf_pins rx/rx_ilas_config] [get_bd_intf_pins rx_axi/rx_ilas_config]
  connect_bd_intf_net -intf_net rx_rx_status [get_bd_intf_pins rx/rx_status] [get_bd_intf_pins rx_axi/rx_status]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins rx_axi/s_axi]

  # Create port connections
  connect_bd_net -net device_clk_1 [get_bd_pins device_clk] [get_bd_pins rx/device_clk] [get_bd_pins rx_axi/device_clk]
  connect_bd_net -net link_clk_1 [get_bd_pins link_clk] [get_bd_pins rx/clk] [get_bd_pins rx_axi/core_clk]
  connect_bd_net -net rx_axi_core_reset [get_bd_pins rx/reset] [get_bd_pins rx_axi/core_reset]
  connect_bd_net -net rx_axi_device_reset [get_bd_pins rx/device_reset] [get_bd_pins rx_axi/device_reset]
  connect_bd_net -net rx_axi_irq [get_bd_pins irq] [get_bd_pins rx_axi/irq]
  connect_bd_net -net rx_phy_en_char_align [get_bd_pins phy_en_char_align] [get_bd_pins rx/phy_en_char_align]
  connect_bd_net -net rx_rx_data [get_bd_pins rx_data_tdata] [get_bd_pins rx/rx_data]
  connect_bd_net -net rx_rx_eof [get_bd_pins rx_eof] [get_bd_pins rx/rx_eof]
  connect_bd_net -net rx_rx_sof [get_bd_pins rx_sof] [get_bd_pins rx/rx_sof]
  connect_bd_net -net rx_rx_valid [get_bd_pins rx_data_tvalid] [get_bd_pins rx/rx_valid]
  connect_bd_net -net rx_sync [get_bd_pins lsb/Din] [get_bd_pins msb/Din] [get_bd_pins rx/sync]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins rx_axi/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins rx_axi/s_axi_aresetn]
  connect_bd_net -net sysref_1 [get_bd_pins sysref] [get_bd_pins rx/sysref]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins adrv1_rx_sync] [get_bd_pins lsb/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins adrv2_rx_sync] [get_bd_pins msb/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: SYS_ID
proc create_hier_cell_SYS_ID { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_SYS_ID() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_sysid_0, and set properties
  set axi_sysid_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_sysid:1.0 axi_sysid_0 ]
  set_property CONFIG.ROM_ADDR_BITS {9} $axi_sysid_0


  # Create instance: rom_sys_0, and set properties
  set rom_sys_0 [ create_bd_cell -type ip -vlnv analog.com:user:sysid_rom:1.0 rom_sys_0 ]
  set_property -dict [list \
    CONFIG.PATH_TO_FILE {/home/tesla/workspace/09.rru/hdl/projects/adrv9026/zcu102/mem_init_sys.txt} \
    CONFIG.ROM_ADDR_BITS {9} \
  ] $rom_sys_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M00_AXI [get_bd_intf_pins s_axi] [get_bd_intf_pins axi_sysid_0/s_axi]

  # Create port connections
  connect_bd_net -net axi_sysid_0_rom_addr [get_bd_pins axi_sysid_0/rom_addr] [get_bd_pins rom_sys_0/rom_addr]
  connect_bd_net -net rom_sys_0_rom_data [get_bd_pins axi_sysid_0/sys_rom_data] [get_bd_pins rom_sys_0/rom_data]
  connect_bd_net -net sys_cpu_clk [get_bd_pins clk] [get_bd_pins axi_sysid_0/s_axi_aclk] [get_bd_pins rom_sys_0/clk]
  connect_bd_net -net sys_cpu_resetn [get_bd_pins s_axi_aresetn] [get_bd_pins axi_sysid_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: RST_SUBSYSTEM
proc create_hier_cell_RST_SUBSYSTEM { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_RST_SUBSYSTEM() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk core_clk
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn2
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn3
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset2
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset3
  create_bd_pin -dir I -type clk slowest_sync_clk
  create_bd_pin -dir I -type clk slowest_sync_clk1
  create_bd_pin -dir I -type clk slowest_sync_clk2

  # Create instance: core_clk_rstgen, and set properties
  set core_clk_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 core_clk_rstgen ]

  # Create instance: sys_250m_rstgen, and set properties
  set sys_250m_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_250m_rstgen ]
  set_property CONFIG.C_EXT_RST_WIDTH {1} $sys_250m_rstgen


  # Create instance: sys_500m_rstgen, and set properties
  set sys_500m_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_500m_rstgen ]
  set_property CONFIG.C_EXT_RST_WIDTH {1} $sys_500m_rstgen


  # Create instance: sys_rstgen, and set properties
  set sys_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen ]
  set_property CONFIG.C_EXT_RST_WIDTH {1} $sys_rstgen


  # Create port connections
  connect_bd_net -net core_clk_1 [get_bd_pins core_clk] [get_bd_pins core_clk_rstgen/slowest_sync_clk]
  connect_bd_net -net core_clk_rstgen_peripheral_aresetn [get_bd_pins peripheral_aresetn3] [get_bd_pins core_clk_rstgen/peripheral_aresetn]
  connect_bd_net -net core_clk_rstgen_peripheral_reset [get_bd_pins peripheral_reset3] [get_bd_pins core_clk_rstgen/peripheral_reset]
  connect_bd_net -net sys_250m_clk [get_bd_pins slowest_sync_clk] [get_bd_pins sys_250m_rstgen/slowest_sync_clk]
  connect_bd_net -net sys_250m_reset [get_bd_pins peripheral_reset] [get_bd_pins sys_250m_rstgen/peripheral_reset]
  connect_bd_net -net sys_250m_resetn [get_bd_pins peripheral_aresetn] [get_bd_pins sys_250m_rstgen/peripheral_aresetn]
  connect_bd_net -net sys_500m_clk [get_bd_pins slowest_sync_clk2] [get_bd_pins sys_500m_rstgen/slowest_sync_clk]
  connect_bd_net -net sys_500m_reset [get_bd_pins peripheral_reset2] [get_bd_pins sys_500m_rstgen/peripheral_reset]
  connect_bd_net -net sys_500m_resetn [get_bd_pins peripheral_aresetn2] [get_bd_pins sys_500m_rstgen/peripheral_aresetn]
  connect_bd_net -net sys_cpu_clk [get_bd_pins slowest_sync_clk1] [get_bd_pins sys_rstgen/slowest_sync_clk]
  connect_bd_net -net sys_cpu_reset [get_bd_pins peripheral_reset1] [get_bd_pins sys_rstgen/peripheral_reset]
  connect_bd_net -net sys_cpu_resetn [get_bd_pins peripheral_aresetn1] [get_bd_pins core_clk_rstgen/ext_reset_in] [get_bd_pins sys_rstgen/peripheral_aresetn]
  connect_bd_net -net sys_ps8_pl_resetn0 [get_bd_pins ext_reset_in] [get_bd_pins sys_250m_rstgen/ext_reset_in] [get_bd_pins sys_500m_rstgen/ext_reset_in] [get_bd_pins sys_rstgen/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: PS
proc create_hier_cell_PS { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_PS() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M03_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M04_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M06_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M07_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M08_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI2


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 In2
  create_bd_pin -dir I -from 0 -to 0 In3
  create_bd_pin -dir I -from 0 -to 0 In5
  create_bd_pin -dir I -from 0 -to 0 In6
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst aresetn1
  create_bd_pin -dir O -from 0 -to 0 emio_spi0_ss_i_n
  create_bd_pin -dir I -from 94 -to 0 gpio_i
  create_bd_pin -dir O -from 94 -to 0 gpio_o
  create_bd_pin -dir O -from 94 -to 0 gpio_t
  create_bd_pin -dir O -type clk pl_clk0
  create_bd_pin -dir O -type clk pl_clk1
  create_bd_pin -dir O -type clk pl_clk2
  create_bd_pin -dir O -type rst pl_resetn0
  create_bd_pin -dir O -from 2 -to 0 spi0_csn
  create_bd_pin -dir I spi0_miso
  create_bd_pin -dir O spi0_mosi
  create_bd_pin -dir O spi0_sclk
  create_bd_pin -dir O -from 2 -to 0 spi1_csn
  create_bd_pin -dir I spi1_miso
  create_bd_pin -dir O spi1_mosi
  create_bd_pin -dir O spi1_sclk

  # Create instance: GND_1, and set properties
  set GND_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 GND_1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $GND_1


  # Create instance: VCC_1, and set properties
  set VCC_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 VCC_1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $VCC_1


  # Create instance: axi_cpu_interconnect, and set properties
  set axi_cpu_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_cpu_interconnect ]
  set_property -dict [list \
    CONFIG.NUM_MI {9} \
    CONFIG.NUM_SI {1} \
  ] $axi_cpu_interconnect


  # Create instance: axi_hp0_interconnect, and set properties
  set axi_hp0_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp0_interconnect ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_hp0_interconnect


  # Create instance: axi_hp2_interconnect, and set properties
  set axi_hp2_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp2_interconnect ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_hp2_interconnect


  # Create instance: axi_hp3_interconnect, and set properties
  set axi_hp3_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp3_interconnect ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_hp3_interconnect


  # Create instance: spi0_csn_concat, and set properties
  set spi0_csn_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 spi0_csn_concat ]
  set_property CONFIG.NUM_PORTS {3} $spi0_csn_concat


  # Create instance: spi1_csn_concat, and set properties
  set spi1_csn_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 spi1_csn_concat ]
  set_property CONFIG.NUM_PORTS {3} $spi1_csn_concat


  # Create instance: sys_concat_intc_0, and set properties
  set sys_concat_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc_0 ]
  set_property CONFIG.NUM_PORTS {8} $sys_concat_intc_0


  # Create instance: sys_concat_intc_1, and set properties
  set sys_concat_intc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc_1 ]
  set_property CONFIG.NUM_PORTS {8} $sys_concat_intc_1


  # Create instance: sys_ps8, and set properties
  set sys_ps8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.4 sys_ps8 ]
  set_property -dict [list \
    CONFIG.CAN0_BOARD_INTERFACE {custom} \
    CONFIG.CAN1_BOARD_INTERFACE {custom} \
    CONFIG.CSU_BOARD_INTERFACE {custom} \
    CONFIG.DP_BOARD_INTERFACE {custom} \
    CONFIG.GEM0_BOARD_INTERFACE {custom} \
    CONFIG.GEM1_BOARD_INTERFACE {custom} \
    CONFIG.GEM2_BOARD_INTERFACE {custom} \
    CONFIG.GEM3_BOARD_INTERFACE {custom} \
    CONFIG.GPIO_BOARD_INTERFACE {custom} \
    CONFIG.IIC0_BOARD_INTERFACE {custom} \
    CONFIG.IIC1_BOARD_INTERFACE {custom} \
    CONFIG.NAND_BOARD_INTERFACE {custom} \
    CONFIG.PCIE_BOARD_INTERFACE {custom} \
    CONFIG.PJTAG_BOARD_INTERFACE {custom} \
    CONFIG.PMU_BOARD_INTERFACE {custom} \
    CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
    CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
    CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
    CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {1} \
    CONFIG.PSU_IMPORT_BOARD_PRESET {} \
    CONFIG.PSU_MIO_0_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_0_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_0_SLEW {fast} \
    CONFIG.PSU_MIO_10_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_10_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_10_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_10_SLEW {fast} \
    CONFIG.PSU_MIO_11_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_11_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_11_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_11_SLEW {fast} \
    CONFIG.PSU_MIO_12_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_12_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_12_SLEW {fast} \
    CONFIG.PSU_MIO_13_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_13_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_13_POLARITY {Default} \
    CONFIG.PSU_MIO_13_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_13_SLEW {fast} \
    CONFIG.PSU_MIO_14_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_14_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_14_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_14_SLEW {fast} \
    CONFIG.PSU_MIO_15_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_15_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_15_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_15_SLEW {fast} \
    CONFIG.PSU_MIO_16_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_16_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_16_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_16_SLEW {fast} \
    CONFIG.PSU_MIO_17_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_17_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_17_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_17_SLEW {fast} \
    CONFIG.PSU_MIO_18_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_18_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_19_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_19_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_19_SLEW {fast} \
    CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_1_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_1_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_1_SLEW {fast} \
    CONFIG.PSU_MIO_20_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_20_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_20_SLEW {fast} \
    CONFIG.PSU_MIO_21_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_21_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_22_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_22_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_22_POLARITY {Default} \
    CONFIG.PSU_MIO_22_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_22_SLEW {fast} \
    CONFIG.PSU_MIO_23_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_23_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_23_POLARITY {Default} \
    CONFIG.PSU_MIO_23_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_23_SLEW {fast} \
    CONFIG.PSU_MIO_24_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_24_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_24_SLEW {fast} \
    CONFIG.PSU_MIO_25_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_25_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_26_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_26_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_26_POLARITY {Default} \
    CONFIG.PSU_MIO_26_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_26_SLEW {fast} \
    CONFIG.PSU_MIO_27_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_27_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_27_SLEW {fast} \
    CONFIG.PSU_MIO_28_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_28_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_29_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_29_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_29_SLEW {fast} \
    CONFIG.PSU_MIO_2_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_2_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_2_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_2_SLEW {fast} \
    CONFIG.PSU_MIO_30_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_30_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_31_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_31_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_31_SLEW {fast} \
    CONFIG.PSU_MIO_32_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_32_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_32_SLEW {fast} \
    CONFIG.PSU_MIO_33_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_33_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_33_SLEW {fast} \
    CONFIG.PSU_MIO_34_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_34_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_34_SLEW {fast} \
    CONFIG.PSU_MIO_35_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_35_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_35_SLEW {fast} \
    CONFIG.PSU_MIO_36_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_36_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_36_SLEW {fast} \
    CONFIG.PSU_MIO_37_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_37_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_37_SLEW {fast} \
    CONFIG.PSU_MIO_38_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_38_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_38_POLARITY {Default} \
    CONFIG.PSU_MIO_38_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_38_SLEW {fast} \
    CONFIG.PSU_MIO_39_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_39_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_39_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_39_SLEW {fast} \
    CONFIG.PSU_MIO_3_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_3_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_3_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_3_SLEW {fast} \
    CONFIG.PSU_MIO_40_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_40_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_40_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_40_SLEW {fast} \
    CONFIG.PSU_MIO_41_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_41_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_41_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_41_SLEW {fast} \
    CONFIG.PSU_MIO_42_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_42_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_42_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_42_SLEW {fast} \
    CONFIG.PSU_MIO_43_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_43_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_43_POLARITY {Default} \
    CONFIG.PSU_MIO_43_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_43_SLEW {fast} \
    CONFIG.PSU_MIO_44_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_44_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_45_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_45_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_46_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_46_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_46_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_46_SLEW {fast} \
    CONFIG.PSU_MIO_47_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_47_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_47_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_47_SLEW {fast} \
    CONFIG.PSU_MIO_48_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_48_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_48_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_48_SLEW {fast} \
    CONFIG.PSU_MIO_49_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_49_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_49_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_49_SLEW {fast} \
    CONFIG.PSU_MIO_4_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_4_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_4_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_4_SLEW {fast} \
    CONFIG.PSU_MIO_50_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_50_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_50_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_50_SLEW {fast} \
    CONFIG.PSU_MIO_51_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_51_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_51_SLEW {fast} \
    CONFIG.PSU_MIO_52_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_52_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_53_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_53_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_54_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_54_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_54_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_54_SLEW {fast} \
    CONFIG.PSU_MIO_55_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_55_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_56_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_56_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_56_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_56_SLEW {fast} \
    CONFIG.PSU_MIO_57_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_57_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_57_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_57_SLEW {fast} \
    CONFIG.PSU_MIO_58_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_58_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_58_SLEW {fast} \
    CONFIG.PSU_MIO_59_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_59_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_59_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_59_SLEW {fast} \
    CONFIG.PSU_MIO_5_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_5_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_5_SLEW {fast} \
    CONFIG.PSU_MIO_60_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_60_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_60_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_60_SLEW {fast} \
    CONFIG.PSU_MIO_61_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_61_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_61_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_61_SLEW {fast} \
    CONFIG.PSU_MIO_62_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_62_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_62_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_62_SLEW {fast} \
    CONFIG.PSU_MIO_63_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_63_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_63_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_63_SLEW {fast} \
    CONFIG.PSU_MIO_64_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_64_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_64_SLEW {fast} \
    CONFIG.PSU_MIO_65_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_65_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_65_SLEW {fast} \
    CONFIG.PSU_MIO_66_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_66_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_66_SLEW {fast} \
    CONFIG.PSU_MIO_67_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_67_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_67_SLEW {fast} \
    CONFIG.PSU_MIO_68_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_68_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_68_SLEW {fast} \
    CONFIG.PSU_MIO_69_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_69_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_69_SLEW {fast} \
    CONFIG.PSU_MIO_6_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_6_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_6_SLEW {fast} \
    CONFIG.PSU_MIO_70_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_70_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_71_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_71_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_72_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_72_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_73_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_73_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_74_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_74_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_75_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_75_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_76_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_76_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_76_SLEW {fast} \
    CONFIG.PSU_MIO_77_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_77_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_77_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_77_SLEW {fast} \
    CONFIG.PSU_MIO_7_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_7_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_7_SLEW {fast} \
    CONFIG.PSU_MIO_8_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_8_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_8_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_8_SLEW {fast} \
    CONFIG.PSU_MIO_9_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_9_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_9_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_9_SLEW {fast} \
    CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad\
SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#UART 1#UART 1#GPIO0 MIO#GPIO0 MIO#CAN 1#CAN 1#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#PCIE#PMU GPO 0#PMU GPO 1#PMU GPO 2#PMU GPO 3#PMU\
GPO 4#PMU GPO 5#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem\
3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
    CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#txd#rxd#gpio0[22]#gpio0[23]#phy_tx#phy_rx#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#reset_n#gpo[0]#gpo[1]#gpo[2]#gpo[3]#gpo[4]#gpo[5]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#sdio1_wp#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out}\
\
    CONFIG.PSU_PERIPHERAL_BOARD_PRESET {} \
    CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {8} \
    CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
    CONFIG.PSU_SMC_CYCLE_T0 {NA} \
    CONFIG.PSU_SMC_CYCLE_T1 {NA} \
    CONFIG.PSU_SMC_CYCLE_T2 {NA} \
    CONFIG.PSU_SMC_CYCLE_T3 {NA} \
    CONFIG.PSU_SMC_CYCLE_T4 {NA} \
    CONFIG.PSU_SMC_CYCLE_T5 {NA} \
    CONFIG.PSU_SMC_CYCLE_T6 {NA} \
    CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
    CONFIG.PSU_VALUE_SILVERSION {3} \
    CONFIG.PSU__ACPU0__POWER__ON {1} \
    CONFIG.PSU__ACPU1__POWER__ON {1} \
    CONFIG.PSU__ACPU2__POWER__ON {1} \
    CONFIG.PSU__ACPU3__POWER__ON {1} \
    CONFIG.PSU__ACTUAL__IP {1} \
    CONFIG.PSU__ACT_DDR_FREQ_MHZ {1050.000000} \
    CONFIG.PSU__AUX_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__CAN0_LOOP_CAN1__ENABLE {0} \
    CONFIG.PSU__CAN0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
    CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 24 .. 25} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1200.000000} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__ACPU__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI0_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI1_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI2_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI3_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI4_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI5_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__APLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__APM_CTRL__ACT_FREQMHZ {1} \
    CONFIG.PSU__CRF_APB__APM_CTRL__DIVISOR0 {1} \
    CONFIG.PSU__CRF_APB__APM_CTRL__FREQMHZ {1} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__ACT_FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {525.000000} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {25.000000} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__FREQMHZ {25} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.666666} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__FREQMHZ {27} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {300.000000} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__FREQMHZ {300} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__ACT_FREQMHZ {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__DIVISOR0 {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__FREQMHZ {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__SRCSEL {NA} \
    CONFIG.PSU__CRF_APB__GTGREF0__ENABLE {NA} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {525.000000} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__ACT_FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__AFI6__ENABLE {0} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {50.000000} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__FREQMHZ {50} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__ACT_FREQMHZ {180} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__DIVISOR0 {3} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__SRCSEL {SysOsc} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__ACT_FREQMHZ {1000} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__DIVISOR0 {6} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__FREQMHZ {1000} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1500.000000} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__FREQMHZ {1500} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {125.000000} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__ACT_FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__DIVISOR0 {3} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.500000} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL3_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {125.000000} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.500000} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {20.000000} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
    CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
    CONFIG.PSU__CSU__CSU_TAMPER_0__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_10__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_11__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_12__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_1__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_2__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_3__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_4__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_5__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_6__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_7__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_8__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_9__ENABLE {0} \
    CONFIG.PSU__CSU__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__DDRC__AL {0} \
    CONFIG.PSU__DDRC__BG_ADDR_COUNT {2} \
    CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
    CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
    CONFIG.PSU__DDRC__CL {15} \
    CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
    CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
    CONFIG.PSU__DDRC__CWL {14} \
    CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
    CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
    CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
    CONFIG.PSU__DDRC__DDR4_MAXPWR_SAVING_EN {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
    CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
    CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
    CONFIG.PSU__DDRC__DRAM_WIDTH {8 Bits} \
    CONFIG.PSU__DDRC__ECC {Disabled} \
    CONFIG.PSU__DDRC__ECC_SCRUB {0} \
    CONFIG.PSU__DDRC__ENABLE {1} \
    CONFIG.PSU__DDRC__ENABLE_2T_TIMING {0} \
    CONFIG.PSU__DDRC__ENABLE_DP_SWITCH {0} \
    CONFIG.PSU__DDRC__EN_2ND_CLK {0} \
    CONFIG.PSU__DDRC__FGRM {1X} \
    CONFIG.PSU__DDRC__FREQ_MHZ {1} \
    CONFIG.PSU__DDRC__LPDDR3_DUALRANK_SDP {0} \
    CONFIG.PSU__DDRC__LP_ASR {manual normal} \
    CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
    CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
    CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
    CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
    CONFIG.PSU__DDRC__PLL_BYPASS {0} \
    CONFIG.PSU__DDRC__PWR_DOWN_EN {0} \
    CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
    CONFIG.PSU__DDRC__RD_DQS_CENTER {0} \
    CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
    CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
    CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
    CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
    CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
    CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
    CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
    CONFIG.PSU__DDRC__T_FAW {30.0} \
    CONFIG.PSU__DDRC__T_RAS_MIN {33} \
    CONFIG.PSU__DDRC__T_RC {47.06} \
    CONFIG.PSU__DDRC__T_RCD {15} \
    CONFIG.PSU__DDRC__T_RP {15} \
    CONFIG.PSU__DDRC__VIDEO_BUFFER_SIZE {0} \
    CONFIG.PSU__DDRC__VREF {1} \
    CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
    CONFIG.PSU__DDR_QOS_ENABLE {0} \
    CONFIG.PSU__DDR_QOS_HP0_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP0_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP1_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP1_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP2_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP2_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP3_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP3_WRQOS {} \
    CONFIG.PSU__DDR_SW_REFRESH_ENABLED {1} \
    CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
    CONFIG.PSU__DEVICE_TYPE {EG} \
    CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
    CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
    CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {0} \
    CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DLL__ISUSED {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
    CONFIG.PSU__DP__LANE_SEL {Single Lower} \
    CONFIG.PSU__DP__REF_CLK_FREQ {27} \
    CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3} \
    CONFIG.PSU__ENABLE__DDR__REFRESH__SIGNALS {0} \
    CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
    CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
    CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
    CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
    CONFIG.PSU__ENET3__PTP__ENABLE {0} \
    CONFIG.PSU__ENET3__TSU__ENABLE {0} \
    CONFIG.PSU__EN_AXI_STATUS_PORTS {0} \
    CONFIG.PSU__EN_EMIO_TRACE {0} \
    CONFIG.PSU__EP__IP {0} \
    CONFIG.PSU__EXPAND__CORESIGHT {0} \
    CONFIG.PSU__EXPAND__FPD_SLAVES {0} \
    CONFIG.PSU__EXPAND__GIC {0} \
    CONFIG.PSU__EXPAND__LOWER_LPS_SLAVES {0} \
    CONFIG.PSU__EXPAND__UPPER_LPS_SLAVES {0} \
    CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
    CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__FPGA_PL1_ENABLE {1} \
    CONFIG.PSU__FPGA_PL2_ENABLE {1} \
    CONFIG.PSU__FPGA_PL3_ENABLE {0} \
    CONFIG.PSU__FP__POWER__ON {1} \
    CONFIG.PSU__FTM__CTI_IN_0 {0} \
    CONFIG.PSU__FTM__CTI_IN_1 {0} \
    CONFIG.PSU__FTM__CTI_IN_2 {0} \
    CONFIG.PSU__FTM__CTI_IN_3 {0} \
    CONFIG.PSU__FTM__CTI_OUT_0 {0} \
    CONFIG.PSU__FTM__CTI_OUT_1 {0} \
    CONFIG.PSU__FTM__CTI_OUT_2 {0} \
    CONFIG.PSU__FTM__CTI_OUT_3 {0} \
    CONFIG.PSU__FTM__GPI {0} \
    CONFIG.PSU__FTM__GPO {0} \
    CONFIG.PSU__GEM3_COHERENCY {0} \
    CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__GEM__TSU__ENABLE {0} \
    CONFIG.PSU__GEN_IPI_0__MASTER {APU} \
    CONFIG.PSU__GEN_IPI_10__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_1__MASTER {RPU0} \
    CONFIG.PSU__GEN_IPI_2__MASTER {RPU1} \
    CONFIG.PSU__GEN_IPI_3__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_4__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_5__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_6__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_7__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_8__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_9__MASTER {NONE} \
    CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
    CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
    CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__GPIO_EMIO_WIDTH {95} \
    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {95} \
    CONFIG.PSU__GPIO_EMIO__WIDTH {[94:0]} \
    CONFIG.PSU__GPU_PP0__POWER__ON {1} \
    CONFIG.PSU__GPU_PP1__POWER__ON {1} \
    CONFIG.PSU__GT_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__GT__LINK_SPEED {HBR} \
    CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
    CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
    CONFIG.PSU__HPM0_FPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM0_FPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__HPM0_LPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM0_LPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__HPM1_FPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM1_FPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__I2C0_LOOP_I2C1__ENABLE {0} \
    CONFIG.PSU__I2C0__GRP_INT__ENABLE {0} \
    CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
    CONFIG.PSU__I2C1__GRP_INT__ENABLE {0} \
    CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IRQ_P2F_ADMA_CHAN__INT {0} \
    CONFIG.PSU__IRQ_P2F_AIB_AXI__INT {0} \
    CONFIG.PSU__IRQ_P2F_AMS__INT {0} \
    CONFIG.PSU__IRQ_P2F_APM_FPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_COMM__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_CPUMNT__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_CTI__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_EXTERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_L2ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_PMU__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_REGS__INT {0} \
    CONFIG.PSU__IRQ_P2F_ATB_LPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_CAN1__INT {0} \
    CONFIG.PSU__IRQ_P2F_CLKMON__INT {0} \
    CONFIG.PSU__IRQ_P2F_CSUPMU_WDT__INT {0} \
    CONFIG.PSU__IRQ_P2F_DDR_SS__INT {0} \
    CONFIG.PSU__IRQ_P2F_DPDMA__INT {0} \
    CONFIG.PSU__IRQ_P2F_DPORT__INT {0} \
    CONFIG.PSU__IRQ_P2F_EFUSE__INT {0} \
    CONFIG.PSU__IRQ_P2F_ENT3_WAKEUP__INT {0} \
    CONFIG.PSU__IRQ_P2F_ENT3__INT {0} \
    CONFIG.PSU__IRQ_P2F_FPD_APB__INT {0} \
    CONFIG.PSU__IRQ_P2F_FPD_ATB_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_FP_WDT__INT {0} \
    CONFIG.PSU__IRQ_P2F_GDMA_CHAN__INT {0} \
    CONFIG.PSU__IRQ_P2F_GPIO__INT {0} \
    CONFIG.PSU__IRQ_P2F_GPU__INT {0} \
    CONFIG.PSU__IRQ_P2F_I2C0__INT {0} \
    CONFIG.PSU__IRQ_P2F_I2C1__INT {0} \
    CONFIG.PSU__IRQ_P2F_LPD_APB__INT {0} \
    CONFIG.PSU__IRQ_P2F_LPD_APM__INT {0} \
    CONFIG.PSU__IRQ_P2F_LP_WDT__INT {0} \
    CONFIG.PSU__IRQ_P2F_OCM_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_DMA__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_LEGACY__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_MSC__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_MSI__INT {0} \
    CONFIG.PSU__IRQ_P2F_PL_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_QSPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_R5_CORE0_ECC_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_R5_CORE1_ECC_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_RPU_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_RPU_PERMON__INT {0} \
    CONFIG.PSU__IRQ_P2F_RTC_ALARM__INT {0} \
    CONFIG.PSU__IRQ_P2F_RTC_SECONDS__INT {0} \
    CONFIG.PSU__IRQ_P2F_SATA__INT {0} \
    CONFIG.PSU__IRQ_P2F_SDIO1_WAKE__INT {0} \
    CONFIG.PSU__IRQ_P2F_SDIO1__INT {0} \
    CONFIG.PSU__IRQ_P2F_SPI0__INT {0} \
    CONFIG.PSU__IRQ_P2F_SPI1__INT {0} \
    CONFIG.PSU__IRQ_P2F_TTC0__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_TTC0__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_TTC0__INT2 {0} \
    CONFIG.PSU__IRQ_P2F_TTC1__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_TTC1__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_TTC1__INT2 {0} \
    CONFIG.PSU__IRQ_P2F_TTC2__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_TTC2__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_TTC2__INT2 {0} \
    CONFIG.PSU__IRQ_P2F_TTC3__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_TTC3__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_TTC3__INT2 {0} \
    CONFIG.PSU__IRQ_P2F_UART0__INT {0} \
    CONFIG.PSU__IRQ_P2F_UART1__INT {0} \
    CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_OTG__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_OTG__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_PMU_WAKEUP__INT {0} \
    CONFIG.PSU__IRQ_P2F_XMPU_FPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_XMPU_LPD__INT {0} \
    CONFIG.PSU__IRQ_P2F__INTF_FPD_SMMU__INT {0} \
    CONFIG.PSU__IRQ_P2F__INTF_PPD_CCI__INT {0} \
    CONFIG.PSU__L2_BANK0__POWER__ON {1} \
    CONFIG.PSU__LPDMA0_COHERENCY {0} \
    CONFIG.PSU__LPDMA1_COHERENCY {0} \
    CONFIG.PSU__LPDMA2_COHERENCY {0} \
    CONFIG.PSU__LPDMA3_COHERENCY {0} \
    CONFIG.PSU__LPDMA4_COHERENCY {0} \
    CONFIG.PSU__LPDMA5_COHERENCY {0} \
    CONFIG.PSU__LPDMA6_COHERENCY {0} \
    CONFIG.PSU__LPDMA7_COHERENCY {0} \
    CONFIG.PSU__LPD_SLCR__CSUPMU_WDT_CLK_SEL__SELECT {APB} \
    CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
    CONFIG.PSU__M_AXI_GP0_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__M_AXI_GP1_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__M_AXI_GP2_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__NAND__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__NAND__READY_BUSY__ENABLE {0} \
    CONFIG.PSU__NUM_FABRIC_RESETS {1} \
    CONFIG.PSU__OCM_BANK0__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK1__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK2__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK3__POWER__ON {1} \
    CONFIG.PSU__OVERRIDE_HPX_QOS {0} \
    CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
    CONFIG.PSU__PCIE__ACS_VIOLAION {0} \
    CONFIG.PSU__PCIE__AER_CAPABILITY {0} \
    CONFIG.PSU__PCIE__BAR0_ENABLE {0} \
    CONFIG.PSU__PCIE__BAR0_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR1_ENABLE {0} \
    CONFIG.PSU__PCIE__BAR1_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR2_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR3_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR4_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR5_VAL {0x0} \
    CONFIG.PSU__PCIE__CLASS_CODE_BASE {0x06} \
    CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {0x0} \
    CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x4} \
    CONFIG.PSU__PCIE__CLASS_CODE_VALUE {0x60400} \
    CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {1} \
    CONFIG.PSU__PCIE__DEVICE_ID {0xD021} \
    CONFIG.PSU__PCIE__DEVICE_PORT_TYPE {Root Port} \
    CONFIG.PSU__PCIE__EROM_ENABLE {0} \
    CONFIG.PSU__PCIE__EROM_VAL {0x0} \
    CONFIG.PSU__PCIE__INTX_GENERATION {0} \
    CONFIG.PSU__PCIE__LANE0__ENABLE {1} \
    CONFIG.PSU__PCIE__LANE0__IO {GT Lane0} \
    CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
    CONFIG.PSU__PCIE__LANE2__ENABLE {0} \
    CONFIG.PSU__PCIE__LANE3__ENABLE {0} \
    CONFIG.PSU__PCIE__LINK_SPEED {5.0 Gb/s} \
    CONFIG.PSU__PCIE__MAXIMUM_LINK_WIDTH {x1} \
    CONFIG.PSU__PCIE__MAX_PAYLOAD_SIZE {256 bytes} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {0} \
    CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {1} \
    CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO {MIO 31} \
    CONFIG.PSU__PCIE__REF_CLK_FREQ {100} \
    CONFIG.PSU__PCIE__REF_CLK_SEL {Ref Clk0} \
    CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
    CONFIG.PSU__PCIE__REVISION_ID {0x0} \
    CONFIG.PSU__PCIE__SUBSYSTEM_ID {0x7} \
    CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {0x10EE} \
    CONFIG.PSU__PCIE__VENDOR_ID {0x10EE} \
    CONFIG.PSU__PJTAG__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__PL_CLK0_BUF {TRUE} \
    CONFIG.PSU__PL_CLK1_BUF {TRUE} \
    CONFIG.PSU__PL_CLK2_BUF {TRUE} \
    CONFIG.PSU__PL__POWER__ON {1} \
    CONFIG.PSU__PMU_COHERENCY {0} \
    CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
    CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
    CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
    CONFIG.PSU__PMU__GPI0__ENABLE {0} \
    CONFIG.PSU__PMU__GPI1__ENABLE {0} \
    CONFIG.PSU__PMU__GPI2__ENABLE {0} \
    CONFIG.PSU__PMU__GPI3__ENABLE {0} \
    CONFIG.PSU__PMU__GPI4__ENABLE {0} \
    CONFIG.PSU__PMU__GPI5__ENABLE {0} \
    CONFIG.PSU__PMU__GPO0__ENABLE {1} \
    CONFIG.PSU__PMU__GPO0__IO {MIO 32} \
    CONFIG.PSU__PMU__GPO1__ENABLE {1} \
    CONFIG.PSU__PMU__GPO1__IO {MIO 33} \
    CONFIG.PSU__PMU__GPO2__ENABLE {1} \
    CONFIG.PSU__PMU__GPO2__IO {MIO 34} \
    CONFIG.PSU__PMU__GPO2__POLARITY {high} \
    CONFIG.PSU__PMU__GPO3__ENABLE {1} \
    CONFIG.PSU__PMU__GPO3__IO {MIO 35} \
    CONFIG.PSU__PMU__GPO3__POLARITY {low} \
    CONFIG.PSU__PMU__GPO4__ENABLE {1} \
    CONFIG.PSU__PMU__GPO4__IO {MIO 36} \
    CONFIG.PSU__PMU__GPO4__POLARITY {low} \
    CONFIG.PSU__PMU__GPO5__ENABLE {1} \
    CONFIG.PSU__PMU__GPO5__IO {MIO 37} \
    CONFIG.PSU__PMU__GPO5__POLARITY {low} \
    CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
    CONFIG.PSU__PRESET_APPLIED {1} \
    CONFIG.PSU__PROTECTION__DDR_SEGMENTS {NONE} \
    CONFIG.PSU__PROTECTION__ENABLE {0} \
    CONFIG.PSU__PROTECTION__FPD_SEGMENTS {SA:0xFD1A0000; SIZE:1280; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware |  SA:0xFD000000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware |  SA:0xFD010000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware |  SA:0xFD020000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU\
Firmware |  SA:0xFD030000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware |  SA:0xFD040000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware\
|  SA:0xFD050000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware |  SA:0xFD610000; SIZE:512; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware\
|  SA:0xFD5D0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware | SA:0xFD1A0000 ; SIZE:1280; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem}\
\
    CONFIG.PSU__PROTECTION__LPD_SEGMENTS {SA:0xFF980000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF5E0000; SIZE:2560; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware| SA:0xFFCC0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF180000; SIZE:768; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU\
Firmware| SA:0xFF410000; SIZE:640; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFFA70000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|\
SA:0xFF9A0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|SA:0xFF5E0000 ; SIZE:2560; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFFCC0000\
; SIZE:64; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF180000 ; SIZE:768; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF9A0000\
; SIZE:64; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem} \
    CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;1|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1}\
\
    CONFIG.PSU__PROTECTION__MASTERS_TZ {GEM0:NonSecure|SD1:NonSecure|GEM2:NonSecure|GEM1:NonSecure|GEM3:NonSecure|PCIe:NonSecure|DP:NonSecure|NAND:NonSecure|GPU:NonSecure|USB1:NonSecure|USB0:NonSecure|LDMA:NonSecure|FDMA:NonSecure|QSPI:NonSecure|SD0:NonSecure}\
\
    CONFIG.PSU__PROTECTION__OCM_SEGMENTS {NONE} \
    CONFIG.PSU__PROTECTION__PRESUBSYSTEMS {NONE} \
    CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;1|LPD;SPI0;FF040000;FF04FFFF;1|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;1|FPD;PCIE_LOW;E0000000;EFFFFFFF;1|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;1|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;1|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;1|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;1|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display\
Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;1|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1}\
\
    CONFIG.PSU__PROTECTION__SUBSYSTEMS {PMU Firmware:PMU|Secure Subsystem:} \
    CONFIG.PSU__PSS_ALT_REF_CLK__ENABLE {0} \
    CONFIG.PSU__PSS_ALT_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333333333} \
    CONFIG.PSU__QSPI_COHERENCY {0} \
    CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
    CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
    CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
    CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
    CONFIG.PSU__REPORT__DBGLOG {0} \
    CONFIG.PSU__RPU_COHERENCY {0} \
    CONFIG.PSU__RPU__POWER__ON {1} \
    CONFIG.PSU__SATA__LANE0__ENABLE {0} \
    CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
    CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1} \
    CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
    CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
    CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
    CONFIG.PSU__SD0__CLK_100_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD0__CLK_200_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD0__CLK_50_DDR_ITAP_DLY {0x3D} \
    CONFIG.PSU__SD0__CLK_50_DDR_OTAP_DLY {0x4} \
    CONFIG.PSU__SD0__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD0__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SD0__RESET__ENABLE {0} \
    CONFIG.PSU__SD1_COHERENCY {0} \
    CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__SD1__CLK_100_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_200_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_50_DDR_ITAP_DLY {0x3D} \
    CONFIG.PSU__SD1__CLK_50_DDR_OTAP_DLY {0x4} \
    CONFIG.PSU__SD1__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD1__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
    CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
    CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
    CONFIG.PSU__SD1__GRP_WP__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_WP__IO {MIO 44} \
    CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
    CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
    CONFIG.PSU__SPI0_LOOP_SPI1__ENABLE {0} \
    CONFIG.PSU__SPI0__GRP_SS0__IO {EMIO} \
    CONFIG.PSU__SPI0__GRP_SS1__ENABLE {1} \
    CONFIG.PSU__SPI0__GRP_SS1__IO {EMIO} \
    CONFIG.PSU__SPI0__GRP_SS2__ENABLE {1} \
    CONFIG.PSU__SPI0__GRP_SS2__IO {EMIO} \
    CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SPI0__PERIPHERAL__IO {EMIO} \
    CONFIG.PSU__SPI1__GRP_SS0__IO {EMIO} \
    CONFIG.PSU__SPI1__GRP_SS1__ENABLE {1} \
    CONFIG.PSU__SPI1__GRP_SS1__IO {EMIO} \
    CONFIG.PSU__SPI1__GRP_SS2__ENABLE {1} \
    CONFIG.PSU__SPI1__GRP_SS2__IO {EMIO} \
    CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SPI1__PERIPHERAL__IO {EMIO} \
    CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
    CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SWDT0__PERIPHERAL__IO {NA} \
    CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
    CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
    CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SWDT1__PERIPHERAL__IO {NA} \
    CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
    CONFIG.PSU__TCM0A__POWER__ON {1} \
    CONFIG.PSU__TCM0B__POWER__ON {1} \
    CONFIG.PSU__TCM1A__POWER__ON {1} \
    CONFIG.PSU__TCM1B__POWER__ON {1} \
    CONFIG.PSU__TESTSCAN__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TRACE__INTERNAL_WIDTH {32} \
    CONFIG.PSU__TRACE__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TRISTATE__INVERTED {1} \
    CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
    CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC0__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC1__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC2__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC3__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__UART0_LOOP_UART1__ENABLE {0} \
    CONFIG.PSU__UART0__BAUD_RATE {115200} \
    CONFIG.PSU__UART0__MODEM__ENABLE {0} \
    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
    CONFIG.PSU__UART1__BAUD_RATE {115200} \
    CONFIG.PSU__UART1__MODEM__ENABLE {0} \
    CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
    CONFIG.PSU__USB0_COHERENCY {0} \
    CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
    CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
    CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
    CONFIG.PSU__USB1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
    CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
    CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
    CONFIG.PSU__USE_DIFF_RW_CLK_GP2 {0} \
    CONFIG.PSU__USE_DIFF_RW_CLK_GP4 {0} \
    CONFIG.PSU__USE_DIFF_RW_CLK_GP5 {0} \
    CONFIG.PSU__USE__ADMA {0} \
    CONFIG.PSU__USE__APU_LEGACY_INTERRUPT {0} \
    CONFIG.PSU__USE__AUDIO {0} \
    CONFIG.PSU__USE__CLK {0} \
    CONFIG.PSU__USE__CLK0 {0} \
    CONFIG.PSU__USE__CLK1 {0} \
    CONFIG.PSU__USE__CLK2 {0} \
    CONFIG.PSU__USE__CLK3 {0} \
    CONFIG.PSU__USE__CROSS_TRIGGER {0} \
    CONFIG.PSU__USE__DDR_INTF_REQUESTED {0} \
    CONFIG.PSU__USE__DEBUG__TEST {0} \
    CONFIG.PSU__USE__EVENT_RPU {0} \
    CONFIG.PSU__USE__FABRIC__RST {1} \
    CONFIG.PSU__USE__FTM {0} \
    CONFIG.PSU__USE__GDMA {0} \
    CONFIG.PSU__USE__IRQ {0} \
    CONFIG.PSU__USE__IRQ0 {1} \
    CONFIG.PSU__USE__IRQ1 {1} \
    CONFIG.PSU__USE__M_AXI_GP0 {0} \
    CONFIG.PSU__USE__M_AXI_GP1 {0} \
    CONFIG.PSU__USE__M_AXI_GP2 {1} \
    CONFIG.PSU__USE__PROC_EVENT_BUS {0} \
    CONFIG.PSU__USE__RPU_LEGACY_INTERRUPT {0} \
    CONFIG.PSU__USE__RST0 {0} \
    CONFIG.PSU__USE__RST1 {0} \
    CONFIG.PSU__USE__RST2 {0} \
    CONFIG.PSU__USE__RST3 {0} \
    CONFIG.PSU__USE__RTC {0} \
    CONFIG.PSU__USE__STM {0} \
    CONFIG.PSU__USE__S_AXI_ACE {0} \
    CONFIG.PSU__USE__S_AXI_ACP {0} \
    CONFIG.PSU__USE__S_AXI_GP0 {0} \
    CONFIG.PSU__USE__S_AXI_GP1 {0} \
    CONFIG.PSU__USE__S_AXI_GP2 {1} \
    CONFIG.PSU__USE__S_AXI_GP3 {0} \
    CONFIG.PSU__USE__S_AXI_GP4 {1} \
    CONFIG.PSU__USE__S_AXI_GP5 {1} \
    CONFIG.PSU__USE__S_AXI_GP6 {0} \
    CONFIG.PSU__USE__USB3_0_HUB {0} \
    CONFIG.PSU__USE__USB3_1_HUB {0} \
    CONFIG.PSU__USE__VIDEO {0} \
    CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0} \
    CONFIG.PSU__VIDEO_REF_CLK__FREQMHZ {33.333} \
    CONFIG.QSPI_BOARD_INTERFACE {custom} \
    CONFIG.SATA_BOARD_INTERFACE {custom} \
    CONFIG.SD0_BOARD_INTERFACE {custom} \
    CONFIG.SD1_BOARD_INTERFACE {custom} \
    CONFIG.SPI0_BOARD_INTERFACE {custom} \
    CONFIG.SPI1_BOARD_INTERFACE {custom} \
    CONFIG.SUBPRESET1 {Custom} \
    CONFIG.SUBPRESET2 {Custom} \
    CONFIG.SWDT0_BOARD_INTERFACE {custom} \
    CONFIG.SWDT1_BOARD_INTERFACE {custom} \
    CONFIG.TRACE_BOARD_INTERFACE {custom} \
    CONFIG.TTC0_BOARD_INTERFACE {custom} \
    CONFIG.TTC1_BOARD_INTERFACE {custom} \
    CONFIG.TTC2_BOARD_INTERFACE {custom} \
    CONFIG.TTC3_BOARD_INTERFACE {custom} \
    CONFIG.UART0_BOARD_INTERFACE {custom} \
    CONFIG.UART1_BOARD_INTERFACE {custom} \
    CONFIG.USB0_BOARD_INTERFACE {custom} \
    CONFIG.USB1_BOARD_INTERFACE {custom} \
  ] $sys_ps8


  # Create interface connections
  connect_bd_intf_net -intf_net axi_adrv9026_rx_dma_m_dest_axi [get_bd_intf_pins S00_AXI1] [get_bd_intf_pins axi_hp2_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_m_axi [get_bd_intf_pins S00_AXI2] [get_bd_intf_pins axi_hp0_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_adrv9026_tx_dma_m_src_axi [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_hp3_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_cpu_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M01_AXI [get_bd_intf_pins M01_AXI] [get_bd_intf_pins axi_cpu_interconnect/M01_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M02_AXI [get_bd_intf_pins M02_AXI] [get_bd_intf_pins axi_cpu_interconnect/M02_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M03_AXI [get_bd_intf_pins M03_AXI] [get_bd_intf_pins axi_cpu_interconnect/M03_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M04_AXI [get_bd_intf_pins M04_AXI] [get_bd_intf_pins axi_cpu_interconnect/M04_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M05_AXI [get_bd_intf_pins M05_AXI] [get_bd_intf_pins axi_cpu_interconnect/M05_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M06_AXI [get_bd_intf_pins M06_AXI] [get_bd_intf_pins axi_cpu_interconnect/M06_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M07_AXI [get_bd_intf_pins M07_AXI] [get_bd_intf_pins axi_cpu_interconnect/M07_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M08_AXI [get_bd_intf_pins M08_AXI] [get_bd_intf_pins axi_cpu_interconnect/M08_AXI]
  connect_bd_intf_net -intf_net axi_hp0_interconnect_M00_AXI [get_bd_intf_pins axi_hp0_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net axi_hp2_interconnect_M00_AXI [get_bd_intf_pins axi_hp2_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net axi_hp3_interconnect_M00_AXI [get_bd_intf_pins axi_hp3_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net sys_ps8_M_AXI_HPM0_LPD [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_ps8/M_AXI_HPM0_LPD]

  # Create port connections
  connect_bd_net -net GND_1_dout [get_bd_pins GND_1/dout] [get_bd_pins sys_concat_intc_0/In0] [get_bd_pins sys_concat_intc_0/In1] [get_bd_pins sys_concat_intc_0/In2] [get_bd_pins sys_concat_intc_0/In3] [get_bd_pins sys_concat_intc_0/In4] [get_bd_pins sys_concat_intc_0/In5] [get_bd_pins sys_concat_intc_0/In6] [get_bd_pins sys_concat_intc_0/In7] [get_bd_pins sys_concat_intc_1/In0] [get_bd_pins sys_concat_intc_1/In1] [get_bd_pins sys_concat_intc_1/In4] [get_bd_pins sys_concat_intc_1/In7] [get_bd_pins sys_ps8/emio_spi0_s_i] [get_bd_pins sys_ps8/emio_spi0_sclk_i] [get_bd_pins sys_ps8/emio_spi1_s_i] [get_bd_pins sys_ps8/emio_spi1_sclk_i]
  connect_bd_net -net VCC_1_dout [get_bd_pins emio_spi0_ss_i_n] [get_bd_pins VCC_1/dout] [get_bd_pins sys_ps8/emio_spi0_ss_i_n] [get_bd_pins sys_ps8/emio_spi1_ss_i_n]
  connect_bd_net -net axi_adrv9026_rx_dma_irq [get_bd_pins In6] [get_bd_pins sys_concat_intc_1/In6]
  connect_bd_net -net axi_adrv9026_rx_jesd_irq [get_bd_pins In3] [get_bd_pins sys_concat_intc_1/In3]
  connect_bd_net -net axi_adrv9026_tx_dma_irq [get_bd_pins In5] [get_bd_pins sys_concat_intc_1/In5]
  connect_bd_net -net axi_adrv9026_tx_jesd_irq [get_bd_pins In2] [get_bd_pins sys_concat_intc_1/In2]
  connect_bd_net -net gpio_i_1 [get_bd_pins gpio_i] [get_bd_pins sys_ps8/emio_gpio_i]
  connect_bd_net -net spi0_csn_concat_dout [get_bd_pins spi0_csn] [get_bd_pins spi0_csn_concat/dout]
  connect_bd_net -net spi0_miso_1 [get_bd_pins spi0_miso] [get_bd_pins sys_ps8/emio_spi0_m_i]
  connect_bd_net -net spi1_csn_concat_dout [get_bd_pins spi1_csn] [get_bd_pins spi1_csn_concat/dout]
  connect_bd_net -net spi1_miso_1 [get_bd_pins spi1_miso] [get_bd_pins sys_ps8/emio_spi1_m_i]
  connect_bd_net -net sys_250m_clk [get_bd_pins pl_clk1] [get_bd_pins axi_hp2_interconnect/aclk] [get_bd_pins axi_hp3_interconnect/aclk] [get_bd_pins sys_ps8/pl_clk1] [get_bd_pins sys_ps8/saxihp2_fpd_aclk] [get_bd_pins sys_ps8/saxihp3_fpd_aclk]
  connect_bd_net -net sys_250m_resetn [get_bd_pins aresetn] [get_bd_pins axi_hp2_interconnect/aresetn] [get_bd_pins axi_hp3_interconnect/aresetn]
  connect_bd_net -net sys_500m_clk [get_bd_pins pl_clk2] [get_bd_pins sys_ps8/pl_clk2]
  connect_bd_net -net sys_concat_intc_0_dout [get_bd_pins sys_concat_intc_0/dout] [get_bd_pins sys_ps8/pl_ps_irq0]
  connect_bd_net -net sys_concat_intc_1_dout [get_bd_pins sys_concat_intc_1/dout] [get_bd_pins sys_ps8/pl_ps_irq1]
  connect_bd_net -net sys_cpu_clk [get_bd_pins pl_clk0] [get_bd_pins axi_cpu_interconnect/aclk] [get_bd_pins axi_hp0_interconnect/aclk] [get_bd_pins sys_ps8/maxihpm0_lpd_aclk] [get_bd_pins sys_ps8/pl_clk0] [get_bd_pins sys_ps8/saxihp0_fpd_aclk]
  connect_bd_net -net sys_cpu_resetn [get_bd_pins aresetn1] [get_bd_pins axi_cpu_interconnect/aresetn] [get_bd_pins axi_hp0_interconnect/aresetn]
  connect_bd_net -net sys_ps8_emio_gpio_o [get_bd_pins gpio_o] [get_bd_pins sys_ps8/emio_gpio_o]
  connect_bd_net -net sys_ps8_emio_gpio_t [get_bd_pins gpio_t] [get_bd_pins sys_ps8/emio_gpio_t]
  connect_bd_net -net sys_ps8_emio_spi0_m_o [get_bd_pins spi0_mosi] [get_bd_pins sys_ps8/emio_spi0_m_o]
  connect_bd_net -net sys_ps8_emio_spi0_sclk_o [get_bd_pins spi0_sclk] [get_bd_pins sys_ps8/emio_spi0_sclk_o]
  connect_bd_net -net sys_ps8_emio_spi0_ss1_o_n [get_bd_pins spi0_csn_concat/In1] [get_bd_pins sys_ps8/emio_spi0_ss1_o_n]
  connect_bd_net -net sys_ps8_emio_spi0_ss2_o_n [get_bd_pins spi0_csn_concat/In2] [get_bd_pins sys_ps8/emio_spi0_ss2_o_n]
  connect_bd_net -net sys_ps8_emio_spi0_ss_o_n [get_bd_pins spi0_csn_concat/In0] [get_bd_pins sys_ps8/emio_spi0_ss_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_m_o [get_bd_pins spi1_mosi] [get_bd_pins sys_ps8/emio_spi1_m_o]
  connect_bd_net -net sys_ps8_emio_spi1_sclk_o [get_bd_pins spi1_sclk] [get_bd_pins sys_ps8/emio_spi1_sclk_o]
  connect_bd_net -net sys_ps8_emio_spi1_ss1_o_n [get_bd_pins spi1_csn_concat/In1] [get_bd_pins sys_ps8/emio_spi1_ss1_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_ss2_o_n [get_bd_pins spi1_csn_concat/In2] [get_bd_pins sys_ps8/emio_spi1_ss2_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_ss_o_n [get_bd_pins spi1_csn_concat/In0] [get_bd_pins sys_ps8/emio_spi1_ss_o_n]
  connect_bd_net -net sys_ps8_pl_resetn0 [get_bd_pins pl_resetn0] [get_bd_pins sys_ps8/pl_resetn0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: JESD
proc create_hier_cell_JESD { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_JESD() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi5


  # Create pins
  create_bd_pin -dir O -from 15 -to 0 adc_data_0
  create_bd_pin -dir O -from 15 -to 0 adc_data_1
  create_bd_pin -dir O -from 15 -to 0 adc_data_2
  create_bd_pin -dir O -from 15 -to 0 adc_data_3
  create_bd_pin -dir O -from 15 -to 0 adc_data_4
  create_bd_pin -dir O -from 15 -to 0 adc_data_5
  create_bd_pin -dir O -from 15 -to 0 adc_data_6
  create_bd_pin -dir O -from 15 -to 0 adc_data_7
  create_bd_pin -dir I adc_dovf
  create_bd_pin -dir O -from 0 -to 0 adc_enable_0
  create_bd_pin -dir O -from 0 -to 0 adc_enable_1
  create_bd_pin -dir O -from 0 -to 0 adc_enable_2
  create_bd_pin -dir O -from 0 -to 0 adc_enable_3
  create_bd_pin -dir O -from 0 -to 0 adc_enable_4
  create_bd_pin -dir O -from 0 -to 0 adc_enable_5
  create_bd_pin -dir O -from 0 -to 0 adc_enable_6
  create_bd_pin -dir O -from 0 -to 0 adc_enable_7
  create_bd_pin -dir O -from 0 -to 0 adc_valid_0
  create_bd_pin -dir O -from 0 -to 0 adrv1_rx_sync
  create_bd_pin -dir I -from 0 -to 0 adrv1_sync
  create_bd_pin -dir O -from 0 -to 0 adrv2_rx_sync
  create_bd_pin -dir I -from 0 -to 0 adrv2_sync
  create_bd_pin -dir I core_clk
  create_bd_pin -dir I -from 15 -to 0 dac_data_0
  create_bd_pin -dir I -from 15 -to 0 dac_data_1
  create_bd_pin -dir I -from 15 -to 0 dac_data_2
  create_bd_pin -dir I -from 15 -to 0 dac_data_3
  create_bd_pin -dir I -from 15 -to 0 dac_data_4
  create_bd_pin -dir I -from 15 -to 0 dac_data_5
  create_bd_pin -dir I -from 15 -to 0 dac_data_6
  create_bd_pin -dir I -from 15 -to 0 dac_data_7
  create_bd_pin -dir I dac_dunf
  create_bd_pin -dir O -from 0 -to 0 dac_enable_0
  create_bd_pin -dir O -from 0 -to 0 dac_enable_1
  create_bd_pin -dir O -from 0 -to 0 dac_enable_2
  create_bd_pin -dir O -from 0 -to 0 dac_enable_3
  create_bd_pin -dir O -from 0 -to 0 dac_enable_4
  create_bd_pin -dir O -from 0 -to 0 dac_enable_5
  create_bd_pin -dir O -from 0 -to 0 dac_enable_6
  create_bd_pin -dir O -from 0 -to 0 dac_enable_7
  create_bd_pin -dir O -from 0 -to 0 dac_valid_0
  create_bd_pin -dir O -type intr irq_adrv_rx
  create_bd_pin -dir O -type intr irq_adrv_tx
  create_bd_pin -dir I rx_data_0_n
  create_bd_pin -dir I rx_data_0_p
  create_bd_pin -dir I rx_data_1_n
  create_bd_pin -dir I rx_data_1_p
  create_bd_pin -dir I rx_data_2_n
  create_bd_pin -dir I rx_data_2_p
  create_bd_pin -dir I rx_data_3_n
  create_bd_pin -dir I rx_data_3_p
  create_bd_pin -dir I rx_data_4_n
  create_bd_pin -dir I rx_data_4_p
  create_bd_pin -dir I rx_data_5_n
  create_bd_pin -dir I rx_data_5_p
  create_bd_pin -dir I rx_data_6_n
  create_bd_pin -dir I rx_data_6_p
  create_bd_pin -dir I rx_data_7_n
  create_bd_pin -dir I rx_data_7_p
  create_bd_pin -dir I rx_ref_clk_0
  create_bd_pin -dir I rx_sysref_0
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O tx_data_0_n
  create_bd_pin -dir O tx_data_0_p
  create_bd_pin -dir O tx_data_1_n
  create_bd_pin -dir O tx_data_1_p
  create_bd_pin -dir O tx_data_2_n
  create_bd_pin -dir O tx_data_2_p
  create_bd_pin -dir O tx_data_3_n
  create_bd_pin -dir O tx_data_3_p
  create_bd_pin -dir O tx_data_4_n
  create_bd_pin -dir O tx_data_4_p
  create_bd_pin -dir O tx_data_5_n
  create_bd_pin -dir O tx_data_5_p
  create_bd_pin -dir O tx_data_6_n
  create_bd_pin -dir O tx_data_6_p
  create_bd_pin -dir O tx_data_7_n
  create_bd_pin -dir O tx_data_7_p
  create_bd_pin -dir I tx_ref_clk_0
  create_bd_pin -dir I tx_sysref_0

  # Create instance: axi_adrv_rx_jesd
  create_hier_cell_axi_adrv_rx_jesd $hier_obj axi_adrv_rx_jesd

  # Create instance: axi_adrv_rx_xcvr, and set properties
  set axi_adrv_rx_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_adrv_rx_xcvr ]
  set_property -dict [list \
    CONFIG.FPGA_VOLTAGE {850} \
    CONFIG.NUM_OF_LANES {8} \
    CONFIG.OUT_CLK_SEL {"011"} \
    CONFIG.QPLL_ENABLE {0} \
    CONFIG.SYS_CLK_SEL {00} \
    CONFIG.TX_OR_RX_N {0} \
    CONFIG.XCVR_TYPE {8} \
  ] $axi_adrv_rx_xcvr


  # Create instance: axi_adrv_tx_jesd
  create_hier_cell_axi_adrv_tx_jesd $hier_obj axi_adrv_tx_jesd

  # Create instance: axi_adrv_tx_xcvr, and set properties
  set axi_adrv_tx_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_adrv_tx_xcvr ]
  set_property -dict [list \
    CONFIG.FPGA_VOLTAGE {850} \
    CONFIG.NUM_OF_LANES {8} \
    CONFIG.OUT_CLK_SEL {"011"} \
    CONFIG.QPLL_ENABLE {1} \
    CONFIG.SYS_CLK_SEL {"11"} \
    CONFIG.TX_OR_RX_N {1} \
    CONFIG.XCVR_TYPE {8} \
  ] $axi_adrv_tx_xcvr


  # Create instance: rx_adrv_tpl_core
  create_hier_cell_rx_adrv_tpl_core $hier_obj rx_adrv_tpl_core

  # Create instance: tx_adrv_tpl_core
  create_hier_cell_tx_adrv_tpl_core $hier_obj tx_adrv_tpl_core

  # Create instance: util_adrv9026_xcvr, and set properties
  set util_adrv9026_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_adrv9026_xcvr ]
  set_property -dict [list \
    CONFIG.CPLL_FBDIV {4} \
    CONFIG.CPLL_FBDIV_4_5 {5} \
    CONFIG.QPLL_FBDIV {"0000101000"} \
    CONFIG.QPLL_LPF {0b0100110111} \
    CONFIG.QPLL_REFCLK_DIV {1} \
    CONFIG.RTX_BUF_CML_CTRL {000} \
    CONFIG.RXCDR_CFG3_GEN2 {0b011010} \
    CONFIG.RX_CDR_CFG {0x0b000023ff10400020} \
    CONFIG.RX_CLK25_DIV {10} \
    CONFIG.RX_LANE_INVERT {15} \
    CONFIG.RX_LANE_RATE {10} \
    CONFIG.RX_NUM_OF_LANES {8} \
    CONFIG.RX_PMA_CFG {0x001E7080} \
    CONFIG.TX_CLK25_DIV {10} \
    CONFIG.TX_LANE_INVERT {6} \
    CONFIG.TX_LANE_RATE {10} \
    CONFIG.TX_NUM_OF_LANES {8} \
    CONFIG.TX_OUT_DIV {1} \
    CONFIG.XCVR_TYPE {8} \
  ] $util_adrv9026_xcvr


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi5] [get_bd_intf_pins rx_adrv_tpl_core/s_axi]
  connect_bd_intf_net -intf_net axi_adrv1_rx_xcvr_up_ch_4 [get_bd_intf_pins axi_adrv_rx_xcvr/up_ch_4] [get_bd_intf_pins util_adrv9026_xcvr/up_rx_4]
  connect_bd_intf_net -intf_net axi_adrv1_rx_xcvr_up_ch_5 [get_bd_intf_pins axi_adrv_rx_xcvr/up_ch_5] [get_bd_intf_pins util_adrv9026_xcvr/up_rx_5]
  connect_bd_intf_net -intf_net axi_adrv1_rx_xcvr_up_ch_6 [get_bd_intf_pins axi_adrv_rx_xcvr/up_ch_6] [get_bd_intf_pins util_adrv9026_xcvr/up_rx_6]
  connect_bd_intf_net -intf_net axi_adrv1_rx_xcvr_up_ch_7 [get_bd_intf_pins axi_adrv_rx_xcvr/up_ch_7] [get_bd_intf_pins util_adrv9026_xcvr/up_rx_7]
  connect_bd_intf_net -intf_net axi_adrv1_rx_xcvr_up_es_4 [get_bd_intf_pins axi_adrv_rx_xcvr/up_es_4] [get_bd_intf_pins util_adrv9026_xcvr/up_es_4]
  connect_bd_intf_net -intf_net axi_adrv1_rx_xcvr_up_es_5 [get_bd_intf_pins axi_adrv_rx_xcvr/up_es_5] [get_bd_intf_pins util_adrv9026_xcvr/up_es_5]
  connect_bd_intf_net -intf_net axi_adrv1_rx_xcvr_up_es_6 [get_bd_intf_pins axi_adrv_rx_xcvr/up_es_6] [get_bd_intf_pins util_adrv9026_xcvr/up_es_6]
  connect_bd_intf_net -intf_net axi_adrv1_rx_xcvr_up_es_7 [get_bd_intf_pins axi_adrv_rx_xcvr/up_es_7] [get_bd_intf_pins util_adrv9026_xcvr/up_es_7]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_ch_0 [get_bd_intf_pins axi_adrv_tx_xcvr/up_ch_0] [get_bd_intf_pins util_adrv9026_xcvr/up_tx_0]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_ch_1 [get_bd_intf_pins axi_adrv_tx_xcvr/up_ch_1] [get_bd_intf_pins util_adrv9026_xcvr/up_tx_1]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_ch_2 [get_bd_intf_pins axi_adrv_tx_xcvr/up_ch_2] [get_bd_intf_pins util_adrv9026_xcvr/up_tx_2]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_ch_3 [get_bd_intf_pins axi_adrv_tx_xcvr/up_ch_3] [get_bd_intf_pins util_adrv9026_xcvr/up_tx_3]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_ch_4 [get_bd_intf_pins axi_adrv_tx_xcvr/up_ch_4] [get_bd_intf_pins util_adrv9026_xcvr/up_tx_4]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_ch_5 [get_bd_intf_pins axi_adrv_tx_xcvr/up_ch_5] [get_bd_intf_pins util_adrv9026_xcvr/up_tx_5]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_ch_6 [get_bd_intf_pins axi_adrv_tx_xcvr/up_ch_6] [get_bd_intf_pins util_adrv9026_xcvr/up_tx_6]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_ch_7 [get_bd_intf_pins axi_adrv_tx_xcvr/up_ch_7] [get_bd_intf_pins util_adrv9026_xcvr/up_tx_7]
  connect_bd_intf_net -intf_net axi_adrv1_tx_xcvr_up_cm_4 [get_bd_intf_pins axi_adrv_tx_xcvr/up_cm_4] [get_bd_intf_pins util_adrv9026_xcvr/up_cm_4]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_m_axi [get_bd_intf_pins m_axi] [get_bd_intf_pins axi_adrv_rx_xcvr/m_axi]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_up_ch_0 [get_bd_intf_pins axi_adrv_rx_xcvr/up_ch_0] [get_bd_intf_pins util_adrv9026_xcvr/up_rx_0]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_up_ch_1 [get_bd_intf_pins axi_adrv_rx_xcvr/up_ch_1] [get_bd_intf_pins util_adrv9026_xcvr/up_rx_1]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_up_ch_2 [get_bd_intf_pins axi_adrv_rx_xcvr/up_ch_2] [get_bd_intf_pins util_adrv9026_xcvr/up_rx_2]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_up_ch_3 [get_bd_intf_pins axi_adrv_rx_xcvr/up_ch_3] [get_bd_intf_pins util_adrv9026_xcvr/up_rx_3]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_up_es_0 [get_bd_intf_pins axi_adrv_rx_xcvr/up_es_0] [get_bd_intf_pins util_adrv9026_xcvr/up_es_0]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_up_es_1 [get_bd_intf_pins axi_adrv_rx_xcvr/up_es_1] [get_bd_intf_pins util_adrv9026_xcvr/up_es_1]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_up_es_2 [get_bd_intf_pins axi_adrv_rx_xcvr/up_es_2] [get_bd_intf_pins util_adrv9026_xcvr/up_es_2]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_up_es_3 [get_bd_intf_pins axi_adrv_rx_xcvr/up_es_3] [get_bd_intf_pins util_adrv9026_xcvr/up_es_3]
  connect_bd_intf_net -intf_net axi_adrv9026_tx_xcvr_up_cm_0 [get_bd_intf_pins axi_adrv_tx_xcvr/up_cm_0] [get_bd_intf_pins util_adrv9026_xcvr/up_cm_0]
  connect_bd_intf_net -intf_net axi_adrv_tx_jesd_tx_phy0 [get_bd_intf_pins axi_adrv_tx_jesd/tx_phy0] [get_bd_intf_pins util_adrv9026_xcvr/tx_0]
  connect_bd_intf_net -intf_net axi_adrv_tx_jesd_tx_phy1 [get_bd_intf_pins axi_adrv_tx_jesd/tx_phy1] [get_bd_intf_pins util_adrv9026_xcvr/tx_1]
  connect_bd_intf_net -intf_net axi_adrv_tx_jesd_tx_phy2 [get_bd_intf_pins axi_adrv_tx_jesd/tx_phy2] [get_bd_intf_pins util_adrv9026_xcvr/tx_2]
  connect_bd_intf_net -intf_net axi_adrv_tx_jesd_tx_phy3 [get_bd_intf_pins axi_adrv_tx_jesd/tx_phy3] [get_bd_intf_pins util_adrv9026_xcvr/tx_3]
  connect_bd_intf_net -intf_net axi_adrv_tx_jesd_tx_phy4 [get_bd_intf_pins axi_adrv_tx_jesd/tx_phy4] [get_bd_intf_pins util_adrv9026_xcvr/tx_4]
  connect_bd_intf_net -intf_net axi_adrv_tx_jesd_tx_phy5 [get_bd_intf_pins axi_adrv_tx_jesd/tx_phy5] [get_bd_intf_pins util_adrv9026_xcvr/tx_5]
  connect_bd_intf_net -intf_net axi_adrv_tx_jesd_tx_phy6 [get_bd_intf_pins axi_adrv_tx_jesd/tx_phy6] [get_bd_intf_pins util_adrv9026_xcvr/tx_6]
  connect_bd_intf_net -intf_net axi_adrv_tx_jesd_tx_phy7 [get_bd_intf_pins axi_adrv_tx_jesd/tx_phy7] [get_bd_intf_pins util_adrv9026_xcvr/tx_7]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M02_AXI [get_bd_intf_pins s_axi2] [get_bd_intf_pins tx_adrv_tpl_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M03_AXI [get_bd_intf_pins s_axi] [get_bd_intf_pins axi_adrv_tx_xcvr/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M04_AXI [get_bd_intf_pins s_axi4] [get_bd_intf_pins axi_adrv_tx_jesd/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M06_AXI [get_bd_intf_pins s_axi1] [get_bd_intf_pins axi_adrv_rx_xcvr/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M07_AXI [get_bd_intf_pins s_axi3] [get_bd_intf_pins axi_adrv_rx_jesd/s_axi]
  connect_bd_intf_net -intf_net tx_data_1 [get_bd_intf_pins axi_adrv_tx_jesd/tx_data] [get_bd_intf_pins tx_adrv_tpl_core/link]
  connect_bd_intf_net -intf_net util_adrv9026_xcvr_rx_0 [get_bd_intf_pins axi_adrv_rx_jesd/rx_phy0] [get_bd_intf_pins util_adrv9026_xcvr/rx_0]
  connect_bd_intf_net -intf_net util_adrv9026_xcvr_rx_1 [get_bd_intf_pins axi_adrv_rx_jesd/rx_phy1] [get_bd_intf_pins util_adrv9026_xcvr/rx_1]
  connect_bd_intf_net -intf_net util_adrv9026_xcvr_rx_2 [get_bd_intf_pins axi_adrv_rx_jesd/rx_phy2] [get_bd_intf_pins util_adrv9026_xcvr/rx_2]
  connect_bd_intf_net -intf_net util_adrv9026_xcvr_rx_3 [get_bd_intf_pins axi_adrv_rx_jesd/rx_phy3] [get_bd_intf_pins util_adrv9026_xcvr/rx_3]
  connect_bd_intf_net -intf_net util_adrv9026_xcvr_rx_4 [get_bd_intf_pins axi_adrv_rx_jesd/rx_phy4] [get_bd_intf_pins util_adrv9026_xcvr/rx_4]
  connect_bd_intf_net -intf_net util_adrv9026_xcvr_rx_5 [get_bd_intf_pins axi_adrv_rx_jesd/rx_phy5] [get_bd_intf_pins util_adrv9026_xcvr/rx_5]
  connect_bd_intf_net -intf_net util_adrv9026_xcvr_rx_6 [get_bd_intf_pins axi_adrv_rx_jesd/rx_phy6] [get_bd_intf_pins util_adrv9026_xcvr/rx_6]
  connect_bd_intf_net -intf_net util_adrv9026_xcvr_rx_7 [get_bd_intf_pins axi_adrv_rx_jesd/rx_phy7] [get_bd_intf_pins util_adrv9026_xcvr/rx_7]

  # Create port connections
  connect_bd_net -net adc_dovf_1 [get_bd_pins adc_dovf] [get_bd_pins rx_adrv_tpl_core/adc_dovf]
  connect_bd_net -net adrv2_sync_1 [get_bd_pins adrv2_sync] [get_bd_pins axi_adrv_tx_jesd/adrv2_sync]
  connect_bd_net -net axi_adrv1_rx_jesd_adrv2_rx_sync [get_bd_pins adrv2_rx_sync] [get_bd_pins axi_adrv_rx_jesd/adrv2_rx_sync]
  connect_bd_net -net axi_adrv1_rx_jesd_rx_data_tdata [get_bd_pins axi_adrv_rx_jesd/rx_data_tdata] [get_bd_pins rx_adrv_tpl_core/link_data]
  connect_bd_net -net axi_adrv1_rx_jesd_rx_data_tvalid [get_bd_pins axi_adrv_rx_jesd/rx_data_tvalid] [get_bd_pins rx_adrv_tpl_core/link_valid]
  connect_bd_net -net axi_adrv1_rx_jesd_rx_sof [get_bd_pins axi_adrv_rx_jesd/rx_sof] [get_bd_pins rx_adrv_tpl_core/link_sof]
  connect_bd_net -net axi_adrv9026_dacfifo_dac_dunf [get_bd_pins dac_dunf] [get_bd_pins tx_adrv_tpl_core/dac_dunf]
  connect_bd_net -net axi_adrv9026_rx_jesd_irq [get_bd_pins irq_adrv_rx] [get_bd_pins axi_adrv_rx_jesd/irq]
  connect_bd_net -net axi_adrv9026_rx_jesd_phy_en_char_align [get_bd_pins axi_adrv_rx_jesd/phy_en_char_align] [get_bd_pins util_adrv9026_xcvr/rx_calign_0] [get_bd_pins util_adrv9026_xcvr/rx_calign_1] [get_bd_pins util_adrv9026_xcvr/rx_calign_2] [get_bd_pins util_adrv9026_xcvr/rx_calign_3] [get_bd_pins util_adrv9026_xcvr/rx_calign_4] [get_bd_pins util_adrv9026_xcvr/rx_calign_5] [get_bd_pins util_adrv9026_xcvr/rx_calign_6] [get_bd_pins util_adrv9026_xcvr/rx_calign_7]
  connect_bd_net -net axi_adrv9026_rx_jesd_sync [get_bd_pins adrv1_rx_sync] [get_bd_pins axi_adrv_rx_jesd/adrv1_rx_sync]
  connect_bd_net -net axi_adrv9026_rx_xcvr_up_pll_rst [get_bd_pins axi_adrv_rx_xcvr/up_pll_rst] [get_bd_pins util_adrv9026_xcvr/up_cpll_rst_0] [get_bd_pins util_adrv9026_xcvr/up_cpll_rst_1] [get_bd_pins util_adrv9026_xcvr/up_cpll_rst_2] [get_bd_pins util_adrv9026_xcvr/up_cpll_rst_3] [get_bd_pins util_adrv9026_xcvr/up_cpll_rst_4] [get_bd_pins util_adrv9026_xcvr/up_cpll_rst_5] [get_bd_pins util_adrv9026_xcvr/up_cpll_rst_6] [get_bd_pins util_adrv9026_xcvr/up_cpll_rst_7]
  connect_bd_net -net axi_adrv9026_tx_jesd_irq [get_bd_pins irq_adrv_tx] [get_bd_pins axi_adrv_tx_jesd/irq]
  connect_bd_net -net axi_adrv9026_tx_xcvr_up_pll_rst [get_bd_pins axi_adrv_tx_xcvr/up_pll_rst] [get_bd_pins util_adrv9026_xcvr/up_qpll_rst_0] [get_bd_pins util_adrv9026_xcvr/up_qpll_rst_4]
  connect_bd_net -net core_clk_1 [get_bd_pins core_clk] [get_bd_pins axi_adrv_rx_jesd/device_clk] [get_bd_pins axi_adrv_rx_jesd/link_clk] [get_bd_pins axi_adrv_tx_jesd/device_clk] [get_bd_pins axi_adrv_tx_jesd/link_clk] [get_bd_pins rx_adrv_tpl_core/link_clk] [get_bd_pins tx_adrv_tpl_core/link_clk] [get_bd_pins util_adrv9026_xcvr/rx_clk_0] [get_bd_pins util_adrv9026_xcvr/rx_clk_1] [get_bd_pins util_adrv9026_xcvr/rx_clk_2] [get_bd_pins util_adrv9026_xcvr/rx_clk_3] [get_bd_pins util_adrv9026_xcvr/rx_clk_4] [get_bd_pins util_adrv9026_xcvr/rx_clk_5] [get_bd_pins util_adrv9026_xcvr/rx_clk_6] [get_bd_pins util_adrv9026_xcvr/rx_clk_7] [get_bd_pins util_adrv9026_xcvr/tx_clk_0] [get_bd_pins util_adrv9026_xcvr/tx_clk_1] [get_bd_pins util_adrv9026_xcvr/tx_clk_2] [get_bd_pins util_adrv9026_xcvr/tx_clk_3] [get_bd_pins util_adrv9026_xcvr/tx_clk_4] [get_bd_pins util_adrv9026_xcvr/tx_clk_5] [get_bd_pins util_adrv9026_xcvr/tx_clk_6] [get_bd_pins util_adrv9026_xcvr/tx_clk_7]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_data_0 [get_bd_pins adc_data_0] [get_bd_pins rx_adrv_tpl_core/adc_data_0]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_data_1 [get_bd_pins adc_data_1] [get_bd_pins rx_adrv_tpl_core/adc_data_1]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_data_2 [get_bd_pins adc_data_2] [get_bd_pins rx_adrv_tpl_core/adc_data_2]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_data_3 [get_bd_pins adc_data_3] [get_bd_pins rx_adrv_tpl_core/adc_data_3]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_data_4 [get_bd_pins adc_data_4] [get_bd_pins rx_adrv_tpl_core/adc_data_4]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_data_5 [get_bd_pins adc_data_5] [get_bd_pins rx_adrv_tpl_core/adc_data_5]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_data_6 [get_bd_pins adc_data_6] [get_bd_pins rx_adrv_tpl_core/adc_data_6]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_data_7 [get_bd_pins adc_data_7] [get_bd_pins rx_adrv_tpl_core/adc_data_7]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_enable_0 [get_bd_pins adc_enable_0] [get_bd_pins rx_adrv_tpl_core/adc_enable_0]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_enable_1 [get_bd_pins adc_enable_1] [get_bd_pins rx_adrv_tpl_core/adc_enable_1]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_enable_2 [get_bd_pins adc_enable_2] [get_bd_pins rx_adrv_tpl_core/adc_enable_2]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_enable_3 [get_bd_pins adc_enable_3] [get_bd_pins rx_adrv_tpl_core/adc_enable_3]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_enable_4 [get_bd_pins adc_enable_4] [get_bd_pins rx_adrv_tpl_core/adc_enable_4]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_enable_5 [get_bd_pins adc_enable_5] [get_bd_pins rx_adrv_tpl_core/adc_enable_5]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_enable_6 [get_bd_pins adc_enable_6] [get_bd_pins rx_adrv_tpl_core/adc_enable_6]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_enable_7 [get_bd_pins adc_enable_7] [get_bd_pins rx_adrv_tpl_core/adc_enable_7]
  connect_bd_net -net rx_adrv9026_tpl_core_adc_valid_0 [get_bd_pins adc_valid_0] [get_bd_pins rx_adrv_tpl_core/adc_valid_0]
  connect_bd_net -net rx_data_0_n_1 [get_bd_pins rx_data_0_n] [get_bd_pins util_adrv9026_xcvr/rx_0_n]
  connect_bd_net -net rx_data_0_p_1 [get_bd_pins rx_data_0_p] [get_bd_pins util_adrv9026_xcvr/rx_0_p]
  connect_bd_net -net rx_data_1_n_1 [get_bd_pins rx_data_1_n] [get_bd_pins util_adrv9026_xcvr/rx_1_n]
  connect_bd_net -net rx_data_1_p_1 [get_bd_pins rx_data_1_p] [get_bd_pins util_adrv9026_xcvr/rx_1_p]
  connect_bd_net -net rx_data_2_n_1 [get_bd_pins rx_data_2_n] [get_bd_pins util_adrv9026_xcvr/rx_2_n]
  connect_bd_net -net rx_data_2_p_1 [get_bd_pins rx_data_2_p] [get_bd_pins util_adrv9026_xcvr/rx_2_p]
  connect_bd_net -net rx_data_3_n_1 [get_bd_pins rx_data_3_n] [get_bd_pins util_adrv9026_xcvr/rx_3_n]
  connect_bd_net -net rx_data_3_p_1 [get_bd_pins rx_data_3_p] [get_bd_pins util_adrv9026_xcvr/rx_3_p]
  connect_bd_net -net rx_data_4_n_1 [get_bd_pins rx_data_4_n] [get_bd_pins util_adrv9026_xcvr/rx_4_n]
  connect_bd_net -net rx_data_4_p_1 [get_bd_pins rx_data_4_p] [get_bd_pins util_adrv9026_xcvr/rx_4_p]
  connect_bd_net -net rx_data_5_n_1 [get_bd_pins rx_data_5_n] [get_bd_pins util_adrv9026_xcvr/rx_5_n]
  connect_bd_net -net rx_data_5_p_1 [get_bd_pins rx_data_5_p] [get_bd_pins util_adrv9026_xcvr/rx_5_p]
  connect_bd_net -net rx_data_6_n_1 [get_bd_pins rx_data_6_n] [get_bd_pins util_adrv9026_xcvr/rx_6_n]
  connect_bd_net -net rx_data_6_p_1 [get_bd_pins rx_data_6_p] [get_bd_pins util_adrv9026_xcvr/rx_6_p]
  connect_bd_net -net rx_data_7_n_1 [get_bd_pins rx_data_7_n] [get_bd_pins util_adrv9026_xcvr/rx_7_n]
  connect_bd_net -net rx_data_7_p_1 [get_bd_pins rx_data_7_p] [get_bd_pins util_adrv9026_xcvr/rx_7_p]
  connect_bd_net -net rx_ref_clk_0_1 [get_bd_pins rx_ref_clk_0] [get_bd_pins util_adrv9026_xcvr/cpll_ref_clk_0] [get_bd_pins util_adrv9026_xcvr/cpll_ref_clk_1] [get_bd_pins util_adrv9026_xcvr/cpll_ref_clk_2] [get_bd_pins util_adrv9026_xcvr/cpll_ref_clk_3] [get_bd_pins util_adrv9026_xcvr/cpll_ref_clk_4] [get_bd_pins util_adrv9026_xcvr/cpll_ref_clk_5] [get_bd_pins util_adrv9026_xcvr/cpll_ref_clk_6] [get_bd_pins util_adrv9026_xcvr/cpll_ref_clk_7]
  connect_bd_net -net sync_1 [get_bd_pins adrv1_sync] [get_bd_pins axi_adrv_tx_jesd/adrv1_sync]
  connect_bd_net -net sys_cpu_clk [get_bd_pins s_axi_aclk] [get_bd_pins axi_adrv_rx_jesd/s_axi_aclk] [get_bd_pins axi_adrv_rx_xcvr/s_axi_aclk] [get_bd_pins axi_adrv_tx_jesd/s_axi_aclk] [get_bd_pins axi_adrv_tx_xcvr/s_axi_aclk] [get_bd_pins rx_adrv_tpl_core/s_axi_aclk] [get_bd_pins tx_adrv_tpl_core/s_axi_aclk] [get_bd_pins util_adrv9026_xcvr/up_clk]
  connect_bd_net -net sys_cpu_resetn [get_bd_pins s_axi_aresetn] [get_bd_pins axi_adrv_rx_jesd/s_axi_aresetn] [get_bd_pins axi_adrv_rx_xcvr/s_axi_aresetn] [get_bd_pins axi_adrv_tx_jesd/s_axi_aresetn] [get_bd_pins axi_adrv_tx_xcvr/s_axi_aresetn] [get_bd_pins rx_adrv_tpl_core/s_axi_aresetn] [get_bd_pins tx_adrv_tpl_core/s_axi_aresetn] [get_bd_pins util_adrv9026_xcvr/up_rstn]
  connect_bd_net -net sysref_1 [get_bd_pins tx_sysref_0] [get_bd_pins axi_adrv_tx_jesd/sysref]
  connect_bd_net -net sysref_2 [get_bd_pins rx_sysref_0] [get_bd_pins axi_adrv_rx_jesd/sysref]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_0 [get_bd_pins dac_enable_0] [get_bd_pins tx_adrv_tpl_core/dac_enable_0]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_1 [get_bd_pins dac_enable_1] [get_bd_pins tx_adrv_tpl_core/dac_enable_1]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_2 [get_bd_pins dac_enable_2] [get_bd_pins tx_adrv_tpl_core/dac_enable_2]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_3 [get_bd_pins dac_enable_3] [get_bd_pins tx_adrv_tpl_core/dac_enable_3]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_4 [get_bd_pins dac_enable_4] [get_bd_pins tx_adrv_tpl_core/dac_enable_4]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_5 [get_bd_pins dac_enable_5] [get_bd_pins tx_adrv_tpl_core/dac_enable_5]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_6 [get_bd_pins dac_enable_6] [get_bd_pins tx_adrv_tpl_core/dac_enable_6]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_7 [get_bd_pins dac_enable_7] [get_bd_pins tx_adrv_tpl_core/dac_enable_7]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_valid_0 [get_bd_pins dac_valid_0] [get_bd_pins tx_adrv_tpl_core/dac_valid_0]
  connect_bd_net -net tx_ref_clk_0_1 [get_bd_pins tx_ref_clk_0] [get_bd_pins util_adrv9026_xcvr/qpll_ref_clk_0] [get_bd_pins util_adrv9026_xcvr/qpll_ref_clk_4]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_0 [get_bd_pins dac_data_0] [get_bd_pins tx_adrv_tpl_core/dac_data_0]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_1 [get_bd_pins dac_data_1] [get_bd_pins tx_adrv_tpl_core/dac_data_1]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_2 [get_bd_pins dac_data_2] [get_bd_pins tx_adrv_tpl_core/dac_data_2]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_3 [get_bd_pins dac_data_3] [get_bd_pins tx_adrv_tpl_core/dac_data_3]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_4 [get_bd_pins dac_data_4] [get_bd_pins tx_adrv_tpl_core/dac_data_4]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_5 [get_bd_pins dac_data_5] [get_bd_pins tx_adrv_tpl_core/dac_data_5]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_6 [get_bd_pins dac_data_6] [get_bd_pins tx_adrv_tpl_core/dac_data_6]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_7 [get_bd_pins dac_data_7] [get_bd_pins tx_adrv_tpl_core/dac_data_7]
  connect_bd_net -net util_adrv9026_xcvr_tx_0_n [get_bd_pins tx_data_0_n] [get_bd_pins util_adrv9026_xcvr/tx_0_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_0_p [get_bd_pins tx_data_0_p] [get_bd_pins util_adrv9026_xcvr/tx_0_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_1_n [get_bd_pins tx_data_1_n] [get_bd_pins util_adrv9026_xcvr/tx_1_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_1_p [get_bd_pins tx_data_1_p] [get_bd_pins util_adrv9026_xcvr/tx_1_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_2_n [get_bd_pins tx_data_2_n] [get_bd_pins util_adrv9026_xcvr/tx_2_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_2_p [get_bd_pins tx_data_2_p] [get_bd_pins util_adrv9026_xcvr/tx_2_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_3_n [get_bd_pins tx_data_3_n] [get_bd_pins util_adrv9026_xcvr/tx_3_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_3_p [get_bd_pins tx_data_3_p] [get_bd_pins util_adrv9026_xcvr/tx_3_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_4_n [get_bd_pins tx_data_4_n] [get_bd_pins util_adrv9026_xcvr/tx_4_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_4_p [get_bd_pins tx_data_4_p] [get_bd_pins util_adrv9026_xcvr/tx_4_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_5_n [get_bd_pins tx_data_5_n] [get_bd_pins util_adrv9026_xcvr/tx_5_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_5_p [get_bd_pins tx_data_5_p] [get_bd_pins util_adrv9026_xcvr/tx_5_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_6_n [get_bd_pins tx_data_6_n] [get_bd_pins util_adrv9026_xcvr/tx_6_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_6_p [get_bd_pins tx_data_6_p] [get_bd_pins util_adrv9026_xcvr/tx_6_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_7_n [get_bd_pins tx_data_7_n] [get_bd_pins util_adrv9026_xcvr/tx_7_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_7_p [get_bd_pins tx_data_7_p] [get_bd_pins util_adrv9026_xcvr/tx_7_p]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DMA
proc create_hier_cell_DMA { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DMA() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_dest_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_src_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi1


  # Create pins
  create_bd_pin -dir I core_clk
  create_bd_pin -dir O dac_dunf
  create_bd_pin -dir I dac_fifo_bypass
  create_bd_pin -dir I enable_0
  create_bd_pin -dir I enable_1
  create_bd_pin -dir I enable_2
  create_bd_pin -dir I enable_3
  create_bd_pin -dir I enable_4
  create_bd_pin -dir I enable_5
  create_bd_pin -dir I enable_6
  create_bd_pin -dir I enable_7
  create_bd_pin -dir I enable_8
  create_bd_pin -dir I enable_9
  create_bd_pin -dir I enable_10
  create_bd_pin -dir I enable_11
  create_bd_pin -dir I enable_12
  create_bd_pin -dir I enable_13
  create_bd_pin -dir I enable_14
  create_bd_pin -dir I enable_15
  create_bd_pin -dir O -from 15 -to 0 fifo_rd_data_0
  create_bd_pin -dir O -from 15 -to 0 fifo_rd_data_1
  create_bd_pin -dir O -from 15 -to 0 fifo_rd_data_2
  create_bd_pin -dir O -from 15 -to 0 fifo_rd_data_3
  create_bd_pin -dir O -from 15 -to 0 fifo_rd_data_4
  create_bd_pin -dir O -from 15 -to 0 fifo_rd_data_5
  create_bd_pin -dir O -from 15 -to 0 fifo_rd_data_6
  create_bd_pin -dir O -from 15 -to 0 fifo_rd_data_7
  create_bd_pin -dir I fifo_rd_en
  create_bd_pin -dir I -from 15 -to 0 fifo_wr_data_0
  create_bd_pin -dir I -from 15 -to 0 fifo_wr_data_1
  create_bd_pin -dir I -from 15 -to 0 fifo_wr_data_2
  create_bd_pin -dir I -from 15 -to 0 fifo_wr_data_3
  create_bd_pin -dir I -from 15 -to 0 fifo_wr_data_4
  create_bd_pin -dir I -from 15 -to 0 fifo_wr_data_5
  create_bd_pin -dir I -from 15 -to 0 fifo_wr_data_6
  create_bd_pin -dir I -from 15 -to 0 fifo_wr_data_7
  create_bd_pin -dir I fifo_wr_en
  create_bd_pin -dir O fifo_wr_overflow
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir O -type intr irq1
  create_bd_pin -dir I -type rst m_dest_axi_aresetn
  create_bd_pin -dir I -type clk m_src_axi_aclk
  create_bd_pin -dir I -type rst m_src_axi_aresetn
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I s_axis_valid

  # Create instance: axi_adrv9026_dacfifo, and set properties
  set axi_adrv9026_dacfifo [ create_bd_cell -type ip -vlnv analog.com:user:util_dacfifo:1.0 axi_adrv9026_dacfifo ]
  set_property -dict [list \
    CONFIG.ADDRESS_WIDTH {17} \
    CONFIG.DATA_WIDTH {128} \
  ] $axi_adrv9026_dacfifo


  # Create instance: axi_adrv9026_rx_dma, and set properties
  set axi_adrv9026_rx_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_adrv9026_rx_dma ]
  set_property -dict [list \
    CONFIG.ALLOW_ASYM_MEM {1} \
    CONFIG.ASYNC_CLK_DEST_REQ {true} \
    CONFIG.ASYNC_CLK_REQ_SRC {true} \
    CONFIG.ASYNC_CLK_SRC_DEST {true} \
    CONFIG.CYCLIC {false} \
    CONFIG.DMA_2D_TRANSFER {false} \
    CONFIG.DMA_DATA_WIDTH_DEST {128} \
    CONFIG.DMA_DATA_WIDTH_SRC {128} \
    CONFIG.DMA_TYPE_DEST {0} \
    CONFIG.DMA_TYPE_SRC {2} \
    CONFIG.FIFO_SIZE {32} \
    CONFIG.MAX_BYTES_PER_BURST {256} \
    CONFIG.SYNC_TRANSFER_START {true} \
  ] $axi_adrv9026_rx_dma


  # Create instance: axi_adrv9026_tx_dma, and set properties
  set axi_adrv9026_tx_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_adrv9026_tx_dma ]
  set_property -dict [list \
    CONFIG.ALLOW_ASYM_MEM {1} \
    CONFIG.ASYNC_CLK_DEST_REQ {true} \
    CONFIG.ASYNC_CLK_REQ_SRC {true} \
    CONFIG.ASYNC_CLK_SRC_DEST {true} \
    CONFIG.CYCLIC {true} \
    CONFIG.DMA_2D_TRANSFER {false} \
    CONFIG.DMA_DATA_WIDTH_DEST {128} \
    CONFIG.DMA_DATA_WIDTH_SRC {128} \
    CONFIG.DMA_TYPE_DEST {1} \
    CONFIG.DMA_TYPE_SRC {0} \
    CONFIG.FIFO_SIZE {32} \
    CONFIG.MAX_BYTES_PER_BURST {256} \
  ] $axi_adrv9026_tx_dma


  # Create instance: util_adrv9026_rx_cpack, and set properties
  set util_adrv9026_rx_cpack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack2:1.0 util_adrv9026_rx_cpack ]
  set_property -dict [list \
    CONFIG.NUM_OF_CHANNELS {8} \
    CONFIG.SAMPLES_PER_CHANNEL {1} \
    CONFIG.SAMPLE_DATA_WIDTH {16} \
  ] $util_adrv9026_rx_cpack


  # Create instance: util_adrv9026_tx_upack, and set properties
  set util_adrv9026_tx_upack [ create_bd_cell -type ip -vlnv analog.com:user:util_upack2:1.0 util_adrv9026_tx_upack ]
  set_property -dict [list \
    CONFIG.NUM_OF_CHANNELS {8} \
    CONFIG.SAMPLES_PER_CHANNEL {1} \
    CONFIG.SAMPLE_DATA_WIDTH {16} \
  ] $util_adrv9026_tx_upack


  # Create interface connections
  connect_bd_intf_net -intf_net axi_adrv9026_rx_dma_m_dest_axi [get_bd_intf_pins m_dest_axi] [get_bd_intf_pins axi_adrv9026_rx_dma/m_dest_axi]
  connect_bd_intf_net -intf_net axi_adrv9026_tx_dma_m_src_axi [get_bd_intf_pins m_src_axi] [get_bd_intf_pins axi_adrv9026_tx_dma/m_src_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M05_AXI [get_bd_intf_pins s_axi1] [get_bd_intf_pins axi_adrv9026_tx_dma/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M08_AXI [get_bd_intf_pins s_axi] [get_bd_intf_pins axi_adrv9026_rx_dma/s_axi]
  connect_bd_intf_net -intf_net util_adrv9026_rx_cpack_packed_fifo_wr [get_bd_intf_pins axi_adrv9026_rx_dma/fifo_wr] [get_bd_intf_pins util_adrv9026_rx_cpack/packed_fifo_wr]

  # Create port connections
  connect_bd_net -net JESD_adc_data_0 [get_bd_pins fifo_wr_data_0] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_data_0]
  connect_bd_net -net JESD_adc_data_1 [get_bd_pins fifo_wr_data_1] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_data_1]
  connect_bd_net -net JESD_adc_data_2 [get_bd_pins fifo_wr_data_2] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_data_2]
  connect_bd_net -net JESD_adc_data_3 [get_bd_pins fifo_wr_data_3] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_data_3]
  connect_bd_net -net JESD_adc_data_4 [get_bd_pins fifo_wr_data_4] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_data_4]
  connect_bd_net -net JESD_adc_data_5 [get_bd_pins fifo_wr_data_5] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_data_5]
  connect_bd_net -net JESD_adc_data_6 [get_bd_pins fifo_wr_data_6] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_data_6]
  connect_bd_net -net JESD_adc_data_7 [get_bd_pins fifo_wr_data_7] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_data_7]
  connect_bd_net -net JESD_adc_enable_0 [get_bd_pins enable_0] [get_bd_pins util_adrv9026_rx_cpack/enable_0]
  connect_bd_net -net JESD_adc_enable_1 [get_bd_pins enable_1] [get_bd_pins util_adrv9026_rx_cpack/enable_1]
  connect_bd_net -net JESD_adc_enable_2 [get_bd_pins enable_2] [get_bd_pins util_adrv9026_rx_cpack/enable_2]
  connect_bd_net -net JESD_adc_enable_3 [get_bd_pins enable_3] [get_bd_pins util_adrv9026_rx_cpack/enable_3]
  connect_bd_net -net JESD_adc_enable_4 [get_bd_pins enable_4] [get_bd_pins util_adrv9026_rx_cpack/enable_4]
  connect_bd_net -net JESD_adc_enable_5 [get_bd_pins enable_5] [get_bd_pins util_adrv9026_rx_cpack/enable_5]
  connect_bd_net -net JESD_adc_enable_6 [get_bd_pins enable_6] [get_bd_pins util_adrv9026_rx_cpack/enable_6]
  connect_bd_net -net JESD_adc_enable_7 [get_bd_pins enable_7] [get_bd_pins util_adrv9026_rx_cpack/enable_7]
  connect_bd_net -net JESD_adc_valid_0 [get_bd_pins fifo_wr_en] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_en]
  connect_bd_net -net VCC_1_dout [get_bd_pins s_axis_valid] [get_bd_pins util_adrv9026_tx_upack/s_axis_valid]
  connect_bd_net -net axi_adrv9026_dacfifo_dac_data [get_bd_pins axi_adrv9026_dacfifo/dac_data] [get_bd_pins util_adrv9026_tx_upack/s_axis_data]
  connect_bd_net -net axi_adrv9026_dacfifo_dac_dunf [get_bd_pins dac_dunf] [get_bd_pins axi_adrv9026_dacfifo/dac_dunf]
  connect_bd_net -net axi_adrv9026_dacfifo_dma_ready [get_bd_pins axi_adrv9026_dacfifo/dma_ready] [get_bd_pins axi_adrv9026_tx_dma/m_axis_ready]
  connect_bd_net -net axi_adrv9026_rx_dma_irq [get_bd_pins irq] [get_bd_pins axi_adrv9026_rx_dma/irq]
  connect_bd_net -net axi_adrv9026_tx_dma_irq [get_bd_pins irq1] [get_bd_pins axi_adrv9026_tx_dma/irq]
  connect_bd_net -net axi_adrv9026_tx_dma_m_axis_data [get_bd_pins axi_adrv9026_dacfifo/dma_data] [get_bd_pins axi_adrv9026_tx_dma/m_axis_data]
  connect_bd_net -net axi_adrv9026_tx_dma_m_axis_last [get_bd_pins axi_adrv9026_dacfifo/dma_xfer_last] [get_bd_pins axi_adrv9026_tx_dma/m_axis_last]
  connect_bd_net -net axi_adrv9026_tx_dma_m_axis_valid [get_bd_pins axi_adrv9026_dacfifo/dma_valid] [get_bd_pins axi_adrv9026_tx_dma/m_axis_valid]
  connect_bd_net -net axi_adrv9026_tx_dma_m_axis_xfer_req [get_bd_pins axi_adrv9026_dacfifo/dma_xfer_req] [get_bd_pins axi_adrv9026_tx_dma/m_axis_xfer_req]
  connect_bd_net -net core_clk_1 [get_bd_pins core_clk] [get_bd_pins axi_adrv9026_dacfifo/dac_clk] [get_bd_pins axi_adrv9026_dacfifo/dma_clk] [get_bd_pins axi_adrv9026_rx_dma/fifo_wr_clk] [get_bd_pins axi_adrv9026_tx_dma/m_axis_aclk] [get_bd_pins util_adrv9026_rx_cpack/clk] [get_bd_pins util_adrv9026_tx_upack/clk]
  connect_bd_net -net core_clk_rstgen_peripheral_aresetn [get_bd_pins m_src_axi_aresetn] [get_bd_pins axi_adrv9026_tx_dma/m_src_axi_aresetn]
  connect_bd_net -net core_clk_rstgen_peripheral_reset [get_bd_pins reset] [get_bd_pins axi_adrv9026_dacfifo/dac_rst] [get_bd_pins axi_adrv9026_dacfifo/dma_rst] [get_bd_pins util_adrv9026_rx_cpack/reset] [get_bd_pins util_adrv9026_tx_upack/reset]
  connect_bd_net -net dac_fifo_bypass_1 [get_bd_pins dac_fifo_bypass] [get_bd_pins axi_adrv9026_dacfifo/bypass]
  connect_bd_net -net sys_250m_clk [get_bd_pins m_src_axi_aclk] [get_bd_pins axi_adrv9026_rx_dma/m_dest_axi_aclk] [get_bd_pins axi_adrv9026_tx_dma/m_src_axi_aclk]
  connect_bd_net -net sys_250m_resetn [get_bd_pins m_dest_axi_aresetn] [get_bd_pins axi_adrv9026_rx_dma/m_dest_axi_aresetn]
  connect_bd_net -net sys_cpu_clk [get_bd_pins s_axi_aclk] [get_bd_pins axi_adrv9026_rx_dma/s_axi_aclk] [get_bd_pins axi_adrv9026_tx_dma/s_axi_aclk]
  connect_bd_net -net sys_cpu_resetn [get_bd_pins s_axi_aresetn] [get_bd_pins axi_adrv9026_rx_dma/s_axi_aresetn] [get_bd_pins axi_adrv9026_tx_dma/s_axi_aresetn]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_0 [get_bd_pins enable_8] [get_bd_pins util_adrv9026_tx_upack/enable_0]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_1 [get_bd_pins enable_9] [get_bd_pins util_adrv9026_tx_upack/enable_1]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_2 [get_bd_pins enable_10] [get_bd_pins util_adrv9026_tx_upack/enable_2]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_3 [get_bd_pins enable_11] [get_bd_pins util_adrv9026_tx_upack/enable_3]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_4 [get_bd_pins enable_12] [get_bd_pins util_adrv9026_tx_upack/enable_4]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_5 [get_bd_pins enable_13] [get_bd_pins util_adrv9026_tx_upack/enable_5]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_6 [get_bd_pins enable_14] [get_bd_pins util_adrv9026_tx_upack/enable_6]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_7 [get_bd_pins enable_15] [get_bd_pins util_adrv9026_tx_upack/enable_7]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_valid_0 [get_bd_pins fifo_rd_en] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_en]
  connect_bd_net -net util_adrv9026_rx_cpack_fifo_wr_overflow [get_bd_pins fifo_wr_overflow] [get_bd_pins util_adrv9026_rx_cpack/fifo_wr_overflow]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_0 [get_bd_pins fifo_rd_data_0] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_data_0]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_1 [get_bd_pins fifo_rd_data_1] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_data_1]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_2 [get_bd_pins fifo_rd_data_2] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_data_2]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_3 [get_bd_pins fifo_rd_data_3] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_data_3]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_4 [get_bd_pins fifo_rd_data_4] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_data_4]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_5 [get_bd_pins fifo_rd_data_5] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_data_5]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_6 [get_bd_pins fifo_rd_data_6] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_data_6]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_7 [get_bd_pins fifo_rd_data_7] [get_bd_pins util_adrv9026_tx_upack/fifo_rd_data_7]
  connect_bd_net -net util_adrv9026_tx_upack_s_axis_ready [get_bd_pins axi_adrv9026_dacfifo/dac_valid] [get_bd_pins util_adrv9026_tx_upack/s_axis_ready]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set core_clk [ create_bd_port -dir I core_clk ]
  set dac_fifo_bypass [ create_bd_port -dir I dac_fifo_bypass ]
  set gpio_i [ create_bd_port -dir I -from 94 -to 0 gpio_i ]
  set gpio_o [ create_bd_port -dir O -from 94 -to 0 gpio_o ]
  set gpio_t [ create_bd_port -dir O -from 94 -to 0 gpio_t ]
  set rx_data_0_n [ create_bd_port -dir I rx_data_0_n ]
  set rx_data_0_p [ create_bd_port -dir I rx_data_0_p ]
  set rx_data_1_n [ create_bd_port -dir I rx_data_1_n ]
  set rx_data_1_p [ create_bd_port -dir I rx_data_1_p ]
  set rx_data_2_n [ create_bd_port -dir I rx_data_2_n ]
  set rx_data_2_p [ create_bd_port -dir I rx_data_2_p ]
  set rx_data_3_n [ create_bd_port -dir I rx_data_3_n ]
  set rx_data_3_p [ create_bd_port -dir I rx_data_3_p ]
  set rx_data_4_n [ create_bd_port -dir I rx_data_4_n ]
  set rx_data_4_p [ create_bd_port -dir I rx_data_4_p ]
  set rx_data_5_n [ create_bd_port -dir I rx_data_5_n ]
  set rx_data_5_p [ create_bd_port -dir I rx_data_5_p ]
  set rx_data_6_n [ create_bd_port -dir I rx_data_6_n ]
  set rx_data_6_p [ create_bd_port -dir I rx_data_6_p ]
  set rx_data_7_n [ create_bd_port -dir I rx_data_7_n ]
  set rx_data_7_p [ create_bd_port -dir I rx_data_7_p ]
  set rx_ref_clk_0 [ create_bd_port -dir I rx_ref_clk_0 ]
  set rx_sync_0 [ create_bd_port -dir O -from 0 -to 0 rx_sync_0 ]
  set rx_sync_1 [ create_bd_port -dir O -from 0 -to 0 rx_sync_1 ]
  set rx_sysref_0 [ create_bd_port -dir I rx_sysref_0 ]
  set spi0_csn [ create_bd_port -dir O -from 2 -to 0 spi0_csn ]
  set spi0_miso [ create_bd_port -dir I spi0_miso ]
  set spi0_mosi [ create_bd_port -dir O spi0_mosi ]
  set spi0_sclk [ create_bd_port -dir O spi0_sclk ]
  set spi1_csn [ create_bd_port -dir O -from 2 -to 0 spi1_csn ]
  set spi1_miso [ create_bd_port -dir I spi1_miso ]
  set spi1_mosi [ create_bd_port -dir O spi1_mosi ]
  set spi1_sclk [ create_bd_port -dir O spi1_sclk ]
  set tx_data_0_n [ create_bd_port -dir O tx_data_0_n ]
  set tx_data_0_p [ create_bd_port -dir O tx_data_0_p ]
  set tx_data_1_n [ create_bd_port -dir O tx_data_1_n ]
  set tx_data_1_p [ create_bd_port -dir O tx_data_1_p ]
  set tx_data_2_n [ create_bd_port -dir O tx_data_2_n ]
  set tx_data_2_p [ create_bd_port -dir O tx_data_2_p ]
  set tx_data_3_n [ create_bd_port -dir O tx_data_3_n ]
  set tx_data_3_p [ create_bd_port -dir O tx_data_3_p ]
  set tx_data_4_n [ create_bd_port -dir O tx_data_4_n ]
  set tx_data_4_p [ create_bd_port -dir O tx_data_4_p ]
  set tx_data_5_n [ create_bd_port -dir O tx_data_5_n ]
  set tx_data_5_p [ create_bd_port -dir O tx_data_5_p ]
  set tx_data_6_n [ create_bd_port -dir O tx_data_6_n ]
  set tx_data_6_p [ create_bd_port -dir O tx_data_6_p ]
  set tx_data_7_n [ create_bd_port -dir O tx_data_7_n ]
  set tx_data_7_p [ create_bd_port -dir O tx_data_7_p ]
  set tx_ref_clk_0 [ create_bd_port -dir I tx_ref_clk_0 ]
  set tx_sync_0 [ create_bd_port -dir I -from 0 -to 0 tx_sync_0 ]
  set tx_sync_1 [ create_bd_port -dir I -from 0 -to 0 tx_sync_1 ]
  set tx_sysref_0 [ create_bd_port -dir I tx_sysref_0 ]

  # Create instance: DMA
  create_hier_cell_DMA [current_bd_instance .] DMA

  # Create instance: JESD
  create_hier_cell_JESD [current_bd_instance .] JESD

  # Create instance: PS
  create_hier_cell_PS [current_bd_instance .] PS

  # Create instance: RST_SUBSYSTEM
  create_hier_cell_RST_SUBSYSTEM [current_bd_instance .] RST_SUBSYSTEM

  # Create instance: SYS_ID
  create_hier_cell_SYS_ID [current_bd_instance .] SYS_ID

  # Create interface connections
  connect_bd_intf_net -intf_net PS_M01_AXI [get_bd_intf_pins JESD/s_axi5] [get_bd_intf_pins PS/M01_AXI]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_dma_m_dest_axi [get_bd_intf_pins DMA/m_dest_axi] [get_bd_intf_pins PS/S00_AXI1]
  connect_bd_intf_net -intf_net axi_adrv9026_rx_xcvr_m_axi [get_bd_intf_pins JESD/m_axi] [get_bd_intf_pins PS/S00_AXI2]
  connect_bd_intf_net -intf_net axi_adrv9026_tx_dma_m_src_axi [get_bd_intf_pins DMA/m_src_axi] [get_bd_intf_pins PS/S00_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M00_AXI [get_bd_intf_pins PS/M00_AXI] [get_bd_intf_pins SYS_ID/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M02_AXI [get_bd_intf_pins JESD/s_axi2] [get_bd_intf_pins PS/M02_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M03_AXI [get_bd_intf_pins JESD/s_axi] [get_bd_intf_pins PS/M03_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M04_AXI [get_bd_intf_pins JESD/s_axi4] [get_bd_intf_pins PS/M04_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M05_AXI [get_bd_intf_pins DMA/s_axi1] [get_bd_intf_pins PS/M05_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M06_AXI [get_bd_intf_pins JESD/s_axi1] [get_bd_intf_pins PS/M06_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M07_AXI [get_bd_intf_pins JESD/s_axi3] [get_bd_intf_pins PS/M07_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M08_AXI [get_bd_intf_pins DMA/s_axi] [get_bd_intf_pins PS/M08_AXI]

  # Create port connections
  connect_bd_net -net JESD_adc_data_0 [get_bd_pins DMA/fifo_wr_data_0] [get_bd_pins JESD/adc_data_0]
  connect_bd_net -net JESD_adc_data_1 [get_bd_pins DMA/fifo_wr_data_1] [get_bd_pins JESD/adc_data_1]
  connect_bd_net -net JESD_adc_data_2 [get_bd_pins DMA/fifo_wr_data_2] [get_bd_pins JESD/adc_data_2]
  connect_bd_net -net JESD_adc_data_3 [get_bd_pins DMA/fifo_wr_data_3] [get_bd_pins JESD/adc_data_3]
  connect_bd_net -net JESD_adc_data_4 [get_bd_pins DMA/fifo_wr_data_4] [get_bd_pins JESD/adc_data_4]
  connect_bd_net -net JESD_adc_data_5 [get_bd_pins DMA/fifo_wr_data_5] [get_bd_pins JESD/adc_data_5]
  connect_bd_net -net JESD_adc_data_6 [get_bd_pins DMA/fifo_wr_data_6] [get_bd_pins JESD/adc_data_6]
  connect_bd_net -net JESD_adc_data_7 [get_bd_pins DMA/fifo_wr_data_7] [get_bd_pins JESD/adc_data_7]
  connect_bd_net -net JESD_adc_enable_0 [get_bd_pins DMA/enable_0] [get_bd_pins JESD/adc_enable_0]
  connect_bd_net -net JESD_adc_enable_1 [get_bd_pins DMA/enable_1] [get_bd_pins JESD/adc_enable_1]
  connect_bd_net -net JESD_adc_enable_2 [get_bd_pins DMA/enable_2] [get_bd_pins JESD/adc_enable_2]
  connect_bd_net -net JESD_adc_enable_3 [get_bd_pins DMA/enable_3] [get_bd_pins JESD/adc_enable_3]
  connect_bd_net -net JESD_adc_enable_4 [get_bd_pins DMA/enable_4] [get_bd_pins JESD/adc_enable_4]
  connect_bd_net -net JESD_adc_enable_5 [get_bd_pins DMA/enable_5] [get_bd_pins JESD/adc_enable_5]
  connect_bd_net -net JESD_adc_enable_6 [get_bd_pins DMA/enable_6] [get_bd_pins JESD/adc_enable_6]
  connect_bd_net -net JESD_adc_enable_7 [get_bd_pins DMA/enable_7] [get_bd_pins JESD/adc_enable_7]
  connect_bd_net -net JESD_adc_valid_0 [get_bd_pins DMA/fifo_wr_en] [get_bd_pins JESD/adc_valid_0]
  connect_bd_net -net JESD_adrv2_rx_sync_0 [get_bd_ports rx_sync_1] [get_bd_pins JESD/adrv2_rx_sync]
  connect_bd_net -net PS_spi0_csn [get_bd_ports spi0_csn] [get_bd_pins PS/spi0_csn]
  connect_bd_net -net PS_spi1_csn [get_bd_ports spi1_csn] [get_bd_pins PS/spi1_csn]
  connect_bd_net -net VCC_1_dout [get_bd_pins DMA/s_axis_valid] [get_bd_pins PS/emio_spi0_ss_i_n]
  connect_bd_net -net adrv2_sync_0_1 [get_bd_ports tx_sync_1] [get_bd_pins JESD/adrv2_sync]
  connect_bd_net -net axi_adrv9026_dacfifo_dac_dunf [get_bd_pins DMA/dac_dunf] [get_bd_pins JESD/dac_dunf]
  connect_bd_net -net axi_adrv9026_rx_dma_irq [get_bd_pins DMA/irq] [get_bd_pins PS/In6]
  connect_bd_net -net axi_adrv9026_rx_jesd_irq [get_bd_pins JESD/irq_adrv_rx] [get_bd_pins PS/In3]
  connect_bd_net -net axi_adrv9026_rx_jesd_sync [get_bd_ports rx_sync_0] [get_bd_pins JESD/adrv1_rx_sync]
  connect_bd_net -net axi_adrv9026_tx_dma_irq [get_bd_pins DMA/irq1] [get_bd_pins PS/In5]
  connect_bd_net -net axi_adrv9026_tx_jesd_irq [get_bd_pins JESD/irq_adrv_tx] [get_bd_pins PS/In2]
  connect_bd_net -net core_clk_1 [get_bd_ports core_clk] [get_bd_pins DMA/core_clk] [get_bd_pins JESD/core_clk] [get_bd_pins RST_SUBSYSTEM/core_clk]
  connect_bd_net -net dac_fifo_bypass_1 [get_bd_ports dac_fifo_bypass] [get_bd_pins DMA/dac_fifo_bypass]
  connect_bd_net -net gpio_i_1 [get_bd_ports gpio_i] [get_bd_pins PS/gpio_i]
  connect_bd_net -net m_src_axi_aresetn_1 [get_bd_pins DMA/m_src_axi_aresetn] [get_bd_pins RST_SUBSYSTEM/peripheral_aresetn3]
  connect_bd_net -net reset_1 [get_bd_pins DMA/reset] [get_bd_pins RST_SUBSYSTEM/peripheral_reset3]
  connect_bd_net -net rx_data_0_n_1 [get_bd_ports rx_data_0_n] [get_bd_pins JESD/rx_data_0_n]
  connect_bd_net -net rx_data_0_p_1 [get_bd_ports rx_data_0_p] [get_bd_pins JESD/rx_data_0_p]
  connect_bd_net -net rx_data_1_n_1 [get_bd_ports rx_data_1_n] [get_bd_pins JESD/rx_data_1_n]
  connect_bd_net -net rx_data_1_p_1 [get_bd_ports rx_data_1_p] [get_bd_pins JESD/rx_data_1_p]
  connect_bd_net -net rx_data_2_n_1 [get_bd_ports rx_data_2_n] [get_bd_pins JESD/rx_data_2_n]
  connect_bd_net -net rx_data_2_p_1 [get_bd_ports rx_data_2_p] [get_bd_pins JESD/rx_data_2_p]
  connect_bd_net -net rx_data_3_n_1 [get_bd_ports rx_data_3_n] [get_bd_pins JESD/rx_data_3_n]
  connect_bd_net -net rx_data_3_p_1 [get_bd_ports rx_data_3_p] [get_bd_pins JESD/rx_data_3_p]
  connect_bd_net -net rx_data_4_n_0_1 [get_bd_ports rx_data_4_n] [get_bd_pins JESD/rx_data_4_n]
  connect_bd_net -net rx_data_4_p_0_1 [get_bd_ports rx_data_4_p] [get_bd_pins JESD/rx_data_4_p]
  connect_bd_net -net rx_data_5_n_0_1 [get_bd_ports rx_data_5_n] [get_bd_pins JESD/rx_data_5_n]
  connect_bd_net -net rx_data_5_p_0_1 [get_bd_ports rx_data_5_p] [get_bd_pins JESD/rx_data_5_p]
  connect_bd_net -net rx_data_6_n_0_1 [get_bd_ports rx_data_6_n] [get_bd_pins JESD/rx_data_6_n]
  connect_bd_net -net rx_data_6_p_0_1 [get_bd_ports rx_data_6_p] [get_bd_pins JESD/rx_data_6_p]
  connect_bd_net -net rx_data_7_n_0_1 [get_bd_ports rx_data_7_n] [get_bd_pins JESD/rx_data_7_n]
  connect_bd_net -net rx_data_7_p_0_1 [get_bd_ports rx_data_7_p] [get_bd_pins JESD/rx_data_7_p]
  connect_bd_net -net rx_ref_clk_0_1 [get_bd_ports rx_ref_clk_0] [get_bd_pins JESD/rx_ref_clk_0]
  connect_bd_net -net spi0_miso_1 [get_bd_ports spi0_miso] [get_bd_pins PS/spi0_miso]
  connect_bd_net -net spi1_miso_1 [get_bd_ports spi1_miso] [get_bd_pins PS/spi1_miso]
  connect_bd_net -net sync_1 [get_bd_ports tx_sync_0] [get_bd_pins JESD/adrv1_sync]
  connect_bd_net -net sys_250m_clk [get_bd_pins DMA/m_src_axi_aclk] [get_bd_pins PS/pl_clk1] [get_bd_pins RST_SUBSYSTEM/slowest_sync_clk]
  connect_bd_net -net sys_250m_reset -boundary_type upper [get_bd_pins RST_SUBSYSTEM/peripheral_reset]
  connect_bd_net -net sys_250m_resetn [get_bd_pins DMA/m_dest_axi_aresetn] [get_bd_pins PS/aresetn] [get_bd_pins RST_SUBSYSTEM/peripheral_aresetn]
  connect_bd_net -net sys_500m_clk [get_bd_pins PS/pl_clk2] [get_bd_pins RST_SUBSYSTEM/slowest_sync_clk2]
  connect_bd_net -net sys_500m_reset -boundary_type upper [get_bd_pins RST_SUBSYSTEM/peripheral_reset2]
  connect_bd_net -net sys_500m_resetn -boundary_type upper [get_bd_pins RST_SUBSYSTEM/peripheral_aresetn2]
  connect_bd_net -net sys_cpu_clk [get_bd_pins DMA/s_axi_aclk] [get_bd_pins JESD/s_axi_aclk] [get_bd_pins PS/pl_clk0] [get_bd_pins RST_SUBSYSTEM/slowest_sync_clk1] [get_bd_pins SYS_ID/clk]
  connect_bd_net -net sys_cpu_reset -boundary_type upper [get_bd_pins RST_SUBSYSTEM/peripheral_reset1]
  connect_bd_net -net sys_cpu_resetn [get_bd_pins DMA/s_axi_aresetn] [get_bd_pins JESD/s_axi_aresetn] [get_bd_pins PS/aresetn1] [get_bd_pins RST_SUBSYSTEM/peripheral_aresetn1] [get_bd_pins SYS_ID/s_axi_aresetn]
  connect_bd_net -net sys_ps8_emio_gpio_o [get_bd_ports gpio_o] [get_bd_pins PS/gpio_o]
  connect_bd_net -net sys_ps8_emio_gpio_t [get_bd_ports gpio_t] [get_bd_pins PS/gpio_t]
  connect_bd_net -net sys_ps8_emio_spi0_m_o [get_bd_ports spi0_mosi] [get_bd_pins PS/spi0_mosi]
  connect_bd_net -net sys_ps8_emio_spi0_sclk_o [get_bd_ports spi0_sclk] [get_bd_pins PS/spi0_sclk]
  connect_bd_net -net sys_ps8_emio_spi1_m_o [get_bd_ports spi1_mosi] [get_bd_pins PS/spi1_mosi]
  connect_bd_net -net sys_ps8_emio_spi1_sclk_o [get_bd_ports spi1_sclk] [get_bd_pins PS/spi1_sclk]
  connect_bd_net -net sys_ps8_pl_resetn0 [get_bd_pins PS/pl_resetn0] [get_bd_pins RST_SUBSYSTEM/ext_reset_in]
  connect_bd_net -net sysref_1 [get_bd_ports tx_sysref_0] [get_bd_pins JESD/tx_sysref_0]
  connect_bd_net -net sysref_2 [get_bd_ports rx_sysref_0] [get_bd_pins JESD/rx_sysref_0]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_0 [get_bd_pins DMA/enable_8] [get_bd_pins JESD/dac_enable_0]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_1 [get_bd_pins DMA/enable_9] [get_bd_pins JESD/dac_enable_1]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_2 [get_bd_pins DMA/enable_10] [get_bd_pins JESD/dac_enable_2]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_3 [get_bd_pins DMA/enable_11] [get_bd_pins JESD/dac_enable_3]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_4 [get_bd_pins DMA/enable_12] [get_bd_pins JESD/dac_enable_4]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_5 [get_bd_pins DMA/enable_13] [get_bd_pins JESD/dac_enable_5]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_6 [get_bd_pins DMA/enable_14] [get_bd_pins JESD/dac_enable_6]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_enable_7 [get_bd_pins DMA/enable_15] [get_bd_pins JESD/dac_enable_7]
  connect_bd_net -net tx_adrv9026_tpl_core_dac_valid_0 [get_bd_pins DMA/fifo_rd_en] [get_bd_pins JESD/dac_valid_0]
  connect_bd_net -net tx_ref_clk_0_1 [get_bd_ports tx_ref_clk_0] [get_bd_pins JESD/tx_ref_clk_0]
  connect_bd_net -net util_adrv9026_rx_cpack_fifo_wr_overflow [get_bd_pins DMA/fifo_wr_overflow] [get_bd_pins JESD/adc_dovf]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_0 [get_bd_pins DMA/fifo_rd_data_0] [get_bd_pins JESD/dac_data_0]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_1 [get_bd_pins DMA/fifo_rd_data_1] [get_bd_pins JESD/dac_data_1]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_2 [get_bd_pins DMA/fifo_rd_data_2] [get_bd_pins JESD/dac_data_2]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_3 [get_bd_pins DMA/fifo_rd_data_3] [get_bd_pins JESD/dac_data_3]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_4 [get_bd_pins DMA/fifo_rd_data_4] [get_bd_pins JESD/dac_data_4]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_5 [get_bd_pins DMA/fifo_rd_data_5] [get_bd_pins JESD/dac_data_5]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_6 [get_bd_pins DMA/fifo_rd_data_6] [get_bd_pins JESD/dac_data_6]
  connect_bd_net -net util_adrv9026_tx_upack_fifo_rd_data_7 [get_bd_pins DMA/fifo_rd_data_7] [get_bd_pins JESD/dac_data_7]
  connect_bd_net -net util_adrv9026_xcvr_tx_0_n [get_bd_ports tx_data_0_n] [get_bd_pins JESD/tx_data_0_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_0_p [get_bd_ports tx_data_0_p] [get_bd_pins JESD/tx_data_0_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_1_n [get_bd_ports tx_data_1_n] [get_bd_pins JESD/tx_data_1_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_1_p [get_bd_ports tx_data_1_p] [get_bd_pins JESD/tx_data_1_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_2_n [get_bd_ports tx_data_2_n] [get_bd_pins JESD/tx_data_2_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_2_p [get_bd_ports tx_data_2_p] [get_bd_pins JESD/tx_data_2_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_3_n [get_bd_ports tx_data_3_n] [get_bd_pins JESD/tx_data_3_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_3_p [get_bd_ports tx_data_3_p] [get_bd_pins JESD/tx_data_3_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_4_n [get_bd_ports tx_data_4_n] [get_bd_pins JESD/tx_data_4_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_4_p [get_bd_ports tx_data_4_p] [get_bd_pins JESD/tx_data_4_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_5_n [get_bd_ports tx_data_5_n] [get_bd_pins JESD/tx_data_5_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_5_p [get_bd_ports tx_data_5_p] [get_bd_pins JESD/tx_data_5_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_6_n [get_bd_ports tx_data_6_n] [get_bd_pins JESD/tx_data_6_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_6_p [get_bd_ports tx_data_6_p] [get_bd_pins JESD/tx_data_6_p]
  connect_bd_net -net util_adrv9026_xcvr_tx_7_n [get_bd_ports tx_data_7_n] [get_bd_pins JESD/tx_data_7_n]
  connect_bd_net -net util_adrv9026_xcvr_tx_7_p [get_bd_ports tx_data_7_p] [get_bd_pins JESD/tx_data_7_p]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DMA/axi_adrv9026_rx_dma/m_dest_axi] [get_bd_addr_segs PS/sys_ps8/SAXIGP4/HP2_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DMA/axi_adrv9026_tx_dma/m_src_axi] [get_bd_addr_segs PS/sys_ps8/SAXIGP5/HP3_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces JESD/axi_adrv_rx_xcvr/m_axi] [get_bd_addr_segs PS/sys_ps8/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0x84A00000 -range 0x00002000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs JESD/rx_adrv_tpl_core/adc_tpl_core/s_axi/axi_lite] -force
  assign_bd_address -offset 0x9C400000 -range 0x00001000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs DMA/axi_adrv9026_rx_dma/s_axi/axi_lite] -force
  assign_bd_address -offset 0x9C420000 -range 0x00001000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs DMA/axi_adrv9026_tx_dma/s_axi/axi_lite] -force
  assign_bd_address -offset 0x84A60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs JESD/axi_adrv_rx_xcvr/s_axi/axi_lite] -force
  assign_bd_address -offset 0x84A80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs JESD/axi_adrv_tx_xcvr/s_axi/axi_lite] -force
  assign_bd_address -offset 0x85000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs SYS_ID/axi_sysid_0/s_axi/axi_lite] -force
  assign_bd_address -offset 0x84A04000 -range 0x00002000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs JESD/tx_adrv_tpl_core/dac_tpl_core/s_axi/axi_lite] -force
  assign_bd_address -offset 0x84AA0000 -range 0x00004000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs JESD/axi_adrv_rx_jesd/rx_axi/s_axi/axi_lite] -force
  assign_bd_address -offset 0x84A90000 -range 0x00004000 -target_address_space [get_bd_addr_spaces PS/sys_ps8/Data] [get_bd_addr_segs JESD/axi_adrv_tx_jesd/tx_axi/s_axi/axi_lite] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

