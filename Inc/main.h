#ifndef __MAIN_H
#define __MAIN_H

#include <stdint.h>

// 系统时钟频率 (72MHz for STM32F103)
#define HSE_VALUE    8000000
#define HSI_VALUE    8000000
#define SYSCLK       72000000

// GPIO引脚定义
#define LED_PORT     GPIOC
#define LED_PIN      13

// 函数声明
void SystemClock_Config(void);
void GPIO_Init(void);
void Delay(uint32_t ms);

#endif
