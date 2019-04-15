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

```sh
CLEANBUILD=true USE_STDPERIPH_DRIVER=ON SRC=src_stdperiph ./build.sh
```

```sh
LEANBUILD=true USE_LIBOPENCM3=ON USE_FREERTOS=ON SRC=src_freertos ./build.sh
```

To flash the HEX file in windows use st-link utility like this:
```"C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\ST-LINK_CLI.exe" -c SWD -p build-stm32\src\stm32f103_wifi_usb_psu.hex -Rst```

To flash the bin in Linux:
```st-flash --reset write build-stm32/src/stm32f103_wifi_usb_psu.bin 0x8000000```

## FW details
* `CMSIS version`: 5.3.0
* `StdPeriph Library version`: 3.6.1
* `STM3 USB Driver version`: 4.1.0

