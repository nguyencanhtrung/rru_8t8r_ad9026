# ----------------------------------------------------------------------------
# 
# Project   : 5G RRU 8T8R
# Filename  : project_init
# 
# Author    : Nguyen Canh Trung
# Email     : nguyencanhtrung 'at' me 'dot' com
# Date      : 2024-05-17 11:19:30
# Last Modified : 2024-05-17 11:28:07
# Modified By   : Nguyen Canh Trung
# 
# Description: 
# 
# HISTORY:
# Date      	By	Comments
# ----------	---	---------------------------------------------------------
# 2024-05-17	NCT	File created
# ----------------------------------------------------------------------------
#-----------------------------------------------------------
# Project creation
#-----------------------------------------------------------
create_project -force $design $wspdir -part $partname
set_property target_language verilog [current_project]

if {[info exists board_part]} {
    set_property board_part $board_part [current_project]
}

#-----------------------------------------------------------
# Add user IP Repos
#-----------------------------------------------------------
set user_repos [get_property ip_repo_paths [current_project]]
set_property ip_repo_paths "$ip_repos $user_repos" [current_project]
update_ip_catalog

#-----------------------------------------------------------
# Log files directories
#-----------------------------------------------------------
set report_dir  $wspdir/reports
set results_dir $wspdir/results
if ![file exists $report_dir ]  {file mkdir $report_dir }
if ![file exists $results_dir]  {file mkdir $results_dir}

#-----------------------------------------------------------
# hdl & xdc sources adding
#-----------------------------------------------------------
# hdl sources
if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
}

if {[llength $hdl_files] != 0} {
    add_files -norecurse -fileset [get_filesets sources_1] $hdl_files
}

# constraints
if {[string equal [get_filesets -quiet constrs_1] ""]} {
    create_fileset -constrset constrs_1
}
if {[llength $xdc_files] != 0} {
    add_files -norecurse -fileset [get_filesets constrs_1] $xdc_files
}

#-----------------------------------------------------------
# Create block design
#-----------------------------------------------------------
# create_bd_design "system"

source $projdir/bd/system_bd.tcl

make_wrapper -files [get_files $wspdir/${design}.srcs/sources_1/bd/system/system.bd] -top
set top_wrapper $wspdir/${design}.gen/sources_1/bd/system/hdl/system_wrapper.v
add_files -norecurse -fileset [get_filesets sources_1] $top_wrapper
