#!/bin/bash
STM32_BIN=build-stm32/src_*/*.bin
OFFSET=0x8000000
st-flash --reset write "${STM32_BIN}" "${OFFSET}"
