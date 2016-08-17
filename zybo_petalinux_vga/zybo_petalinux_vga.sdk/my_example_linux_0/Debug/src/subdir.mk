################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CC_SRCS += \
../src/main.cc 

C_SRCS += \
../src/display_ctrl.c \
../src/display_demo.c \
../src/xaxivdma.c \
../src/xaxivdma_channel.c \
../src/xaxivdma_g.c \
../src/xaxivdma_intr.c \
../src/xaxivdma_selftest.c \
../src/xaxivdma_sinit.c \
../src/xil_assert.c \
../src/xil_io.c \
../src/xil_printf.c 

CPP_SRCS += \
../src/linuxmisc.cpp \
../src/linuxmmap.cpp 

CC_DEPS += \
./src/main.d 

OBJS += \
./src/display_ctrl.o \
./src/display_demo.o \
./src/linuxmisc.o \
./src/linuxmmap.o \
./src/main.o \
./src/xaxivdma.o \
./src/xaxivdma_channel.o \
./src/xaxivdma_g.o \
./src/xaxivdma_intr.o \
./src/xaxivdma_selftest.o \
./src/xaxivdma_sinit.o \
./src/xil_assert.o \
./src/xil_io.o \
./src/xil_printf.o 

C_DEPS += \
./src/display_ctrl.d \
./src/display_demo.d \
./src/xaxivdma.d \
./src/xaxivdma_channel.d \
./src/xaxivdma_g.d \
./src/xaxivdma_intr.d \
./src/xaxivdma_selftest.d \
./src/xaxivdma_sinit.d \
./src/xil_assert.d \
./src/xil_io.d \
./src/xil_printf.d 

CPP_DEPS += \
./src/linuxmisc.d \
./src/linuxmmap.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 Linux g++ compiler'
	arm-linux-gnueabihf-g++ -Wall -O0 -c -fmessage-length=0 -MT"$@" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 Linux g++ compiler'
	arm-linux-gnueabihf-g++ -Wall -O0 -c -fmessage-length=0 -MT"$@" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 Linux g++ compiler'
	arm-linux-gnueabihf-g++ -Wall -O0 -c -fmessage-length=0 -MT"$@" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


