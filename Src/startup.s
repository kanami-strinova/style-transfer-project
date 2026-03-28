/*
 * STM32F103 启动文件
 * 复位后执行
 */

.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.global g_pfnVectors
.global Default_Handler

/* 中断向量表 */
.word _estack
.word Reset_Handler
.word NMI_Handler
.word HardFault_Handler
.word MemManage_Handler
.word BusFault_Handler
.word UsageFault_Handler
.word 0
.word 0
.word 0
.word 0
.word SVC_Handler
.word DebugMon_Handler
.word 0
.word PendSV_Handler
.word SysTick_Handler

/* 外部中断 - 全部定义为默认处理函数 */
WEAK NMI_Handler
WEAK HardFault_Handler
WEAK MemManage_Handler
WEAK BusFault_Handler
WEAK UsageFault_Handler
WEAK SVC_Handler
WEAK DebugMon_Handler
WEAK PendSV_Handler
WEAK SysTick_Handler

/* 默认中断处理函数 */
Default_Handler:
Infinite_Loop:
    b Infinite_Loop
    .size Default_Handler, .-Default_Handler

/* 复位处理函数 */
.type Reset_Handler, %function
Reset_Handler:
    /* 复制data段 */
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
    movs r3, #0
    b CopyDataInit

CopyDataInit:
    cmp r1, r2
    ittt lt
    ldrlt r3, [r0], #4
    strlt r3, [r1], #4
    blt CopyDataInit

    /* 初始化bss段 */
    ldr r2, =__bss_start__
    ldr r4, =__bss_end__
    movs r3, #0
    b FillZerobss

FillZerobss:
    cmp r2, r4
    itt lt
    strlt r3, [r2], #4
    blt FillZerobss

    /* 调用main */
    bl SystemInit
    bl main

    /* 若main返回则停机 */
LoopForever:
    b LoopForever
    .size Reset_Handler, .-Reset_Handler
