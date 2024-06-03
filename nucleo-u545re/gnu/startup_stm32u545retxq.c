/* File:  startup_stm32u545retxq.c for GNU-ARM compiler
 * Purpose: startup file for stm32u545retx6 device.
 *          Should be used with GCC 'GNU Tools ARM Embedded'
 * Date: 2014-06-23
 *
 * Modified by Quantum Leaps:
 * - Added relocating of the Vector Table to free up the 256B region at 0x0
 *   for NULL-pointer protection by the MPU.
 * - Modified all exception handlers to branch to assert_failed()
 *   instead of locking up the CPU inside an endless loop.
 *
 * Created from the CMSIS template for the specified device
 * Quantum Leaps, www.state-machine.com
 *
 * NOTE:
 * The function assert_failed defined at the end of this file defines
 * the error/assertion handling policy for the application and might
 * need to be customized for each project. This function is defined in
 * assembly to re-set the stack pointer, in case it is corrupted by the
 * time assert_failed is called.
 */

/* start and end of stack defined in the linker script ---------------------*/
/*extern int __stack_start__;*/
extern int __stack_end__;

/* Weak prototypes for error handlers --------------------------------------*/
/**
* \note
* The function assert_failed defined at the end of this file defines
* the error/assertion handling policy for the application and might
* need to be customized for each project. This function is defined in
* assembly to avoid accessing the stack, which might be corrupted by
* the time assert_failed is called.
*/
__attribute__ ((naked, noreturn))
void assert_failed(char const *module, int loc);

/* Function prototypes -----------------------------------------------------*/
void Default_Handler(void);  /* Default empty handler */
void Reset_Handler(void);    /* Reset Handler */
void SystemInit(void);       /* CMSIS system initialization */

/*----------------------------------------------------------------------------
* weak aliases for each Exception handler to the Default_Handler.
* Any function with the same name will override these definitions.
*/
/* Cortex-M Processor fault exceptions... */
void NMI_Handler           (void) __attribute__ ((weak));
void HardFault_Handler     (void) __attribute__ ((weak));
void MemManage_Handler     (void) __attribute__ ((weak));
void BusFault_Handler      (void) __attribute__ ((weak));
void UsageFault_Handler    (void) __attribute__ ((weak));
void SecureFault_Handler   (void) __attribute__ ((weak));

/* Cortex-M Processor non-fault exceptions... */
void SVC_Handler           (void) __attribute__ ((weak, alias("Default_Handler")));
void DebugMon_Handler      (void) __attribute__ ((weak, alias("Default_Handler")));
void PendSV_Handler        (void) __attribute__ ((weak, alias("Default_Handler")));
void SysTick_Handler       (void) __attribute__ ((weak, alias("Default_Handler")));

/* external interrupts...   */
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
void IWDG_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void SAES_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel0_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel1_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel2_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel3_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel4_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel5_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel6_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel7_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void ADC1_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void DAC1_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void FDCAN1_IT0_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void FDCAN1_IT1_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM1_BRK_IRQHandler   (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM1_UP_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM1_TRG_COM_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM1_CC_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM2_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM3_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM4_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM5_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM6_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM7_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM8_BRK_IRQHandler   (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM8_UP_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM8_TRG_COM_IRQHandler   (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM8_CC_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C1_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C1_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C2_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C2_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void SPI1_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void SPI2_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void USART1_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void USART3_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void UART4_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void UART5_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void LPUART1_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void LPTIM1_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void LPTIM2_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM15_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM16_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void TIM17_IRQHandler      (void) __attribute__ ((weak, alias("Default_Handler")));
void COMP_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void USB_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void CRS_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void OCTOSPI1_IRQHandler   (void) __attribute__ ((weak, alias("Default_Handler")));
void PWR_S3WU_IRQHandler   (void) __attribute__ ((weak, alias("Default_Handler")));
void SDMMC1_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel8_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel9_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel10_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel11_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel12_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel13_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel14_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void GPDMA1_Channel15_IRQHandler(void) __attribute__ ((weak, alias("Default_Handler")));
void I2C3_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C3_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void SAI1_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void TSC_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void AES_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void RNG_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void FPU_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void HASH_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void PKA_IRQHandler        (void) __attribute__ ((weak, alias("Default_Handler")));
void LPTIM3_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void SPI3_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C4_ER_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void I2C4_EV_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void MDF1_FLT0_IRQHandler  (void) __attribute__ ((weak, alias("Default_Handler")));
void MDF1_FLT1_IRQHandler  (void) __attribute__ ((weak, alias("Default_Handler")));
void ICACHE_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void OTFDEC1_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void LPTIM4_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void DCACHE1_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void ADF1_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void ADC4_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void LPDMA1_Channel0_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void LPDMA1_Channel1_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void LPDMA1_Channel2_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void LPDMA1_Channel3_IRQHandler (void) __attribute__ ((weak, alias("Default_Handler")));
void DCMI_PSSI_IRQHandler  (void) __attribute__ ((weak, alias("Default_Handler")));
void CORDIC_IRQHandler     (void) __attribute__ ((weak, alias("Default_Handler")));
void FMAC_IRQHandler       (void) __attribute__ ((weak, alias("Default_Handler")));
void LSECSSD_IRQHandler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved62_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved75_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved79_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved91_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved104_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved105_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved106_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved109_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved118_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved120_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved121_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void Reserved122_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));

/*..........................................................................*/
__attribute__ ((section(".isr_vector")))
int const g_pfnVectors[] = {
    (int)&__stack_end__,          /* Top of Stack                   */
    (int)&Reset_Handler,          /* Reset Handler                  */
    (int)&NMI_Handler,            /* NMI Handler                    */
    (int)&HardFault_Handler,      /* Hard Fault Handler             */
    (int)&Default_Handler,        /* Reserved                       */
    (int)&Default_Handler,        /* Reserved                       */
    (int)&Default_Handler,        /* Reserved                       */
    (int)&Default_Handler,        /* Reserved                       */
    (int)&Default_Handler,        /* Reserved                       */
    (int)&Default_Handler,        /* Reserved                       */
    (int)&Default_Handler,        /* Reserved                       */
    (int)&SVC_Handler,            /* SVCall handler                 */
    (int)&DebugMon_Handler,       /* Debug monitor handler          */
    (int)&Default_Handler,        /* Reserved                       */
    (int)&PendSV_Handler,         /* The PendSV handler             */
    (int)&SysTick_Handler,        /* The SysTick handler            */

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
    (int)&IWDG_IRQHandler,             // [ 27]
    (int)&SAES_IRQHandler,             // [ 28]
    (int)&GPDMA1_Channel0_IRQHandler,  // [ 29]
    (int)&GPDMA1_Channel1_IRQHandler,  // [ 30]
    (int)&GPDMA1_Channel2_IRQHandler,  // [ 31]
    (int)&GPDMA1_Channel3_IRQHandler,  // [ 32]
    (int)&GPDMA1_Channel4_IRQHandler,  // [ 33]
    (int)&GPDMA1_Channel5_IRQHandler,  // [ 34]
    (int)&GPDMA1_Channel6_IRQHandler,  // [ 35]
    (int)&GPDMA1_Channel7_IRQHandler,  // [ 36]
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
    (int)&TIM8_BRK_IRQHandler,         // [ 51]
    (int)&TIM8_UP_IRQHandler,          // [ 52]
    (int)&TIM8_TRG_COM_IRQHandler,     // [ 53]
    (int)&TIM8_CC_IRQHandler,          // [ 54]
    (int)&I2C1_EV_IRQHandler,          // [ 55]
    (int)&I2C1_ER_IRQHandler,          // [ 56]
    (int)&I2C2_EV_IRQHandler,          // [ 57]
    (int)&I2C2_ER_IRQHandler,          // [ 58]
    (int)&SPI1_IRQHandler,             // [ 59]
    (int)&SPI2_IRQHandler,             // [ 60]
    (int)&USART1_IRQHandler,           // [ 61]
    (int)&Reserved62_Handler,          // [ 62]
    (int)&USART3_IRQHandler,           // [ 63]
    (int)&UART4_IRQHandler,            // [ 64]
    (int)&UART5_IRQHandler,            // [ 65]
    (int)&LPUART1_IRQHandler,          // [ 66]
    (int)&LPTIM1_IRQHandler,           // [ 67]
    (int)&LPTIM2_IRQHandler,           // [ 68]
    (int)&TIM15_IRQHandler,            // [ 69]
    (int)&TIM16_IRQHandler,            // [ 70]
    (int)&TIM17_IRQHandler,            // [ 71]
    (int)&COMP_IRQHandler,             // [ 72]
    (int)&USB_IRQHandler,              // [ 73]
    (int)&CRS_IRQHandler,              // [ 74]
    (int)&Reserved75_Handler,          // [ 75]
    (int)&OCTOSPI1_IRQHandler,         // [ 76]
    (int)&PWR_S3WU_IRQHandler,         // [ 77]
    (int)&SDMMC1_IRQHandler,           // [ 78]
    (int)&Reserved79_Handler,          // [ 79]
    (int)&GPDMA1_Channel8_IRQHandler,  // [ 80]
    (int)&GPDMA1_Channel9_IRQHandler,  // [ 81]
    (int)&GPDMA1_Channel10_IRQHandler, // [ 82]
    (int)&GPDMA1_Channel11_IRQHandler, // [ 83]
    (int)&GPDMA1_Channel12_IRQHandler, // [ 84]
    (int)&GPDMA1_Channel13_IRQHandler, // [ 85]
    (int)&GPDMA1_Channel14_IRQHandler, // [ 86]
    (int)&GPDMA1_Channel15_IRQHandler, // [ 87]
    (int)&I2C3_EV_IRQHandler,          // [ 88]
    (int)&I2C3_ER_IRQHandler,          // [ 89]
    (int)&SAI1_IRQHandler,             // [ 90]
    (int)&Reserved91_Handler,          // [ 91]
    (int)&TSC_IRQHandler,              // [ 92]
    (int)&AES_IRQHandler,              // [ 93]
    (int)&RNG_IRQHandler,              // [ 94]
    (int)&FPU_IRQHandler,              // [ 95]
    (int)&HASH_IRQHandler,             // [ 96]
    (int)&PKA_IRQHandler,              // [ 97]
    (int)&LPTIM3_IRQHandler,           // [ 98]
    (int)&SPI3_IRQHandler,             // [ 99]
    (int)&I2C4_ER_IRQHandler,          // [100]
    (int)&I2C4_EV_IRQHandler,          // [101]
    (int)&MDF1_FLT0_IRQHandler,        // [102]
    (int)&MDF1_FLT1_IRQHandler,        // [103]
    (int)&Reserved104_Handler,         // [104]
    (int)&Reserved105_Handler,         // [105]
    (int)&Reserved106_Handler,         // [106]
    (int)&ICACHE_IRQHandler,           // [107]
    (int)&OTFDEC1_IRQHandler,          // [108]
    (int)&Reserved109_Handler,         // [109]
    (int)&LPTIM4_IRQHandler,           // [110]
    (int)&DCACHE1_IRQHandler,          // [111]
    (int)&ADF1_IRQHandler,             // [112]
    (int)&ADC4_IRQHandler,             // [113]
    (int)&LPDMA1_Channel0_IRQHandler,  // [114]
    (int)&LPDMA1_Channel1_IRQHandler,  // [115]
    (int)&LPDMA1_Channel2_IRQHandler,  // [116]
    (int)&LPDMA1_Channel3_IRQHandler,  // [117]
    (int)&Reserved118_Handler,         // [118]
    (int)&DCMI_PSSI_IRQHandler,        // [119]
    (int)&Reserved120_Handler,         // [120]
    (int)&Reserved121_Handler,         // [121]
    (int)&Reserved122_Handler,         // [122]
    (int)&CORDIC_IRQHandler,           // [113]
    (int)&FMAC_IRQHandler,             // [114]
    (int)&LSECSSD_IRQHandler,          // [115]
};

/* reset handler -----------------------------------------------------------*/
__attribute__((naked)) void Reset_Handler(void);
void Reset_Handler(void) {
    extern int main(void);
    extern int __libc_init_array(void);
    extern unsigned __data_start;  /* start of .data in the linker script */
    extern unsigned __data_end__;  /* end of .data in the linker script */
    extern unsigned const __data_load; /* initialization values for .data  */
    extern unsigned __bss_start__; /* start of .bss in the linker script */
    extern unsigned __bss_end__;   /* end of .bss in the linker script */
    extern void software_init_hook(void) __attribute__((weak));

    SystemInit(); /* CMSIS system initialization */

    /* copy the data segment initializers from flash to RAM... */
    unsigned const *src = &__data_load;
    unsigned *dst;
    for (dst = &__data_start; dst < &__data_end__; ++dst, ++src) {
        *dst = *src;
    }

    /* zero fill the .bss segment in RAM... */
    for (dst = &__bss_start__; dst < &__bss_end__; ++dst) {
        *dst = 0;
    }

    /* init hook provided? */
    if (&software_init_hook != (void (*)(void))(0)) {
        /* give control to the RTOS */
        software_init_hook(); /* this will also call __libc_init_array */
    }
    else {
        /* call all static constructors in C++ (harmless in C programs) */
        __libc_init_array();
        (void)main(); /* application's entry point; should never return! */
    }

    /* the previous code should not return, but assert just in case... */
    __asm volatile ("  CPSID i");
    assert_failed("Reset_Handler", 1U);
}

/* fault exception handlers ------------------------------------------------*/
__attribute__((naked)) void NMI_Handler(void);
void NMI_Handler(void) {
    /* disable interrupts and reset SP in case of stack overflow */
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("NMI", 1U);
}
/*..........................................................................*/
__attribute__((naked)) void HardFault_Handler(void);
void HardFault_Handler(void) {
    /* disable interrupts and reset SP in case of stack overflow */
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("HardFault", 1U);
}
/*..........................................................................*/
__attribute__((naked)) void MemManage_Handler(void);
void MemManage_Handler(void) {
    /* disable interrupts and reset SP in case of stack overflow */
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("MemManage", 1U);
}
/*..........................................................................*/
__attribute__((naked)) void BusFault_Handler(void);
void BusFault_Handler(void) {
    /* disable interrupts and reset SP in case of stack overflow */
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("BusFault", 1U);
}
/*..........................................................................*/
__attribute__((naked)) void UsageFault_Handler(void);
void UsageFault_Handler(void) {
    /* disable interrupts and reset SP in case of stack overflow */
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("UsageFault", 1U);
}
/*..........................................................................*/
__attribute__((naked)) void SecureFaultHandler(void);
void SecureFaultHandler(void) {
    /* disable interrupts and reset SP in case of stack overflow */
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("SecureFault", 1U);
}
/*..........................................................................*/
__attribute__((naked)) void Default_Handler(void);
void Default_Handler(void) {
    /* disable interrupts and reset SP in case of stack overflow */
    __asm volatile ("  CPSID i\n  MOV   sp,%0" : : "r" (&__stack_end__));
    assert_failed("Default", 1U);
}
