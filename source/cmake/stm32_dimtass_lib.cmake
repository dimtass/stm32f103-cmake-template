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
)

set_source_files_properties(${STM32_DIMTASS_LIB_SRC}
    PROPERTIES COMPILE_FLAGS ${STM32_DEFINES}
    # STM32_DEFINES are defined in the top level CMakeLists.txt
)

add_library(stm32dimtasslib STATIC ${STM32_DIMTASS_LIB_SRC})

set_target_properties(stm32dimtasslib PROPERTIES LINKER_LANGUAGE C)

set(EXTERNAL_LIBS ${EXTERNAL_LIBS} stm32dimtasslib)