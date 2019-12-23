set(STM32_DIMTASS_LIB_DIR ${CMAKE_SOURCE_DIR}/libs/stm32f1_dimtass_lib)

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${STM32_DIMTASS_LIB_DIR}")
  message(FATAL_ERROR "STM32 dimtass library submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

include_directories(
    ${STM32_DIMTASS_LIB_DIR}/inc
)

set(STM32_DIMTASS_LIB_SRC
    ${STM32_DIMTASS_LIB_DIR}/src/cortexm_delay.c
    ${STM32_DIMTASS_LIB_DIR}/src/dev_adc.c
    ${STM32_DIMTASS_LIB_DIR}/src/dev_i2c.c
    ${STM32_DIMTASS_LIB_DIR}/src/dev_pwm.c
    ${STM32_DIMTASS_LIB_DIR}/src/dev_spi_master.c
    ${STM32_DIMTASS_LIB_DIR}/src/dev_spi_slave.c
    ${STM32_DIMTASS_LIB_DIR}/src/dev_uart.c
    ${STM32_DIMTASS_LIB_DIR}/src/overclock_stm32f103.c
    ${STM32_DIMTASS_LIB_DIR}/src/tiny_printf.c
    ${STM32_DIMTASS_LIB_DIR}/src/stlinky.c
)

if (USE_DBGUART)
  set(STM32_DIMTASS_LIB_SRC ${STM32_DIMTASS_LIB_SRC} ${STM32_DIMTASS_LIB_DIR}/src/syscalls.c)
endif()
if (USE_STTERM)
  set(STM32_DIMTASS_LIB_SRC ${STM32_DIMTASS_LIB_SRC} ${STM32_DIMTASS_LIB_DIR}/src/syscalls.c)
endif()