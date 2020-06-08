# Author: Dimitris Tassopoulos <dimtass@gmail.com>

cmake_minimum_required(VERSION 3.2)

project(stm32f103-cmake-template LANGUAGES C CXX)

option(USE_STDPERIPH_DRIVER "Use stdperiph library" OFF)
option(USE_STM32_USB_FS_LIB "Use the STM32 USB FS device driver lib" OFF) 
option(USE_LIBOPENCM3 "Use openlibcm3 library" OFF)
option(USE_FREERTOS "Use FreeRTOS" OFF)
option(USE_SEMIHOSTING "Use semi-hosting" OFF)
option(USE_STTERM "Use st-term" OFF)
option(USE_DBGUART "Use debug UART" OFF)

# Set STM32 SoC specific variables
set(STM32_DEFINES " \
    -DIVECT_TAB_OFFSET=0x0 \
    -DSTM32F1 \
    -DSTM32F103C8Tx \
    -DSTM32 \
    -DSTM32F10X_MD \
    ")

if (USE_OVERCLOCK)
    set(STM32_DEFINES "${STM32_DEFINES} -DUSE_OVERCLOCK")
endif()

if (USE_SEMIHOSTING)
    message(STATUS "Using semhosting...")
    set(STM32_DEFINES "${STM32_DEFINES} -DUSE_SEMIHOSTING")
endif()

if (USE_STTERM)
    message(STATUS "Using st-term...")
    set(STM32_DEFINES "${STM32_DEFINES} -DUSE_STTERM")
endif()

if (USE_DBGUART)
    message(STATUS "Using debug UART...")
    set(STM32_DEFINES "${STM32_DEFINES} -DUSE_DBGUART")
endif()

# set compiler optimisations
set(COMPILER_OPTIMISATION "-O3")

# Only build for arm-none-eabi
if (NOT CMAKE_SYSTEM_PROCESSOR STREQUAL "arm-none-eabi")
    message(FATAL_ERROR "Invalid CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
endif()

# CMSIS shared library
# Standard Peripheral Driver shared library
if (USE_STDPERIPH_DRIVER)
    include(cmake/stdperiph.cmake)
endif()

# USB FS Device Driver Library
if (USE_STM32_USB_FS_LIB)
    include(cmake/stm32_usb_fs_driver.cmake)
endif()

# libopencm3
if (USE_LIBOPENCM3)
    include(cmake/libopencm3.cmake)
endif()

# FreeRTOS Library
if (USE_FREERTOS)
    include(cmake/freertos.cmake)
endif()

include (cmake/noarch_c_lib.cmake)

include (cmake/stm32_dimtass_lib.cmake)

# Resolve the issue with Eclipse's indexer and C/C++ mixed source files
include(cmake/language_provider.cmake)
remove_from_SYSTEM_MACROS(CXX "__cplusplus;.*;")
create_language_provider("${CMAKE_BINARY_DIR}/.settings" "${GCC_PREFIX}-" "${CXX_STANDARD_FLAG}")

# enable asm for stm startup.s file
enable_language(ASM)
# Custom STM32 options for assembler and gcc
set(STM32_ASM_OPTIONS "-march=armv7-m -mcpu=cortex-m3 -mthumb -mlittle-endian -mthumb-interwork")
set(STM32_COMPILER_OPTIONS "${STM32_ASM_OPTIONS} \
                        -ffunction-sections \
                        -fdata-sections \
                        -mfloat-abi=soft \
                        -fmessage-length=0 \
                        -Wall -Werror \
                        -Wl,-Map=output.map -Wl,--gc-sections \
                        -lm -lc")

set(STM32_CXX_COMPILER_OPTIONS "${STM32_COMPILER_OPTIONS} \
                        -fno-rtti \
                        -fno-exceptions \
                        -fno-builtin \
                        -std=gnu++11 \
                        ")
# Set project options
SET(CMAKE_C_FLAGS "${STM32_COMPILER_OPTIONS} ${COMPILER_OPTIMISATION} -std=c11" CACHE INTERNAL "c compiler flags")
SET(CMAKE_CXX_FLAGS "${STM32_CXX_COMPILER_OPTIONS} ${COMPILER_OPTIMISATION} -std=c++11 " CACHE INTERNAL "cxx compiler flags")
SET(CMAKE_ASM_FLAGS "${STM32_ASM_OPTIONS}" CACHE INTERNAL "asm compiler flags")
# -mthumb -mcpu=cortex-m3 -mfix-cortex-m3-ldrd   -Wl,-Map=linker.map -Wl,-cref  -Wl,--gc-sections
set(EXTRA_LINKER_FLAGS "-lm -lc --specs=nano.specs")
if (USE_SEMIHOSTING)
    set(EXTRA_LINKER_FLAGS "${EXTRA_LINKER_FLAGS} --specs=nosys.specs --specs=rdimon.specs -lrdimon")
endif()
SET(CMAKE_EXE_LINKER_FLAGS "${STM32_COMPILER_OPTIONS} ${LIBOPENCM3_LINKER_FLAGS} -Wl,-Map=linker.map -Wl,-cref " CACHE INTERNAL "exe link flags")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${EXTRA_LINKER_FLAGS} -T${LINKER_FILE}")

message(STATUS "System Processor      : ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS
    "BUILD FLAGS:\n"
    "   STM32_DEFINES   : ${STM32_DEFINES}\n"
    "   c flags         : ${CMAKE_C_FLAGS}\n"
    "   c++ flags       : ${CMAKE_CXX_FLAGS}\n"
    "   asm flags       : ${CMAKE_ASM_FLAGS}\n"
    "   ld flags        : ${CMAKE_EXE_LINKER_FLAGS}\n"
    "   optimizations   : ${COMPILER_OPTIMISATION}\n"
    "   CMSIS           : ${CMSIS_DIR}\n"
    "   StdPeriph       : ${STDPERIPH_DIR}\n"
    "   USB FS includes : ${STM32_USB_FS_DEVICE_INC_DIR}\n"
    "   FreeRTOS        : ${FREERTOS_INC_DIR}\n"
    "   libopencm3      : ${LIBOPENCM3_INC_DIR}\n"
    "   semihosting     : ${SEMIHOSTING_LINKER_FLAGS}\n"
    "   st-term         : ${USE_STTERM}\n"
    "   debug UART      : ${USE_DBGUART}\n"
)

# add the source code directory
add_subdirectory(${SRC})
