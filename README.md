# zybo_petalinux
Small projects intended to run on the Digilent Zybo development board, utilizing PetaLinux on the Zynq's ARM processor.

Author: Andrew Powell
Contact: andrewandrepowell2@gmail.com
Blog: www.powellprojectshowcase.com

This readme will be updated as more projects are added to the repository. For all projects, I will try and rely only on the 2016.2 versions of the Vivado Design Suite and PetaLinux Tools for all software and hardware development. The intended platform is of course the Xilinx Z-7010 Zynq All-Programmable SoC on the Digilent Zybo board. Many of the projects will mainly depend on the peripherals included on the Zybo. However, in an effort to develop more interesting projects, I will likely have many projects for which other peripherals will be needed.

The rest of this readme will include notes on the specific projects presented in this repository. 

///////////////////////////////
// zybo_petalinux_gpio_sysfs //
///////////////////////////////

An introductory project, demonstrating how the Linux GPIO SysFs driver can be used to control the AXI GPIO IP core in programmable logic.
