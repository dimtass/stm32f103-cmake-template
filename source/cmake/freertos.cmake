set(FREERTOS_DIR ${CMAKE_SOURCE_DIR}/libs/freertos)

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${FREERTOS_DIR}")
  message(FATAL_ERROR "FreeRTOS submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

set(FREERTOS_INC_DIR
    ${FREERTOS_DIR}/inc
)

include_directories(
    ${CMAKE_SOURCE_DIR}/config # That's for including the FreeRTOSConfig.h
    ${FREERTOS_INC_DIR}
)

set(FREERTOS_LIB_SRC
    ${FREERTOS_DIR}/src/croutine.c
    ${FREERTOS_DIR}/src/event_groups.c
    ${FREERTOS_DIR}/src/heap_1.c
    ${FREERTOS_DIR}/src/heap_2.c
    ${FREERTOS_DIR}/src/heap_3.c
    ${FREERTOS_DIR}/src/heap_4.c
    ${FREERTOS_DIR}/src/heap_5.c
    ${FREERTOS_DIR}/src/list.c
    ${FREERTOS_DIR}/src/port.c
    ${FREERTOS_DIR}/src/queue.c
    ${FREERTOS_DIR}/src/readme.txt
    ${FREERTOS_DIR}/src/stream_buffer.c
    ${FREERTOS_DIR}/src/tasks.c
    ${FREERTOS_DIR}/src/timers.c
)

set_source_files_properties(${FREERTOS_LIB_SRC}
    PROPERTIES COMPILE_FLAGS ${STM32_DEFINES}
    # STM32_DEFINES are defined in the top level CMakeLists.txt
)

add_library(freertos STATIC ${FREERTOS_LIB_SRC})

set_target_properties(freertos PROPERTIES LINKER_LANGUAGE C)

# -flto breaks FreeRTOS, so remove it
string(REPLACE "-flto" "" COMPILER_OPTIMISATION ${COMPILER_OPTIMISATION})

set(EXTERNAL_LIBS ${EXTERNAL_LIBS} freertos)