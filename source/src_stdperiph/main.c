/**
 * This Example is using the mod_led.h in noarch_c_lib
 * to toggle the LED. The difference with the simple
 * example is that now the LED supports also patterns.
 */

#include <stdio.h>
#include "stm32f10x.h"
#include "debug_trace.h"
#include "dev_uart.h"
#include "mod_led.h"
#include "timer_sched.h"

#define LED_TIMER_MS 500

volatile uint32_t glb_tmr_1ms;

#define LED_PORT GPIOC
#define LED_PIN GPIO_Pin_13

uint32_t trace_levels;

/* Create the list head for the timer */
static LIST_HEAD(obj_timer_list);

// Declare uart
DECLARE_UART_DEV(dbg_uart, USART1, 115200, 256, 10, 1);

static inline void main_loop(void)
{
	/* 1 ms timer */
	if (glb_tmr_1ms) {
		glb_tmr_1ms = 0;
		mod_timer_polling(&obj_timer_list);
	}
}

void led_on(void *data)
{
	LED_PORT->ODR |= LED_PIN;
}

void led_off(void *data)
{
	LED_PORT->ODR &= ~LED_PIN;
}

void led_init(void *data)
{
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_InitStructure.GPIO_Pin = LED_PIN;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(LED_PORT, &GPIO_InitStructure);

	LED_PORT->ODR |= LED_PIN;
	TRACE(("init\n"));
}

int main(void)
{
	if (SysTick_Config(SystemCoreClock / 1000)) {
		/* Capture error */
		while (1);
	}
	
	trace_levels_set(
			0
			| TRACE_LEVEL_DEFAULT
			,1);

	// setup uart port
	dev_uart_add(&dbg_uart);
	// set callback for uart rx
 	dbg_uart.fp_dev_uart_cb = NULL;
 	mod_timer_add((void*) &dbg_uart, 5, (void*) &dev_uart_update, &obj_timer_list);

	/* Declare LED module and initialize it */
	DECLARE_MODULE_LED(led_module, 8, 250);
	mod_led_init(&led_module);
	mod_timer_add((void*) &led_module, led_module.tick_ms, (void*) &mod_led_update, &obj_timer_list);

	/* Declare LED */
	DECLARE_DEV_LED(def_led, &led_module, 1, NULL, &led_init, &led_on, &led_off);
	dev_led_add(&def_led);
	dev_led_set_pattern(&def_led, 0b11001100);

	TRACE(("Program started\n"));

	/* main loop */
	while (1) {
		main_loop();
	}
}