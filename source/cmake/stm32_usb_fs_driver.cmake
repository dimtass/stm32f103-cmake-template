set(STM32USBLIB_DIR ${CMAKE_SOURCE_DIR}/libs/stm32-usb-fs-device-driver)

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${STM32USBLIB_DIR}")
  message(FATAL_ERROR "FreeRTOS submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
)

set(USTM32USBLIB_SRC
    ${STM32USBLIB_DIR}/src/usb_core.c
    ${STM32USBLIB_DIR}/src/usb_init.c
    ${STM32USBLIB_DIR}/src/usb_int.c
    ${STM32USBLIB_DIR}/src/usb_mem.c
    ${STM32USBLIB_DIR}/src/usb_regs.c
    ${STM32USBLIB_DIR}/src/usb_sil.c
)

set_source_files_properties(${USTM32USBLIB_SRC}
    PROPERTIES COMPILE_FLAGS ${STM32_DEFINES}
)

add_library(stm32usblib STATIC ${USTM32USBLIB_SRC})

set_target_properties(stm32usblib PROPERTIES LINKER_LANGUAGE C)
