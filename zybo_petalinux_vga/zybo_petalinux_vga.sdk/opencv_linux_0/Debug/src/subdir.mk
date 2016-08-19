################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CC_SRCS += \
../src/main.cc 

CPP_SRCS += \
../src/linuxmisc.cpp \
../src/linuxmmap.cpp 

CC_DEPS += \
./src/main.d 

OBJS += \
./src/linuxmisc.o \
./src/linuxmmap.o \
./src/main.o 

CPP_DEPS += \
./src/linuxmisc.d \
./src/linuxmmap.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 Linux g++ compiler'
	arm-linux-gnueabihf-g++ -Wall -O0 -I"/opt/Xilinx/Projects/zybo_petalinux/zybo_petalinux_vga/zybo_petalinux_vga.sdk/opencv_linux_0/src/xilinx" -I/opt/opencv-3.1.0/modules/imgproc/include -I/opt/opencv-3.1.0/modules/videoio/include -I/opt/opencv-3.1.0/modules/imgcodecs/include -I/opt/opencv-3.1.0/modules/highgui/include -I/opt/opencv-3.1.0/modules/core/include -I"/opt/Xilinx/Projects/zybo_petalinux/zybo_petalinux_vga/zybo_petalinux_vga.sdk/opencv_linux_0/src/opencv" -c -fmessage-length=0 -MT"$@" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 Linux g++ compiler'
	arm-linux-gnueabihf-g++ -Wall -O0 -I"/opt/Xilinx/Projects/zybo_petalinux/zybo_petalinux_vga/zybo_petalinux_vga.sdk/opencv_linux_0/src/xilinx" -I/opt/opencv-3.1.0/modules/imgproc/include -I/opt/opencv-3.1.0/modules/videoio/include -I/opt/opencv-3.1.0/modules/imgcodecs/include -I/opt/opencv-3.1.0/modules/highgui/include -I/opt/opencv-3.1.0/modules/core/include -I"/opt/Xilinx/Projects/zybo_petalinux/zybo_petalinux_vga/zybo_petalinux_vga.sdk/opencv_linux_0/src/opencv" -c -fmessage-length=0 -MT"$@" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


