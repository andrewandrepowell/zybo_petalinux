connect -url tcp:127.0.0.1:3121
source /opt/Xilinx/Projects/zybo_petalinux_vga/zybo_petalinux_vga.sdk/block_design_wrapper_hw_platform_0/ps7_init.tcl
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Digilent Zybo 210279759071A"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo 210279759071A" && level==0} -index 1
fpga -file /opt/Xilinx/Projects/zybo_petalinux_vga/zybo_petalinux_vga.sdk/block_design_wrapper_hw_platform_0/block_design_wrapper.bit
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Digilent Zybo 210279759071A"} -index 0
loadhw /opt/Xilinx/Projects/zybo_petalinux_vga/zybo_petalinux_vga.sdk/block_design_wrapper_hw_platform_0/system.hdf
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Digilent Zybo 210279759071A"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo 210279759071A"} -index 0
dow /opt/Xilinx/Projects/zybo_petalinux_vga/zybo_petalinux_vga.sdk/testapp/Debug/testapp.elf
bpadd -addr &main
