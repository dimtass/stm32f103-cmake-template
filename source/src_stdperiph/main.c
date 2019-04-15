#include <platform_config.h>

#define LED_TIMER_MS 500

volatile struct global glb;

static inline void main_loop(void)
{
	/* 1 ms timer */
	if (glb.tmr_1ms) {
		glb.tmr_1ms = 0;
		if ((glb.tmr_led++) >= LED_TIMER_MS) {
			glb.tmr_led = 0;
			LED_PORT->ODR ^= LED_PIN;
		}
	}
}

void bluepill_led_init(void)
{
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_InitStructure.GPIO_Pin = LED_PIN;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(LED_PORT, &GPIO_InitStructure);

	LED_PORT->ODR &= ~LED_PIN;
}

int main(void)
{
	if (SysTick_Config(SystemCoreClock / 1000)) {
		/* Capture error */
		while (1);
	}
	
	set_trace_level(
			0
			| TRACE_LEVEL_DEFAULT
			,1);

	bluepill_led_init();

	/* main loop */
	while (1) {
		main_loop();
	}
}