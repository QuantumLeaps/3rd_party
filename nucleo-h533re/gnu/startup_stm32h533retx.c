// File:  startup_stm32h533retx.c for GNU-ARM compiler
// Purpose: startup file for stm32u545retx6 device.
//          Should be used with GCC 'GNU Tools ARM Embedded'
// Date: 2026-06-21
//
// Modified by Quantum Leaps:
// - Modified all exception handlers to branch to assert_failed()
//   instead of locking up the CPU inside an endless loop.
//
// Created from the CMSIS template for the specified device
// Quantum Leaps, www.state-machine.com
//
// NOTE:
// The function assert_failed defined at the end of this file defines
// the error/assertion handling policy for the application and might
// need to be customized for each project. This function is defined in
// assembly to re-set the stack pointer, in case it is corrupted by the
// time assert_failed is called.
//

// start and end of stack defined in the linker script -----------------------
//extern int __stack_start__;
extern int __stack_end__;

// Weak prototypes for error handlers ----------------------------------------
// The function assert_failed defines the error/assertion handling policy
// for the application and might need to be customized for each project.
__attribute__ ((naked, noreturn))
void assert_failed(char const *module, int loc);

// Function prototypes -------------------------------------------------------
void Default_Handler(void);  // Default empty handler
void Reset_Handler(void);    // Reset Handler
void SystemInit(void);       // CMSIS system initialization

//----------------------------------------------------------------------------
// weak aliases for each Exception handler to the Default_Handler.
// Any function with the same name will override these definitions.

// Cortex-M Processor fault exceptions...
void NMI_Handler           (void) __attribute__ ((weak));
void HardFault_Handler     (void) __attribute__ ((weak));
void MemManage_Handler     (void) __attribute__ ((weak));
void BusFault_Handler      (void) __attribute__ ((weak));
void UsageFault_Handler    (void) __attribute__ ((weak));
void SecureFault_Handler   (void) __attribute__ ((weak));

// Cortex-M Processor non-fault exceptions...
void SVC_Handler           (void) __attribute__ ((weak, alias("Default_Handler")));
void DebugMon_Handler      (void) __attribute__ ((weak, alias("Default_Handler")));
void PendSV_Handler        (void) __attribute__ ((weak, alias("Default_Handler")));
void SysTick_Handler       (void) __attribute__ ((weak, alias("Default_Handler")));

// external interrupts...
void WWDG_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void PVD_PVM_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void RTC_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void RTC_S_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void TAMP_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void RAMCFG_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void FLASH_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void FLASH_S_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void GTZC_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void RCC_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void RCC_S_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI0_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI1_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI2_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI3_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI4_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI5_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI6_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI7_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI8_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI9_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI10_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI11_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI12_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI13_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI14_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void EXTI15_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel0_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel1_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel2_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel3_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel4_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel5_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel6_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel7_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void IWDG_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void SAES_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void ADC1_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void DAC1_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void FDCAN1_IT0_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void FDCAN1_IT1_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM1_BRK_IRQHandler   (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM1_UP_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM1_TRG_COM_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void TIM1_CC_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM2_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM3_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM4_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM5_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM6_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM7_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C1_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C1_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C2_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C2_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void SPI1_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void SPI2_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void SPI3_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void USART1_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void USART2_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void USART3_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void UART4_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void UART5_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void LPUART1_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void LPTIM1_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM8_BRK_IRQHandler   (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM8_UP_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM8_TRG_COM_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void TIM8_CC_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void ADC2_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void LPTIM2_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM15_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved72_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved73_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void USB_DRD_FS_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void CRS_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void UCPD1_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void FMC_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void OCTOSPI1_IRQHandler   (void) __attribute__ ((weak, alias("Default_Handler")));
void SDMMC1_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C3_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C3_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void SPI4_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved83_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved84_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void USART6_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved86_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved87_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved88_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved89_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA2_Channel0_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA2_Channel1_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA2_Channel2_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA2_Channel3_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA2_Channel4_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA2_Channel5_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA2_Channel6_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA2_Channel7_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved98_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved99_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved100_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved101_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved102_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void FPU_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void ICACHE_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void DCACHE1_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved106_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved107_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void DCMI_PSSI_IRQHandler  (void) __attribute__ ((weak, alias("Default_Handler")));
void FDCAN2_IT0_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void FDCAN2_IT1_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved111_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved112_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void DTS_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void RNG_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void OTFDEC1_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void AES_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void HASH_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void PKA_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void CEC_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM12_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved121_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved122_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void I3C1_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I3C1_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved125_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved126_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved127_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved128_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved129_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved130_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void I3C2_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I3C2_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));

//............................................................................
__attribute__ ((section(".isr_vector")))
int const g_pfnVectors[] = {
    (int)&__stack_end__,                // Top of Stack
    (int)&Reset_Handler,                // Reset Handler
    (int)&NMI_Handler,                  // NMI Handler
    (int)&HardFault_Handler,            // Hard Fault Handler
    (int)&MemManage_Handler,            // Memory Manage (MPU) Handler
    (int)&BusFault_Handler,             // Bus Fault Handler
    (int)&UsageFault_Handler,           // Usage Fault Handler
    (int)&SecureFault_Handler,          // Secure Fault Handler
    (int)&Default_Handler,              // Reserved
    (int)&Default_Handler,              // Reserved
    (int)&Default_Handler,              // Reserved
    (int)&SVC_Handler,                  // SVCall handler
    (int)&DebugMon_Handler,             // Debug monitor handler
    (int)&Default_Handler,              // Reserved
    (int)&PendSV_Handler,               // The PendSV handler
    (int)&SysTick_Handler,              // The SysTick handler

    // IRQ handlers...
    (int)&WWDG_IRQHandler,             // [  0]
    (int)&PVD_PVM_IRQHandler,          // [  1]
    (int)&RTC_IRQHandler,              // [  2]
    (int)&RTC_S_IRQHandler,            // [  3]
    (int)&TAMP_IRQHandler,             // [  4]
    (int)&RAMCFG_IRQHandler,           // [  5]
    (int)&FLASH_IRQHandler,            // [  6]
    (int)&FLASH_S_IRQHandler,          // [  7]
    (int)&GTZC_IRQHandler,             // [  8]
    (int)&RCC_IRQHandler,              // [  9]
    (int)&RCC_S_IRQHandler,            // [ 10]
    (int)&EXTI0_IRQHandler,            // [ 11]
    (int)&EXTI1_IRQHandler,            // [ 12]
    (int)&EXTI2_IRQHandler,            // [ 13]
    (int)&EXTI3_IRQHandler,            // [ 14]
    (int)&EXTI4_IRQHandler,            // [ 15]
    (int)&EXTI5_IRQHandler,            // [ 16]
    (int)&EXTI6_IRQHandler,            // [ 17]
    (int)&EXTI7_IRQHandler,            // [ 18]
    (int)&EXTI8_IRQHandler,            // [ 19]
    (int)&EXTI9_IRQHandler,            // [ 20]
    (int)&EXTI10_IRQHandler,           // [ 21]
    (int)&EXTI11_IRQHandler,           // [ 22]
    (int)&EXTI12_IRQHandler,           // [ 23]
    (int)&EXTI13_IRQHandler,           // [ 24]
    (int)&EXTI14_IRQHandler,           // [ 25]
    (int)&EXTI15_IRQHandler,           // [ 26]
    (int)&GPDMA1_Channel0_IRQHandler,  // [ 29]
    (int)&GPDMA1_Channel1_IRQHandler,  // [ 30]
    (int)&GPDMA1_Channel2_IRQHandler,  // [ 31]
    (int)&GPDMA1_Channel3_IRQHandler,  // [ 32]
    (int)&GPDMA1_Channel4_IRQHandler,  // [ 33]
    (int)&GPDMA1_Channel5_IRQHandler,  // [ 34]
    (int)&GPDMA1_Channel6_IRQHandler,  // [ 35]
    (int)&GPDMA1_Channel7_IRQHandler,  // [ 36]
    (int)&IWDG_IRQHandler,             // [ 27]
    (int)&SAES_IRQHandler,             // [ 28]
    (int)&ADC1_IRQHandler,             // [ 37]
    (int)&DAC1_IRQHandler,             // [ 38]
    (int)&FDCAN1_IT0_IRQHandler,       // [ 39]
    (int)&FDCAN1_IT1_IRQHandler,       // [ 40]
    (int)&TIM1_BRK_IRQHandler,         // [ 41]
    (int)&TIM1_UP_IRQHandler,          // [ 42]
    (int)&TIM1_TRG_COM_IRQHandler,     // [ 43]
    (int)&TIM1_CC_IRQHandler,          // [ 44]
    (int)&TIM2_IRQHandler,             // [ 45]
    (int)&TIM3_IRQHandler,             // [ 46]
    (int)&TIM4_IRQHandler,             // [ 47]
    (int)&TIM5_IRQHandler,             // [ 48]
    (int)&TIM6_IRQHandler,             // [ 49]
    (int)&TIM7_IRQHandler,             // [ 50]
    (int)&I2C1_EV_IRQHandler,          // [ 51]
    (int)&I2C1_ER_IRQHandler,          // [ 52]
    (int)&I2C2_EV_IRQHandler,          // [ 53]
    (int)&I2C2_ER_IRQHandler,          // [ 54]
    (int)&SPI1_IRQHandler,             // [ 55]
    (int)&SPI2_IRQHandler,             // [ 56]
    (int)&SPI3_IRQHandler,             // [ 57]
    (int)&USART1_IRQHandler,           // [ 58]
    (int)&USART2_IRQHandler,           // [ 59]
    (int)&USART3_IRQHandler,           // [ 60]
    (int)&UART4_IRQHandler,            // [ 61]
    (int)&UART5_IRQHandler,            // [ 62]
    (int)&LPUART1_IRQHandler,          // [ 63]
    (int)&LPTIM1_IRQHandler,           // [ 64]
    (int)&TIM8_BRK_IRQHandler,         // [ 65]
    (int)&TIM8_UP_IRQHandler,          // [ 66]
    (int)&TIM8_TRG_COM_IRQHandler,     // [ 67]
    (int)&TIM8_CC_IRQHandler,          // [ 68]
    (int)&ADC2_IRQHandler,             // [ 69]
    (int)&LPTIM2_IRQHandler,           // [ 70]
    (int)&TIM15_IRQHandler,            // [ 71]
    (int)&Reserved72_Handler,          // [ 72]
    (int)&Reserved73_Handler,          // [ 73]
    (int)&USB_DRD_FS_IRQHandler,       // [ 74]
    (int)&CRS_IRQHandler,              // [ 75]
    (int)&UCPD1_IRQHandler,            // [ 76]
    (int)&FMC_IRQHandler,              // [ 77]
    (int)&OCTOSPI1_IRQHandler,         // [ 78]
    (int)&SDMMC1_IRQHandler,           // [ 79]
    (int)&I2C3_EV_IRQHandler,          // [ 80]
    (int)&I2C3_ER_IRQHandler,          // [ 81]
    (int)&SPI4_IRQHandler,             // [ 82]
    (int)&Reserved83_Handler,          // [ 83]
    (int)&Reserved84_Handler,          // [ 84]
    (int)&USART6_IRQHandler,           // [ 85]
    (int)&Reserved86_Handler,          // [ 86]
    (int)&Reserved87_Handler,          // [ 87]
    (int)&Reserved88_Handler,          // [ 88]
    (int)&Reserved89_Handler,          // [ 89]
    (int)&GPDMA2_Channel0_IRQHandler,  // [ 90]
    (int)&GPDMA2_Channel1_IRQHandler,  // [ 91]
    (int)&GPDMA2_Channel2_IRQHandler,  // [ 92]
    (int)&GPDMA2_Channel3_IRQHandler,  // [ 93]
    (int)&GPDMA2_Channel4_IRQHandler,  // [ 94]
    (int)&GPDMA2_Channel5_IRQHandler,  // [ 95]
    (int)&GPDMA2_Channel6_IRQHandler,  // [ 96]
    (int)&GPDMA2_Channel7_IRQHandler,  // [ 97]
    (int)&Reserved98_Handler,          // [ 98]
    (int)&Reserved99_Handler,          // [ 99]
    (int)&Reserved100_Handler,         // [100]
    (int)&Reserved101_Handler,         // [101]
    (int)&Reserved102_Handler,         // [102]
    (int)&FPU_IRQHandler,              // [103]
    (int)&ICACHE_IRQHandler,           // [104]
    (int)&DCACHE1_IRQHandler,          // [105]
    (int)&Reserved106_Handler,         // [106]
    (int)&Reserved107_Handler,         // [107]
    (int)&DCMI_PSSI_IRQHandler,        // [108]
    (int)&FDCAN2_IT0_IRQHandler,       // [109]
    (int)&FDCAN2_IT1_IRQHandler,       // [110]
    (int)&Reserved111_Handler,         // [111]
    (int)&Reserved112_Handler,         // [112]
    (int)&DTS_IRQHandler,              // [113]
    (int)&RNG_IRQHandler,              // [114]
    (int)&OTFDEC1_IRQHandler,          // [115]
    (int)&AES_IRQHandler,              // [116]
    (int)&HASH_IRQHandler,             // [117]
    (int)&PKA_IRQHandler,              // [118]
    (int)&CEC_IRQHandler,              // [119]
    (int)&TIM12_IRQHandler,            // [120]
    (int)&Reserved121_Handler,         // [121]
    (int)&Reserved122_Handler,         // [122]
    (int)&I3C1_EV_IRQHandler,          // [123]
    (int)&I3C1_ER_IRQHandler,          // [124]
    (int)&Reserved125_Handler,         // [125]
    (int)&Reserved126_Handler,         // [126]
    (int)&Reserved127_Handler,         // [127]
    (int)&Reserved128_Handler,         // [128]
    (int)&Reserved129_Handler,         // [129]
    (int)&Reserved130_Handler,         // [130]
    (int)&I3C2_EV_IRQHandler,          // [131]
    (int)&I3C2_ER_IRQHandler,          // [132]
};

// reset handler -------------------------------------------------------------
__attribute__((naked)) void Reset_Handler(void);
void Reset_Handler(void) {
    extern int main(void);
    extern int __libc_init_array(void);
    extern unsigned __data_start;  // start of .data in the linker script
    extern unsigned __data_end__;  // end of .data in the linker script
    extern unsigned const __data_load; // initialization values for .data
    extern unsigned __bss_start__; // start of .bss in the linker script
    extern unsigned __bss_end__;   // end of .bss in the linker script
    extern void software_init_hook(void) __attribute__((weak));

    SystemInit(); // CMSIS system initialization

    // copy the data segment initializers from flash to RAM...
    unsigned const *src = &__data_load;
    unsigned *dst;
    for (dst = &__data_start; dst < &__data_end__; ++dst, ++src) {
        *dst = *src;
    }

    // zero fill the .bss segment in RAM...
    for (dst = &__bss_start__; dst < &__bss_end__; ++dst) {
        *dst = 0;
    }

    // init hook provided?
    if (&software_init_hook != (void (*)(void))(0)) {
        // give control to the real-time kernel
        software_init_hook(); // this will also call __libc_init_array
    }
    else {
        // call all static constructors in C++ (harmless in C programs)
        __libc_init_array();
        (void)main(); // application's entry point; should never return!
    }

    // the previous code should not return, but assert just in case...
    __asm volatile ("  CPSID i");
    assert_failed("Reset_Handler", 1U);
}

// fault exception handlers --------------------------------------------------
__attribute__((naked)) void NMI_Handler(void);
void NMI_Handler(void) {
    // disable interrupts and reset SP in case of stack overflow
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("NMI", 1U);
}
//............................................................................
__attribute__((naked)) void HardFault_Handler(void);
void HardFault_Handler(void) {
    // disable interrupts and reset SP in case of stack overflow
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("HardFault", 1U);
}
//............................................................................
__attribute__((naked)) void MemManage_Handler(void);
void MemManage_Handler(void) {
    // disable interrupts and reset SP in case of stack overflow
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("MemManage", 1U);
}
//............................................................................
__attribute__((naked)) void BusFault_Handler(void);
void BusFault_Handler(void) {
    // disable interrupts and reset SP in case of stack overflow
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("BusFault", 1U);
}
//............................................................................
__attribute__((naked)) void UsageFault_Handler(void);
void UsageFault_Handler(void) {
    // disable interrupts and reset SP in case of stack overflow
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("UsageFault", 1U);
}
//............................................................................
__attribute__((naked)) void SecureFaultHandler(void);
void SecureFaultHandler(void) {
    // disable interrupts and reset SP in case of stack overflow
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("SecureFault", 1U);
}
//............................................................................
__attribute__((naked)) void Default_Handler(void);
void Default_Handler(void) {
    // disable interrupts and reset SP in case of stack overflow
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("Default", 1U);
}
