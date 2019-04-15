#!/bin/bash -e

echo "Building the project in Linux environment"

# select architecture
: ${ARCHITECTURE:=stm32}
# Toolchain path
: ${TOOLCHAIN_DIR:="/opt/toolchains/gcc-arm-none-eabi-7-2018-q2-update"}
# select to create eclipse project files
: ${ECLIPSE_IDE:=false}
# select to clean previous builds
: ${CLEANBUILD:=false}
# Compile objects in parallel, the -jN flag in make
: ${PARALLEL:=$(expr $(getconf _NPROCESSORS_ONLN) + 1)}
# Current working directory
: ${WORKING_DIR:=$(pwd)}
# default generator
: ${IDE_GENERATOR:="Unix Makefiles"}
# cmake scripts folder
: ${SCRIPTS_CMAKE:="${WORKING_DIR}/source/cmake"}
# select cmake toolchain
: ${CMAKE_TOOLCHAIN:=TOOLCHAIN_arm_none_eabi_cortex_m3.cmake}
# Select Stdperiph lib use
: ${USE_STDPERIPH_DRIVER:="OFF"}
# Select Stdperiph lib use
: ${USE_STM32_USB_FS_LIB:="OFF"}
# Select Stdperiph lib use
: ${USE_LIBOPENCM3:="OFF"}
# Select Stdperiph lib use
: ${USE_FREERTOS:="OFF"}
# Select source folder
: ${SRC:="__"}

if [ ! -d "source/${SRC}" ]; then
    echo -e "You need to specify the SRC parameter to point to the source code"
    exit 1
fi

if [ "${ECLIPSE}" == "true" ]; then
	IDE_GENERATOR="Eclipse CDT4 - Unix Makefiles" 
fi

BUILD_ARCH_DIR=${WORKING_DIR}/build-${ARCHITECTURE}

if [ "${ARCHITECTURE}" == "stm32" ]; then
    CMAKE_FLAGS="${CMAKE_FLAGS} \
                -DTOOLCHAIN_DIR=${TOOLCHAIN_DIR} \
                -DCMAKE_TOOLCHAIN_FILE=${SCRIPTS_CMAKE}/${CMAKE_TOOLCHAIN} \
                -DUSE_STDPERIPH_DRIVER=${USE_STDPERIPH_DRIVER} \
                -DUSE_STM32_USB_FS_LIB=${USE_STM32_USB_FS_LIB} \
                -DUSE_LIBOPENCM3=${USE_LIBOPENCM3} \
                -DUSE_FREERTOS=${USE_FREERTOS} \
                -DSRC=${SRC} \
                "
else
    >&2 echo "*** Error: Architecture '${ARCHITECTURE}' unknown."
    exit 1
fi

if [ "${CLEANBUILD}" == "true" ]; then
    echo "- removing build directory: ${BUILD_ARCH_DIR}"
    rm -rf ${BUILD_ARCH_DIR}
fi

echo "--- Pre-cmake ---"
echo "architecture      : ${ARCHITECTURE}"
echo "distclean         : ${CLEANBUILD}"
echo "parallel          : ${PARALLEL}"
echo "cmake flags       : ${CMAKE_FLAGS}"
echo "cmake scripts     : ${SCRIPTS_CMAKE}"
echo "IDE generator     : ${IDE_GENERATOR}"
echo "Threads           : ${PARALLEL}"

mkdir -p build-stm32
cd build-stm32

# setup cmake
cmake ../source -G"${IDE_GENERATOR}" ${CMAKE_FLAGS}

# build
make -j${PARALLEL} --no-print-directory
