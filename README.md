# zybo_petalinux
Small projects intended to run on the Digilent Zybo development board, utilizing PetaLinux on the Zynq's ARM processor.

Author: Andrew Powell
Contact: andrewandrepowell2@gmail.com
Blog: www.powellprojectshowcase.com

This readme will be updated as more projects are added to the repository. For all projects, I will try and rely only on the 2016.2 versions of the Vivado Design Suite and PetaLinux Tools for all software and hardware development. The intended platform is of course the Xilinx Z-7010 Zynq All-Programmable SoC on the Digilent Zybo board. In every project folder, there will be a folder named "petalinux_project". This folder will contain the respective PetaLinux project. For those not already familiar with the structure of the project folder, the applications are located under "petalinux_proj/components/apps/". Many of the projects will mainly depend on the peripherals included on the Zybo. However, in an effort to develop more interesting projects, I will likely have many projects for which other peripherals will be needed.

All projects of course can be booted through jtag, using the PetaLinux Tools. When mentioned, a few projects will have boot files for flash located in the Vivado project folder under "zybo_petalinux_<PROJECT NAME>.sdk/". 

The rest of this readme will include notes on the specific projects presented in this repository. 

///////////////////////////////
// zybo_petalinux_gpio_sysfs //
///////////////////////////////

Video Demonstration Link: https://youtu.be/duwX_kTc8K8

An introductory project, demonstrating how the Linux GPIO SysFs driver can be used to control the AXI GPIO IP core in programmable logic.

////////////////////////////
// zybo_petalinux_i2c_lcd //
////////////////////////////

Video Demonstration Link: https://youtu.be/8wdfF9qOdjY

The "mylcd" application will allow the user to type input onto a connected 
SaintSmart LCD 2004 through the terminal. Libraries from Arduino and SaintSmart are modified so that they depend on the Linux I2CDev SysFs driver for I2C transactions. 

//////////////////////////
// zybo_petalinux_piano //
//////////////////////////

Running "mywave" allows the user to play an octave of the C scale through the Zybo's audio codec. Optionally, the user can view a sample from the Digilent PmodMIC. The original plan was to record sounds with the PmodMIC, however real-time recording with the SPIDev SysFs driver proved problematic in a pure software application in Linux. In a future project, a core that includes a FIFO needs to be developed. 

This project also takes advantage of the ADI AXI I2S core taken from the Digilent Zybo Base Example. A Linux user-space driver ( i.e. a library that needs the Linux API mmap(2) to map virtual memory to physical memory ) is created so that the application can access the ADI core. 

Finally, ( with a great deal of effort ) a boot file is generated so that the entire image ( including bitstream ) can be loaded at startup.

////////////////////////
// zybo_petalinux_vga //
////////////////////////

Video Demonstration Link: https://youtu.be/uAeAvn65sWQ

Apart from the demonstration applications themselves, there are few differences between the vga project and the last few projects. All the development of the Linux applications are done with the SDK. So, the source code and respective application projects can be found under the "zybo_petalinux_vga/zybo_petalinux_vga.sdk" folder. The binary and images are placed in the "zybo_petalinux/zybo_petalinux_vga/petalinux_proj/components/apps/demos" application. The demo applications can be found in "/demos/" in the root file system.

There are actually three different demonstration applications, all of which demonstrate how the AXI VDMA and the AXI Display Port can be utilized to drive the VGA ( or the HDMI ) interface. "digilent_example_linux_0.elf" runs a ported version of the example found in the Digilent Base Example. "my_example_linux_0.elf" runs a similar but different application that allows the user to switch among three different frame buffers defined for the AXI Display Port driver. "opencv_linux_0.elf" runs an OpenCV application that allows the user to switch up to three different images. The images in the "/demos/" folder are either jpeg or png. Please note, for the applications "my_example_linux_0.elf" and "opencv_linux_0.elf", a resolution of 1280x720 is configured. This resolution worked well with the monitor that was used to test the applications, however it may be necessary to change the resolution for other monitors!


