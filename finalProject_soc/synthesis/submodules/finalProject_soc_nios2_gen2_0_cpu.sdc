# Legal Notice: (C)2021 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	finalProject_soc_nios2_gen2_0_cpu 	finalProject_soc_nios2_gen2_0_cpu:*
set 	finalProject_soc_nios2_gen2_0_cpu_oci 	finalProject_soc_nios2_gen2_0_cpu_nios2_oci:the_finalProject_soc_nios2_gen2_0_cpu_nios2_oci
set 	finalProject_soc_nios2_gen2_0_cpu_oci_break 	finalProject_soc_nios2_gen2_0_cpu_nios2_oci_break:the_finalProject_soc_nios2_gen2_0_cpu_nios2_oci_break
set 	finalProject_soc_nios2_gen2_0_cpu_ocimem 	finalProject_soc_nios2_gen2_0_cpu_nios2_ocimem:the_finalProject_soc_nios2_gen2_0_cpu_nios2_ocimem
set 	finalProject_soc_nios2_gen2_0_cpu_oci_debug 	finalProject_soc_nios2_gen2_0_cpu_nios2_oci_debug:the_finalProject_soc_nios2_gen2_0_cpu_nios2_oci_debug
set 	finalProject_soc_nios2_gen2_0_cpu_wrapper 	finalProject_soc_nios2_gen2_0_cpu_debug_slave_wrapper:the_finalProject_soc_nios2_gen2_0_cpu_debug_slave_wrapper
set 	finalProject_soc_nios2_gen2_0_cpu_jtag_tck 	finalProject_soc_nios2_gen2_0_cpu_debug_slave_tck:the_finalProject_soc_nios2_gen2_0_cpu_debug_slave_tck
set 	finalProject_soc_nios2_gen2_0_cpu_jtag_sysclk 	finalProject_soc_nios2_gen2_0_cpu_debug_slave_sysclk:the_finalProject_soc_nios2_gen2_0_cpu_debug_slave_sysclk
set 	finalProject_soc_nios2_gen2_0_cpu_oci_path 	 [format "%s|%s" $finalProject_soc_nios2_gen2_0_cpu $finalProject_soc_nios2_gen2_0_cpu_oci]
set 	finalProject_soc_nios2_gen2_0_cpu_oci_break_path 	 [format "%s|%s" $finalProject_soc_nios2_gen2_0_cpu_oci_path $finalProject_soc_nios2_gen2_0_cpu_oci_break]
set 	finalProject_soc_nios2_gen2_0_cpu_ocimem_path 	 [format "%s|%s" $finalProject_soc_nios2_gen2_0_cpu_oci_path $finalProject_soc_nios2_gen2_0_cpu_ocimem]
set 	finalProject_soc_nios2_gen2_0_cpu_oci_debug_path 	 [format "%s|%s" $finalProject_soc_nios2_gen2_0_cpu_oci_path $finalProject_soc_nios2_gen2_0_cpu_oci_debug]
set 	finalProject_soc_nios2_gen2_0_cpu_jtag_tck_path 	 [format "%s|%s|%s" $finalProject_soc_nios2_gen2_0_cpu_oci_path $finalProject_soc_nios2_gen2_0_cpu_wrapper $finalProject_soc_nios2_gen2_0_cpu_jtag_tck]
set 	finalProject_soc_nios2_gen2_0_cpu_jtag_sysclk_path 	 [format "%s|%s|%s" $finalProject_soc_nios2_gen2_0_cpu_oci_path $finalProject_soc_nios2_gen2_0_cpu_wrapper $finalProject_soc_nios2_gen2_0_cpu_jtag_sysclk]
set 	finalProject_soc_nios2_gen2_0_cpu_jtag_sr 	 [format "%s|*sr" $finalProject_soc_nios2_gen2_0_cpu_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_oci_break_path|break_readreg*] -to [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_oci_debug_path|*resetlatch]     -to [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_jtag_sr[33]]
set_false_path -from [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_oci_debug_path|monitor_ready]  -to [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_jtag_sr[0]]
set_false_path -from [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_oci_debug_path|monitor_error]  -to [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_jtag_sr[34]]
set_false_path -from [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_ocimem_path|*MonDReg*] -to [get_keepers *$finalProject_soc_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from *$finalProject_soc_nios2_gen2_0_cpu_jtag_sr*    -to *$finalProject_soc_nios2_gen2_0_cpu_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$finalProject_soc_nios2_gen2_0_cpu_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$finalProject_soc_nios2_gen2_0_cpu_oci_debug_path|monitor_go
