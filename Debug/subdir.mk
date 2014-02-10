################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../disassemble.c \
../load_program.c \
../memory.c \
../processor.c \
../sim.c 

OBJS += \
./disassemble.o \
./load_program.o \
./memory.o \
./processor.o \
./sim.o 

C_DEPS += \
./disassemble.d \
./load_program.d \
./memory.d \
./processor.d \
./sim.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross GCC Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


