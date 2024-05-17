# ----------------------------------------------------------------------------
# 
# Project   : 
# Filename  : project_setting
# 
# Author    : Nguyen Canh Trung
# Email     : nguyencanhtrung 'at' me 'dot' com
# Date      : 2024-05-17 11:19:30
# Last Modified : 2024-05-17 11:20:20
# Modified By   : Nguyen Canh Trung
# 
# Description: 
# 
# HISTORY:
# Date      	By	Comments
# ----------	---	---------------------------------------------------------
# 2024-05-17	NCT	 File created
# ----------------------------------------------------------------------------

# Design name setting / Project name setting
set design system

# Project directory settting
set projdir .

# Workspace settting
set wspdir ./wsp

# Device name/ part name setting
set partname "xczu15eg-ffvb1156-2-i"
# set board_part "xilinx.com:zcu102:part0:2.0"

set ip_repos [list "./ip" \
             ]

# HDL files list, leave empty if no additional HDL files
set hdl_files [list "./hdl/ad_iobuf.v"        \
                    "./hdl/system_top.v"      \
              ]

# XDC files list, leave empty if no additional XDC files
set xdc_files [list "./xdc/system_constr.xdc"    \
              ]

# Custom parameter for synthesis/simulation
