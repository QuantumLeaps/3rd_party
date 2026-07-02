;/***************************************************************************/
; @file     startup_stm32h533retx.s for IAR ARM assembler
; @brief    CMSIS Cortex-M Core Device Startup File for stm32h533retx
; @date     23 Jun 2026
;
; Modified by Quantum Leaps:
; - Added relocating of the Vector Table to free up the 256B region at 0x0
;   for NULL-pointer protection by the MPU.
; - Modified all exception handlers to branch to assert_failed()
;   instead of locking up the CPU inside an endless loop.
; *
; * @description
; * Created from the CMSIS template for the specified device
; * Quantum Leaps, www.state-machine.com
; *

        MODULE  ?cstartup

        ; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)

        SECTION .intvec:CODE:NOROOT(8)

        PUBLIC  __vector_table
        PUBLIC  __Vectors
        PUBLIC  __Vectors_End
        PUBLIC  __Vectors_Size

;******************************************************************************
; The vector table
;
        DATA
__vector_table
        DCD     sfe(CSTACK)                 ; Top of Stack
        DCD     Reset_Handler               ; Reset Handler
        DCD     NMI_Handler                 ; NMI Handler
        DCD     HardFault_Handler           ; Hard Fault Handler
        DCD     MemManage_Handler           ; Memory Manage (MPU) Handler
        DCD     BusFault_Handler            ; Bus Fault Handler
        DCD     UsageFault_Handler          ; Usage Fault Handler
        DCD     SecureFault_Handler         ; Secure Fault Handler
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     SVC_Handler                 ; SVCall handler
        DCD     DebugMon_Handler            ; Debug Monitor handler
        DCD     Default_Handler             ; Reserved
        DCD     PendSV_Handler              ; PendSV handler
        DCD     SysTick_Handler             ; SysTick handler

        ; IRQ handlers...
        DCD     WWDG_IRQHandler             ; [  0]
        DCD     PVD_AVD_IRQHandler          ; [  1]
        DCD     RTC_IRQHandler              ; [  2]
        DCD     RTC_S_IRQHandler            ; [  3]
        DCD     TAMP_IRQHandler             ; [  4]
        DCD     RAMCFG_IRQHandler           ; [  5]
        DCD     FLASH_IRQHandler            ; [  6]
        DCD     FLASH_S_IRQHandler          ; [  7]
        DCD     GTZC_IRQHandler             ; [  8]
        DCD     RCC_IRQHandler              ; [  9]
        DCD     RCC_S_IRQHandler            ; [ 10]
        DCD     EXTI0_IRQHandler            ; [ 11]
        DCD     EXTI1_IRQHandler            ; [ 12]
        DCD     EXTI2_IRQHandler            ; [ 13]
        DCD     EXTI3_IRQHandler            ; [ 14]
        DCD     EXTI4_IRQHandler            ; [ 15]
        DCD     EXTI5_IRQHandler            ; [ 16]
        DCD     EXTI6_IRQHandler            ; [ 17]
        DCD     EXTI7_IRQHandler            ; [ 18]
        DCD     EXTI8_IRQHandler            ; [ 19]
        DCD     EXTI9_IRQHandler            ; [ 20]
        DCD     EXTI10_IRQHandler           ; [ 21]
        DCD     EXTI11_IRQHandler           ; [ 22]
        DCD     EXTI12_IRQHandler           ; [ 23]
        DCD     EXTI13_IRQHandler           ; [ 24]
        DCD     EXTI14_IRQHandler           ; [ 25]
        DCD     EXTI15_IRQHandler           ; [ 26]
        DCD     GPDMA1_Channel0_IRQHandler  ; [ 27]
        DCD     GPDMA1_Channel1_IRQHandler  ; [ 28]
        DCD     GPDMA1_Channel2_IRQHandler  ; [ 29]
        DCD     GPDMA1_Channel3_IRQHandler  ; [ 30]
        DCD     GPDMA1_Channel4_IRQHandler  ; [ 31]
        DCD     GPDMA1_Channel5_IRQHandler  ; [ 32]
        DCD     GPDMA1_Channel6_IRQHandler  ; [ 33]
        DCD     GPDMA1_Channel7_IRQHandler  ; [ 34]
        DCD     IWDG_IRQHandler             ; [ 35]
        DCD     SAES_IRQHandler             ; [ 36]
        DCD     ADC1_IRQHandler             ; [ 37]
        DCD     DAC1_IRQHandler             ; [ 38]
        DCD     FDCAN1_IT0_IRQHandler       ; [ 39]
        DCD     FDCAN1_IT1_IRQHandler       ; [ 40]
        DCD     TIM1_BRK_IRQHandler         ; [ 41]
        DCD     TIM1_UP_IRQHandler          ; [ 42]
        DCD     TIM1_TRG_COM_IRQHandler     ; [ 43]
        DCD     TIM1_CC_IRQHandler          ; [ 44]
        DCD     TIM2_IRQHandler             ; [ 45]
        DCD     TIM3_IRQHandler             ; [ 46]
        DCD     TIM4_IRQHandler             ; [ 47]
        DCD     TIM5_IRQHandler             ; [ 48]
        DCD     TIM6_IRQHandler             ; [ 49]
        DCD     TIM7_IRQHandler             ; [ 50]
        DCD     I2C1_EV_IRQHandler          ; [ 51]
        DCD     I2C1_ER_IRQHandler          ; [ 52]
        DCD     I2C2_EV_IRQHandler          ; [ 53]
        DCD     I2C2_ER_IRQHandler          ; [ 54]
        DCD     SPI1_IRQHandler             ; [ 55]
        DCD     SPI2_IRQHandler             ; [ 56]
        DCD     SPI3_IRQHandler             ; [ 57]
        DCD     USART1_IRQHandler           ; [ 58]
        DCD     USART2_IRQHandler           ; [ 59]
        DCD     USART3_IRQHandler           ; [ 60]
        DCD     UART4_IRQHandler            ; [ 61]
        DCD     UART5_IRQHandler            ; [ 62]
        DCD     LPUART1_IRQHandler          ; [ 63]
        DCD     LPTIM1_IRQHandler           ; [ 64]
        DCD     TIM8_BRK_IRQHandler         ; [ 65]
        DCD     TIM8_UP_IRQHandler          ; [ 66]
        DCD     TIM8_TRG_COM_IRQHandler     ; [ 67]
        DCD     TIM8_CC_IRQHandler          ; [ 68]
        DCD     ADC2_IRQHandler             ; [ 69]
        DCD     LPTIM2_IRQHandler           ; [ 70]
        DCD     TIM15_IRQHandler            ; [ 71]
        DCD     Reserved72_Handler          ; [ 72]
        DCD     Reserved73_Handler          ; [ 73]
        DCD     USB_DRD_FS_IRQHandler       ; [ 74]
        DCD     CRS_IRQHandler              ; [ 75]
        DCD     UCPD1_IRQHandler            ; [ 76]
        DCD     FMC_IRQHandler              ; [ 77]
        DCD     OCTOSPI1_IRQHandler         ; [ 78]
        DCD     SDMMC1_IRQHandler           ; [ 79]
        DCD     I2C3_EV_IRQHandler          ; [ 80]
        DCD     I2C3_ER_IRQHandler          ; [ 81]
        DCD     SPI4_IRQHandler             ; [ 82]
        DCD     Reserved83_Handler          ; [ 83]
        DCD     Reserved84_Handler          ; [ 84]
        DCD     USART6_IRQHandler           ; [ 85]
        DCD     Reserved86_Handler          ; [ 86]
        DCD     Reserved87_Handler          ; [ 87]
        DCD     Reserved88_Handler          ; [ 88]
        DCD     Reserved89_Handler          ; [ 89]
        DCD     GPDMA2_Channel0_IRQHandler  ; [ 90]
        DCD     GPDMA2_Channel1_IRQHandler  ; [ 91]
        DCD     GPDMA2_Channel2_IRQHandler  ; [ 92]
        DCD     GPDMA2_Channel3_IRQHandler  ; [ 93]
        DCD     GPDMA2_Channel4_IRQHandler  ; [ 94]
        DCD     GPDMA2_Channel5_IRQHandler  ; [ 95]
        DCD     GPDMA2_Channel6_IRQHandler  ; [ 96]
        DCD     GPDMA2_Channel7_IRQHandler  ; [ 97]
        DCD     Reserved98_Handler          ; [ 98]
        DCD     Reserved99_Handler          ; [ 99]
        DCD     Reserved100_Handler         ; [100]
        DCD     Reserved101_Handler         ; [101]
        DCD     Reserved102_Handler         ; [102]
        DCD     FPU_IRQHandler              ; [103]
        DCD     ICACHE_IRQHandler           ; [104]
        DCD     DCACHE1_IRQHandler          ; [105]
        DCD     Reserved106_Handler         ; [106]
        DCD     Reserved107_Handler         ; [107]
        DCD     DCMI_PSSI_IRQHandler        ; [108]
        DCD     FDCAN2_IT0_IRQHandler       ; [109]
        DCD     FDCAN2_IT1_IRQHandler       ; [110]
        DCD     Reserved111_Handler         ; [111]
        DCD     Reserved112_Handler         ; [112]
        DCD     DTS_IRQHandler              ; [113]
        DCD     RNG_IRQHandler              ; [114]
        DCD     OTFDEC1_IRQHandler          ; [115]
        DCD     AES_IRQHandler              ; [116]
        DCD     HASH_IRQHandler             ; [117]
        DCD     PKA_IRQHandler              ; [118]
        DCD     CEC_IRQHandler              ; [119]
        DCD     TIM12_IRQHandler            ; [120]
        DCD     Reserved121_Handler         ; [121]
        DCD     Reserved122_Handler         ; [122]
        DCD     I3C1_EV_IRQHandler          ; [123]
        DCD     I3C1_ER_IRQHandler          ; [124]
        DCD     Reserved125_Handler         ; [125]
        DCD     Reserved126_Handler         ; [126]
        DCD     Reserved127_Handler         ; [127]
        DCD     Reserved128_Handler         ; [128]
        DCD     Reserved129_Handler         ; [129]
        DCD     Reserved130_Handler         ; [130]
        DCD     I3C2_EV_IRQHandler          ; [131]
        DCD     I3C2_ER_IRQHandler          ; [132]

__Vectors_End

__Vectors       EQU   __vector_table
__Vectors_Size  EQU   __Vectors_End - __Vectors


;******************************************************************************
; This is the code for exception handlers.
;
        SECTION .text:CODE:REORDER:NOROOT(2)

;******************************************************************************
; This is the code that gets called when the CPU first starts execution
; following a reset event.
;
        PUBWEAK Reset_Handler
        EXTERN  SystemInit
        EXTERN  __iar_program_start
        EXTERN  assert_failed

Reset_Handler
        LDR     r0,=SystemInit  ; CMSIS system initialization
        BLX     r0

        ; pre-fill the CSTACK with 0xDEADBEEF...................
        LDR     r0,=0xDEADBEEF
        MOV     r1,r0
        LDR     r2,=sfb(CSTACK)
        LDR     r3,=sfe(CSTACK)
Reset_stackInit_fill:
        STMIA   r2!,{r0,r1}
        CMP     r2,r3
        BLT.N   Reset_stackInit_fill

        LDR     r0,=__iar_program_start ; IAR startup code
        BLX     r0

        ; __iar_program_start calls the main() function, which should not return,
        ; but just in case jump to assert_failed() if main returns.
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_EXIT
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_EXIT
        DCB     "EXIT"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK NMI_Handler
NMI_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_NMI
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_NMI
        DCB     "NMI"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK HardFault_Handler
HardFault_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_HardFault
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_HardFault
        DCB     "HardFault"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK MemManage_Handler
MemManage_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_MemManage
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_MemManage
        DCB     "MemManage"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK BusFault_Handler
BusFault_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_BusFault
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_BusFault
        DCB     "BusFault"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK UsageFault_Handler
UsageFault_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_UsageFault
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_UsageFault
        DCB     "UsageFault"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK SecureFault_Handler
SecureFault_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_SecureFault
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_SecureFault
        DCB     "SecureFault"
        ALIGNROM 2



;******************************************************************************
;
; Weak non-fault handlers...
;

;******************************************************************************
        PUBWEAK SVC_Handler
SVC_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_SVC
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_SVC
        DCB     "SVC"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK DebugMon_Handler
DebugMon_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_DebugMon
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_DebugMon
        DCB     "DebugMon"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK PendSV_Handler
PendSV_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_PendSV
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_PendSV
        DCB     "PendSV"
        ALIGNROM 2

;******************************************************************************
        PUBWEAK SysTick_Handler
SysTick_Handler
        CPSID   i                ; disable all interrupts
        LDR     r0,=str_SysTick
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_SysTick
        DCB     "SysTick"
        ALIGNROM 2

;******************************************************************************
; Weak IRQ handlers...
;
        PUBWEAK Default_Handler
        PUBWEAK WWDG_IRQHandler
        PUBWEAK PVD_AVD_IRQHandler
        PUBWEAK RTC_IRQHandler
        PUBWEAK RTC_S_IRQHandler
        PUBWEAK TAMP_IRQHandler
        PUBWEAK RAMCFG_IRQHandler
        PUBWEAK FLASH_IRQHandler
        PUBWEAK FLASH_S_IRQHandler
        PUBWEAK GTZC_IRQHandler
        PUBWEAK RCC_IRQHandler
        PUBWEAK RCC_S_IRQHandler
        PUBWEAK EXTI0_IRQHandler
        PUBWEAK EXTI1_IRQHandler
        PUBWEAK EXTI2_IRQHandler
        PUBWEAK EXTI3_IRQHandler
        PUBWEAK EXTI4_IRQHandler
        PUBWEAK EXTI5_IRQHandler
        PUBWEAK EXTI6_IRQHandler
        PUBWEAK EXTI7_IRQHandler
        PUBWEAK EXTI8_IRQHandler
        PUBWEAK EXTI9_IRQHandler
        PUBWEAK EXTI10_IRQHandler
        PUBWEAK EXTI11_IRQHandler
        PUBWEAK EXTI12_IRQHandler
        PUBWEAK EXTI13_IRQHandler
        PUBWEAK EXTI14_IRQHandler
        PUBWEAK EXTI15_IRQHandler
        PUBWEAK GPDMA1_Channel0_IRQHandler
        PUBWEAK GPDMA1_Channel1_IRQHandler
        PUBWEAK GPDMA1_Channel2_IRQHandler
        PUBWEAK GPDMA1_Channel3_IRQHandler
        PUBWEAK GPDMA1_Channel4_IRQHandler
        PUBWEAK GPDMA1_Channel5_IRQHandler
        PUBWEAK GPDMA1_Channel6_IRQHandler
        PUBWEAK GPDMA1_Channel7_IRQHandler
        PUBWEAK IWDG_IRQHandler
        PUBWEAK SAES_IRQHandler
        PUBWEAK ADC1_IRQHandler
        PUBWEAK DAC1_IRQHandler
        PUBWEAK FDCAN1_IT0_IRQHandler
        PUBWEAK FDCAN1_IT1_IRQHandler
        PUBWEAK TIM1_BRK_IRQHandler
        PUBWEAK TIM1_UP_IRQHandler
        PUBWEAK TIM1_TRG_COM_IRQHandler
        PUBWEAK TIM1_CC_IRQHandler
        PUBWEAK TIM2_IRQHandler
        PUBWEAK TIM3_IRQHandler
        PUBWEAK TIM4_IRQHandler
        PUBWEAK TIM5_IRQHandler
        PUBWEAK TIM6_IRQHandler
        PUBWEAK TIM7_IRQHandler
        PUBWEAK I2C1_EV_IRQHandler
        PUBWEAK I2C1_ER_IRQHandler
        PUBWEAK I2C2_EV_IRQHandler
        PUBWEAK I2C2_ER_IRQHandler
        PUBWEAK SPI1_IRQHandler
        PUBWEAK SPI2_IRQHandler
        PUBWEAK SPI3_IRQHandler
        PUBWEAK USART1_IRQHandler
        PUBWEAK USART2_IRQHandler
        PUBWEAK USART3_IRQHandler
        PUBWEAK UART4_IRQHandler
        PUBWEAK UART5_IRQHandler
        PUBWEAK LPUART1_IRQHandler
        PUBWEAK LPTIM1_IRQHandler
        PUBWEAK TIM8_BRK_IRQHandler
        PUBWEAK TIM8_UP_IRQHandler
        PUBWEAK TIM8_TRG_COM_IRQHandler
        PUBWEAK TIM8_CC_IRQHandler
        PUBWEAK ADC2_IRQHandler
        PUBWEAK LPTIM2_IRQHandler
        PUBWEAK TIM15_IRQHandler
        PUBWEAK USB_DRD_FS_IRQHandler
        PUBWEAK CRS_IRQHandler
        PUBWEAK UCPD1_IRQHandler
        PUBWEAK FMC_IRQHandler
        PUBWEAK OCTOSPI1_IRQHandler
        PUBWEAK SDMMC1_IRQHandler
        PUBWEAK I2C3_EV_IRQHandler
        PUBWEAK I2C3_ER_IRQHandler
        PUBWEAK SPI4_IRQHandler
        PUBWEAK USART6_IRQHandler
        PUBWEAK GPDMA2_Channel0_IRQHandler
        PUBWEAK GPDMA2_Channel1_IRQHandler
        PUBWEAK GPDMA2_Channel2_IRQHandler
        PUBWEAK GPDMA2_Channel3_IRQHandler
        PUBWEAK GPDMA2_Channel4_IRQHandler
        PUBWEAK GPDMA2_Channel5_IRQHandler
        PUBWEAK GPDMA2_Channel6_IRQHandler
        PUBWEAK GPDMA2_Channel7_IRQHandler
        PUBWEAK FPU_IRQHandler
        PUBWEAK ICACHE_IRQHandler
        PUBWEAK DCACHE1_IRQHandler
        PUBWEAK DCMI_PSSI_IRQHandler
        PUBWEAK FDCAN2_IT0_IRQHandler
        PUBWEAK FDCAN2_IT1_IRQHandler
        PUBWEAK DTS_IRQHandler
        PUBWEAK RNG_IRQHandler
        PUBWEAK OTFDEC1_IRQHandler
        PUBWEAK AES_IRQHandler
        PUBWEAK HASH_IRQHandler
        PUBWEAK PKA_IRQHandler
        PUBWEAK CEC_IRQHandler
        PUBWEAK TIM12_IRQHandler
        PUBWEAK I3C1_EV_IRQHandler
        PUBWEAK I3C1_ER_IRQHandler
        PUBWEAK I3C2_EV_IRQHandler
        PUBWEAK I3C2_ER_IRQHandler
        PUBWEAK Reserved72_Handler
        PUBWEAK Reserved73_Handler
        PUBWEAK Reserved83_Handler
        PUBWEAK Reserved84_Handler
        PUBWEAK Reserved86_Handler
        PUBWEAK Reserved87_Handler
        PUBWEAK Reserved88_Handler
        PUBWEAK Reserved89_Handler
        PUBWEAK Reserved98_Handler
        PUBWEAK Reserved99_Handler
        PUBWEAK Reserved100_Handler
        PUBWEAK Reserved101_Handler
        PUBWEAK Reserved102_Handler
        PUBWEAK Reserved106_Handler
        PUBWEAK Reserved107_Handler
        PUBWEAK Reserved111_Handler
        PUBWEAK Reserved112_Handler
        PUBWEAK Reserved121_Handler
        PUBWEAK Reserved122_Handler
        PUBWEAK Reserved125_Handler
        PUBWEAK Reserved126_Handler
        PUBWEAK Reserved127_Handler
        PUBWEAK Reserved128_Handler
        PUBWEAK Reserved129_Handler
        PUBWEAK Reserved130_Handler


Default_Handler
WWDG_IRQHandler
PVD_AVD_IRQHandler
RTC_IRQHandler
RTC_S_IRQHandler
TAMP_IRQHandler
RAMCFG_IRQHandler
FLASH_IRQHandler
FLASH_S_IRQHandler
GTZC_IRQHandler
RCC_IRQHandler
RCC_S_IRQHandler
EXTI0_IRQHandler
EXTI1_IRQHandler
EXTI2_IRQHandler
EXTI3_IRQHandler
EXTI4_IRQHandler
EXTI5_IRQHandler
EXTI6_IRQHandler
EXTI7_IRQHandler
EXTI8_IRQHandler
EXTI9_IRQHandler
EXTI10_IRQHandler
EXTI11_IRQHandler
EXTI12_IRQHandler
EXTI13_IRQHandler
EXTI14_IRQHandler
EXTI15_IRQHandler
GPDMA1_Channel0_IRQHandler
GPDMA1_Channel1_IRQHandler
GPDMA1_Channel2_IRQHandler
GPDMA1_Channel3_IRQHandler
GPDMA1_Channel4_IRQHandler
GPDMA1_Channel5_IRQHandler
GPDMA1_Channel6_IRQHandler
GPDMA1_Channel7_IRQHandler
IWDG_IRQHandler
SAES_IRQHandler
ADC1_IRQHandler
DAC1_IRQHandler
FDCAN1_IT0_IRQHandler
FDCAN1_IT1_IRQHandler
TIM1_BRK_IRQHandler
TIM1_UP_IRQHandler
TIM1_TRG_COM_IRQHandler
TIM1_CC_IRQHandler
TIM2_IRQHandler
TIM3_IRQHandler
TIM4_IRQHandler
TIM5_IRQHandler
TIM6_IRQHandler
TIM7_IRQHandler
I2C1_EV_IRQHandler
I2C1_ER_IRQHandler
I2C2_EV_IRQHandler
I2C2_ER_IRQHandler
SPI1_IRQHandler
SPI2_IRQHandler
SPI3_IRQHandler
USART1_IRQHandler
USART2_IRQHandler
USART3_IRQHandler
UART4_IRQHandler
UART5_IRQHandler
LPUART1_IRQHandler
LPTIM1_IRQHandler
TIM8_BRK_IRQHandler
TIM8_UP_IRQHandler
TIM8_TRG_COM_IRQHandler
TIM8_CC_IRQHandler
ADC2_IRQHandler
LPTIM2_IRQHandler
TIM15_IRQHandler
USB_DRD_FS_IRQHandler
CRS_IRQHandler
UCPD1_IRQHandler
FMC_IRQHandler
OCTOSPI1_IRQHandler
SDMMC1_IRQHandler
I2C3_EV_IRQHandler
I2C3_ER_IRQHandler
SPI4_IRQHandler
USART6_IRQHandler
GPDMA2_Channel0_IRQHandler
GPDMA2_Channel1_IRQHandler
GPDMA2_Channel2_IRQHandler
GPDMA2_Channel3_IRQHandler
GPDMA2_Channel4_IRQHandler
GPDMA2_Channel5_IRQHandler
GPDMA2_Channel6_IRQHandler
GPDMA2_Channel7_IRQHandler
FPU_IRQHandler
ICACHE_IRQHandler
DCACHE1_IRQHandler
DCMI_PSSI_IRQHandler
FDCAN2_IT0_IRQHandler
FDCAN2_IT1_IRQHandler
DTS_IRQHandler
RNG_IRQHandler
OTFDEC1_IRQHandler
AES_IRQHandler
HASH_IRQHandler
PKA_IRQHandler
CEC_IRQHandler
TIM12_IRQHandler
I3C1_EV_IRQHandler
I3C1_ER_IRQHandler
I3C2_EV_IRQHandler
I3C2_ER_IRQHandler
Reserved72_Handler
Reserved73_Handler
Reserved83_Handler
Reserved84_Handler
Reserved86_Handler
Reserved87_Handler
Reserved88_Handler
Reserved89_Handler
Reserved98_Handler
Reserved99_Handler
Reserved100_Handler
Reserved101_Handler
Reserved102_Handler
Reserved106_Handler
Reserved107_Handler
Reserved111_Handler
Reserved112_Handler
Reserved121_Handler
Reserved122_Handler
Reserved125_Handler
Reserved126_Handler
Reserved127_Handler
Reserved128_Handler
Reserved129_Handler
Reserved130_Handler
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_Undefined
        MOVS    r1,#1
        LDR     r2,=sfe(CSTACK)  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_Undefined
        DCB     "Undefined"
        ALIGNROM 2

        END                      ; end of module

