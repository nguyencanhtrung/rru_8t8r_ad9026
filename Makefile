# ----------------------------------------------------------------------------
# 
# Project   : 5G RRU 8T8R
# Filename  : Makefile
# 
# Author    : Nguyen Canh Trung
# Email     : nguyencanhtrung 'at' me 'dot' com
# Date      : 2024-05-17 10:39:18
# Last Modified : 2024-05-17 16:03:11
# Modified By   : Nguyen Canh Trung
# 
# Description: 
# 
# HISTORY:
# Date      	By	Comments
# ----------	---	---------------------------------------------------------
# 2024-05-17	NCT	File created!
# ----------------------------------------------------------------------------
FPGA_FNM    ?= system.bit

proj_name   = system
proj_path   = wsp
proj_file   = $(proj_path)/$(proj_name).xpr
proj_time   = $(proj_path)/timestamp.txt
synthesis   = $(proj_path)/$(proj_name).runs/synth_1/riscv_wrapper.dcp
bitstream   = $(proj_path)/$(proj_name).runs/impl_1/$(FPGA_FNM)

vivado  = env XILINX_LOCAL_USER_DATA=no vivado -mode batch -nojournal -nolog -notrace -quiet

SCR_DIR := ./scripts
M_DEPS := ${SCR_DIR}/project_setting.tcl
M_DEPS += ${SCR_DIR}/project_init.tcl

M_FLIST += *.log
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += .Xil
M_FLIST += *.str
M_FLIST += *.xml
M_FLIST += *.html
M_FLIST += ./wsp


# Multi-threading appears broken in Vivado. It causes intermittent failures.
MAX_THREADS ?= 1

.PHONY: help all setup build gui clean

wsp/run_vivado.tcl: $(M_DEPS)
	mkdir -p wsp
	cat ./scripts/project_setting.tcl >  $@
	cat ./scripts/project_init.tcl    >> $@

$(proj_time): wsp/run_vivado.tcl
	if [ ! -e $(proj_file) ] ; then $(vivado) -source wsp/run_vivado.tcl || ( rm -rf $(proj_path) ; exit 1 ) ; fi
	date >$@

project: $(proj_time)   	## Create Vivado project

$(synthesis): $(proj_time)
	echo "set_param general.maxThreads $(MAX_THREADS)" >>$(proj_path)/make-synthesis.tcl
	echo "open_project $(proj_file)" >$(proj_path)/make-synthesis.tcl
	echo "update_compile_order -fileset sources_1" >>$(proj_path)/make-synthesis.tcl
	echo "reset_run synth_1" >>$(proj_path)/make-synthesis.tcl
	echo "launch_runs -jobs $(MAX_THREADS) synth_1" >>$(proj_path)/make-synthesis.tcl
	echo "wait_on_run synth_1" >>$(proj_path)/make-synthesis.tcl
	$(vivado) -source $(proj_path)/make-synthesis.tcl
	if find $(proj_path) -name "*.log" -exec cat {} \; | grep 'ERROR: ' ; then exit 1 ; fi

$(bitstream): $(synthesis)
	echo "set_param general.maxThreads $(MAX_THREADS)" >>$(proj_path)/make-bitstream.tcl
	echo "open_project $(proj_file)" >$(proj_path)/make-bitstream.tcl
	echo "reset_run impl_1" >>$(proj_path)/make-bitstream.tcl
	echo "launch_runs -to_step write_bitstream -jobs $(MAX_THREADS) impl_1" >>$(proj_path)/make-bitstream.tcl
	echo "wait_on_run impl_1" >>$(proj_path)/make-bitstream.tcl
	$(vivado) -source $(proj_path)/make-bitstream.tcl
	if find $(proj_path) -name "*.log" -exec cat {} \; | grep 'ERROR: ' ; then exit 1 ; fi

bitstream: $(bitstream)  	## Generate bitstream 

gui: $(proj_time)          	## Open Vivado in GUI mode (auto create project if not existed yet)
	vivado $(proj_file)

clean:         				## Clean project source file
	rm -rf $(M_FLIST)

help:          				## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
