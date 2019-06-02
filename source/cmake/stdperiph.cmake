set(STDPERIPH_DIR ${CMAKE_SOURCE_DIR}/libs/stdperiph/stm32f1)
set(CMSIS_DIR ${CMAKE_SOURCE_DIR}/libs/cmsis)
set(CONFIG_DIR ${CMAKE_SOURCE_DIR}/config)

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${STDPERIPH_DIR}")
  message(FATAL_ERROR "stdperiph submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${CMSIS_DIR}")
  message(FATAL_ERROR "cmsis submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

include_directories(
    ${CMSIS_DIR}/core
    ${CMSIS_DIR}/device
    ${STDPERIPH_DIR}/inc
)

set(STDPERIPH_LIB_SRC
    ${STDPERIPH_DIR}/src/misc.c
    ${STDPERIPH_DIR}/src/stm32f10x_adc.c
    ${STDPERIPH_DIR}/src/stm32f10x_bkp.c
    ${STDPERIPH_DIR}/src/stm32f10x_can.c
    ${STDPERIPH_DIR}/src/stm32f10x_cec.c
    ${STDPERIPH_DIR}/src/stm32f10x_crc.c
    ${STDPERIPH_DIR}/src/stm32f10x_dac.c
    ${STDPERIPH_DIR}/src/stm32f10x_dbgmcu.c
    ${STDPERIPH_DIR}/src/stm32f10x_dma.c
    ${STDPERIPH_DIR}/src/stm32f10x_exti.c
    ${STDPERIPH_DIR}/src/stm32f10x_flash.c
    ${STDPERIPH_DIR}/src/stm32f10x_fsmc.c
    ${STDPERIPH_DIR}/src/stm32f10x_gpio.c
    ${STDPERIPH_DIR}/src/stm32f10x_i2c.c
    ${STDPERIPH_DIR}/src/stm32f10x_iwdg.c
    ${STDPERIPH_DIR}/src/stm32f10x_pwr.c
    ${STDPERIPH_DIR}/src/stm32f10x_rcc.c
    ${STDPERIPH_DIR}/src/stm32f10x_rtc.c
    ${STDPERIPH_DIR}/src/stm32f10x_sdio.c
    ${STDPERIPH_DIR}/src/stm32f10x_spi.c
    ${STDPERIPH_DIR}/src/stm32f10x_tim.c
    ${STDPERIPH_DIR}/src/stm32f10x_usart.c
    ${STDPERIPH_DIR}/src/stm32f10x_wwdg.c
)

set(STM32_DEFINES "${STM32_DEFINES} -DUSE_STDPERIPH_DRIVER")

set_source_files_properties(${STDPERIPH_LIB_SRC}
    PROPERTIES COMPILE_FLAGS ${STM32_DEFINES}
)

add_library(stdperiph STATIC ${STDPERIPH_LIB_SRC})

set_target_properties(stdperiph PROPERTIES LINKER_LANGUAGE C)

# add startup and linker file
set(STARTUP_ASM_FILE "${CONFIG_DIR}/startup_stm32f10x_md.s")
set_property(SOURCE ${STARTUP_ASM_FILE} PROPERTY LANGUAGE ASM)
set(LINKER_FILE "${CONFIG_DIR}/LinkerScript.ld")


set(EXTERNAL_EXECUTABLES ${EXTERNAL_EXECUTABLES} ${STARTUP_ASM_FILE})

set(EXTERNAL_LIBS ${EXTERNAL_LIBS} stdperiph)