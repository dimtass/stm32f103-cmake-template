STM32F103 USB joystick with gestures
----

This project implements a USB joystick with gestures recognition.
That means that you can use the joystick to recognise gestures and
then send them via USB to your workstation (you can also use UART
if you prefer). The gestures can be composed with up to `JOYS_SAMPLES_MAX`
samples and each sample can be one of the following:

* `U`   : up
* `D`   : down
* `L`   : left
* `R`   : right
* `UR`  : up - right
* `DR`  : down - right
* `DL`  : down - left
* `UL`  : up - left
* `B`   : button press

Each gesture is transmitted via USB with following prefix:
```
DATA=
```

and a `\n` (newline) at the end of the string.

For example, this is a full circle on the joystick
```
DATA=U,UR,R,DR,D,DL,L,UL,U
```

You can see a sample video in [here](https://www.youtube.com/watch?v=TYFL-sVukkc)

### How to compile and flash
You need cmake to build this project either on Windows or Linux.
To setup the cmake properly
follow the instructions from [here](https://bitbucket.org/dimtass/cmake_toolchains/src/master/README.md).
Then edit the `cmake/TOOLCHAIN_arm_none_eabi_cortex_m3.cmake` file
and point `TOOLCHAIN_DIR` to the correct GCC path.

e.g. on Windows
```sh
set(TOOLCHAIN_DIR C:/opt/gcc-arm-none-eabi-4_9-2015q3-20150921-win32)
```

or on Linux
```sh
set(TOOLCHAIN_DIR /opt/gcc-arm-none-eabi-4_9-2015q3)
```

Then on Windows run ```build.cmd``` or on Linux run ```./build.bash```
and the .bin and .hex files should be created in the ```build-stm32/src```
folder. Also, a .cproject and .project files are created if you want to
edit the source code.

To flash the HEX file in windows use st-link utility like this:
```"C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\ST-LINK_CLI.exe" -c SWD -p build-stm32\src\stm32f103_wifi_usb_psu.hex -Rst```

To flash the bin in Linux:
```st-flash --reset write build-stm32/src/stm32f103_wifi_usb_psu.bin 0x8000000```

## FW details
* `CMSIS version`: 5.3.0
* `StdPeriph Library version`: 3.6.1
* `STM3 USB Driver version`: 4.1.0

