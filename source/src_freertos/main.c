#include <string.h>
#include <stdlib.h>
#include <stm32f10x.h>

int main(void)
{
	if (SysTick_Config(SystemCoreClock / 1000)) {
		/* Capture error */
		while (1);
	}

	/* main loop */
	while (1) {
	}
}