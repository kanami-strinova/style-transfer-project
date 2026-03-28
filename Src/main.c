/*
 * STM32F103C8 蓝 Pill LED 闪烁
 * 
 * 硬件连接：
 *   PC13 (LED on BluePill) -> 3.3V (低电平点亮)
 *   
 * 编译：make
 * 烧录：make flash
 */

#include "main.h"

// 若使用STM32 HAL库，取消下面注释
// #include "stm32f1xx_hal.h"

// 简单的延时函数
void Delay(uint32_t ms) {
    volatile uint32_t count = ms * (SYSCLK / 1000 / 4);
    while(count--) {
        __ASM("nop");
    }
}

// GPIO初始化
void GPIO_Init(void) {
    // 使能GPIOC时钟 (RCC_APB2ENR)
    volatile uint32_t *RCC_APB2ENR = (uint32_t *)0x40021000 + 0x18;
    *RCC_APB2ENR |= (1 << 4);  // IOPCEN = 1
    
    // 配置PC13为推挽输出 (CRH)
    volatile uint32_t *GPIOC_CRH = (uint32_t *)0x40011000 + 0x04;
    *GPIOC_CRH &= ~(0xF << ((13 - 8) * 4));   // 清除
    *GPIOC_CRH |= (0x3 << ((13 - 8) * 4));    // 50MHz输出模式
    // 推挽输出已默认，不需要设置CNF
}

int main(void) {
    // SystemClock_Config(); // 若用HAL库需要
    
    GPIO_Init();
    
    while(1) {
        // PC13输出低电平，点亮LED
        volatile uint32_t *GPIOC_BSRR = (uint32_t *)0x40011000 + 0x10;
        *GPIOC_BSRR = (1 << (13 + 16));  // BR13 = 1
        
        Delay(500);
        
        // PC13输出高电平，熄灭LED
        *GPIOC_BSRR = (1 << 13);  // BS13 = 1
        
        Delay(500);
    }
}
