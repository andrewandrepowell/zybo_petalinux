################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/xilinx/display_ctrl.c \
../src/xilinx/display_demo.c \
../src/xilinx/xaxivdma.c \
../src/xilinx/xaxivdma_channel.c \
../src/xilinx/xaxivdma_g.c \
../src/xilinx/xaxivdma_intr.c \
../src/xilinx/xaxivdma_selftest.c \
../src/xilinx/xaxivdma_sinit.c \
../src/xilinx/xil_assert.c \
../src/xilinx/xil_io.c \
../src/xilinx/xil_printf.c 

OBJS += \
./src/xilinx/display_ctrl.o \
./src/xilinx/display_demo.o \
./src/xilinx/xaxivdma.o \
./src/xilinx/xaxivdma_channel.o \
./src/xilinx/xaxivdma_g.o \
./src/xilinx/xaxivdma_intr.o \
./src/xilinx/xaxivdma_selftest.o \
./src/xilinx/xaxivdma_sinit.o \
./src/xilinx/xil_assert.o \
./src/xilinx/xil_io.o \
./src/xilinx/xil_printf.o 

C_DEPS += \
./src/xilinx/display_ctrl.d \
./src/xilinx/display_demo.d \
./src/xilinx/xaxivdma.d \
./src/xilinx/xaxivdma_channel.d \
./src/xilinx/xaxivdma_g.d \
./src/xilinx/xaxivdma_intr.d \
./src/xilinx/xaxivdma_selftest.d \
./src/xilinx/xaxivdma_sinit.d \
./src/xilinx/xil_assert.d \
./src/xilinx/xil_io.d \
./src/xilinx/xil_printf.d 


# Each subdirectory must supply rules for building sources it contributes
src/xilinx/%.o: ../src/xilinx/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 Linux g++ compiler'
	arm-linux-gnueabihf-g++ -Wall -O0 -I"/opt/Xilinx/Projects/zybo_petalinux/zybo_petalinux_vga/zybo_petalinux_vga.sdk/opencv_linux_0/src/xilinx" -I/opt/opencv-3.1.0/modules/imgproc/include -I/opt/opencv-3.1.0/modules/videoio/include -I/opt/opencv-3.1.0/modules/imgcodecs/include -I/opt/opencv-3.1.0/modules/highgui/include -I/opt/opencv-3.1.0/modules/core/include -I"/opt/Xilinx/Projects/zybo_petalinux/zybo_petalinux_vga/zybo_petalinux_vga.sdk/opencv_linux_0/src/opencv" -c -fmessage-length=0 -MT"$@" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


