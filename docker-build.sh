#!/bin/bash -e
#
# Example:
#   ./docker-build.sh "CLEANBUILD=true USE_STDPERIPH_DRIVER=ON USE_OVERCLOCK=OFF SRC=src_stdperiph ./build.sh"
#   ./docker-build.sh "CLEANBUILD=true USE_LIBOPENCM3=ON USE_FREERTOS=ON SRC=src_freertos ./build.sh"

docker run --rm -it -v $(pwd):/tmp -w=/tmp dimtass/stm32-cde-image:0.1 -c "${1}"