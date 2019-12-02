cmake_minimum_required(VERSION 3.2)

include_directories(inc)

file(GLOB C_SOURCE
    # Add the external source files from my lib
    ${STM32_DIMTASS_LIB_SRC}
    # Add the local and project specific files
    main.c
    system_stm32f10x.c
    syscalls.c
    stm32f10x_it.c
)

set_source_files_properties(${C_SOURCE}
    PROPERTIES COMPILE_FLAGS ${STM32_DEFINES}
)

add_executable(${PROJECT_NAME}.elf
    ${C_SOURCE}
    ${EXTERNAL_EXECUTABLES}
)

if (EXTERNAL_DEPENDENCIES)
    add_dependencies(${PROJECT_NAME}.elf
        ${EXTERNAL_DEPENDENCIES}
    )
endif()

if (EXTERNAL_LIBS)
    target_link_libraries(${PROJECT_NAME}.elf
        ${EXTERNAL_LIBS}
    )
endif()

if (USE_STM32_USB_FS_LIB)
    target_link_libraries(${PROJECT_NAME}.elf
        UsbFsDeviceLib
    )
endif()

add_custom_target ( ${PROJECT_NAME}.hex ALL
    DEPENDS ${PROJECT_NAME}.elf 
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    COMMENT "Generating ${PROJECT_NAME}.hex"
)
add_custom_target ( ${PROJECT_NAME}.bin ALL
    DEPENDS ${PROJECT_NAME}.elf 
    COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    COMMENT "Generating ${PROJECT_NAME}.bin"
)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_SIZE} --format=berkeley "${PROJECT_NAME}.elf")
