;/***************************************************************************/
; @file     startup_stm32l552xx.s for IAR assembler
; @brief    CMSIS Cortex-M33 Core Device Startup File for STM32L552xx devices
; @version  CMSIS 5.9.0
; @date     1 Feb 2023
;
; Modified by Quantum Leaps:
; - Added relocating of the Vector Table to free up the 256B region at 0x0
;   for NULL-pointer protection by the MPU.
; - Modified all exception handlers to branch to assert_failed()
;   instead of locking up the CPU inside an endless loop.
;
; @description
; Created from the CMSIS template for the specified device
; Quantum Leaps, www.state-machine.com
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
        DCD     sfe(CSTACK)
        DCD     Reset_Handler               ; Reset Handler
        DCD     NMI_Handler                 ; NMI Handler
        DCD     HardFault_Handler           ; Hard Fault Handler
        DCD     MemManage_Handler           ; MPU fault handler
        DCD     BusFault_Handler            ; Bus fault handler
        DCD     UsageFault_Handler          ; Usage fault handler
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
        DCD     WWDG_IRQHandler             ; Window WatchDog
        DCD     PVD_PVM_IRQHandler          ; PVD/PVM1/PVM2/PVM3/PVM4 through EXTI Line detection
        DCD     RTC_IRQHandler              ; RTC non-secure interrupts through the EXTI line
        DCD     RTC_S_IRQHandler            ; RTC secure interrupts through the EXTI line
        DCD     TAMP_IRQHandler             ; Tamper non-secure interrupts through the EXTI line
        DCD     TAMP_S_IRQHandler           ; Tamper secure interrupts through the EXTI line
        DCD     FLASH_IRQHandler            ; FLASH non-secure interrupts
        DCD     FLASH_S_IRQHandler          ; FLASH secure global interrupts
        DCD     GTZC_IRQHandler             ; GTZC global interrupts
        DCD     RCC_IRQHandler              ; RCC non-secure global interrupts
        DCD     RCC_S_IRQHandler            ; RCC secure global interrupts
        DCD     EXTI0_IRQHandler            ; EXTI Line0
        DCD     EXTI1_IRQHandler            ; EXTI Line1
        DCD     EXTI2_IRQHandler            ; EXTI Line2
        DCD     EXTI3_IRQHandler            ; EXTI Line3
        DCD     EXTI4_IRQHandler            ; EXTI Line4
        DCD     EXTI5_IRQHandler            ; EXTI Line5
        DCD     EXTI6_IRQHandler            ; EXTI Line6
        DCD     EXTI7_IRQHandler            ; EXTI Line7
        DCD     EXTI8_IRQHandler            ; EXTI Line8
        DCD     EXTI9_IRQHandler            ; EXTI Line9
        DCD     EXTI10_IRQHandler           ; EXTI Line10
        DCD     EXTI11_IRQHandler           ; EXTI Line11
        DCD     EXTI12_IRQHandler           ; EXTI Line12
        DCD     EXTI13_IRQHandler           ; EXTI Line13
        DCD     EXTI14_IRQHandler           ; EXTI Line14
        DCD     EXTI15_IRQHandler           ; EXTI Line15
        DCD     DMAMUX1_IRQHandler          ; DMAMUX1 non-secure
        DCD     DMAMUX1_S_IRQHandler        ; DMAMUX1 secure
        DCD     DMA1_Channel1_IRQHandler    ; DMA1 Channel 1
        DCD     DMA1_Channel2_IRQHandler    ; DMA1 Channel 2
        DCD     DMA1_Channel3_IRQHandler    ; DMA1 Channel 3
        DCD     DMA1_Channel4_IRQHandler    ; DMA1 Channel 4
        DCD     DMA1_Channel5_IRQHandler    ; DMA1 Channel 5
        DCD     DMA1_Channel6_IRQHandler    ; DMA1 Channel 6
        DCD     DMA1_Channel7_IRQHandler    ; DMA1 Channel 7
        DCD     DMA1_Channel8_IRQHandler    ; DMA1 Channel 8
        DCD     ADC1_2_IRQHandler           ; ADC1 & ADC2
        DCD     DAC_IRQHandler              ; DAC1&2 underrun errors
        DCD     FDCAN1_IT0_IRQHandler       ; FDCAN1 Interrupt 0
        DCD     FDCAN1_IT1_IRQHandler       ; FDCAN1 Interrupt 1
        DCD     TIM1_BRK_IRQHandler         ; TIM1 Break
        DCD     TIM1_UP_IRQHandler          ; TIM1 Update
        DCD     TIM1_TRG_COM_IRQHandler     ; TIM1 Trigger and Commutation
        DCD     TIM1_CC_IRQHandler          ; TIM1 Capture Compare
        DCD     TIM2_IRQHandler             ; TIM2
        DCD     TIM3_IRQHandler             ; TIM3
        DCD     TIM4_IRQHandler             ; TIM4
        DCD     TIM5_IRQHandler             ; TIM5
        DCD     TIM6_IRQHandler             ; TIM6
        DCD     TIM7_IRQHandler             ; TIM7
        DCD     TIM8_BRK_IRQHandler         ; TIM8 Break
        DCD     TIM8_UP_IRQHandler          ; TIM8 Update
        DCD     TIM8_TRG_COM_IRQHandler     ; TIM8 Trigger and Commutation
        DCD     TIM8_CC_IRQHandler          ; TIM8 Capture Compare
        DCD     I2C1_EV_IRQHandler          ; I2C1 Event
        DCD     I2C1_ER_IRQHandler          ; I2C1 Error
        DCD     I2C2_EV_IRQHandler          ; I2C2 Event
        DCD     I2C2_ER_IRQHandler          ; I2C2 Error
        DCD     SPI1_IRQHandler             ; SPI1
        DCD     SPI2_IRQHandler             ; SPI2
        DCD     USART1_IRQHandler           ; USART1
        DCD     USART2_IRQHandler           ; USART2
        DCD     USART3_IRQHandler           ; USART3
        DCD     UART4_IRQHandler            ; UART4
        DCD     UART5_IRQHandler            ; UART5
        DCD     LPUART1_IRQHandler          ; LP UART1
        DCD     LPTIM1_IRQHandler           ; LP TIM1
        DCD     LPTIM2_IRQHandler           ; LP TIM2
        DCD     TIM15_IRQHandler            ; TIM15
        DCD     TIM16_IRQHandler            ; TIM16
        DCD     TIM17_IRQHandler            ; TIM17
        DCD     COMP_IRQHandler             ; COMP1&2
        DCD     USB_FS_IRQHandler           ; USB FS
        DCD     CRS_IRQHandler              ; CRS
        DCD     FMC_IRQHandler              ; FMC
        DCD     OCTOSPI1_IRQHandler         ; OctoSPI1 global interrupt
        DCD     0                           ; Reserved
        DCD     SDMMC1_IRQHandler           ; SDMMC1
        DCD     0                           ; Reserved
        DCD     DMA2_Channel1_IRQHandler    ; DMA2 Channel 1
        DCD     DMA2_Channel2_IRQHandler    ; DMA2 Channel 2
        DCD     DMA2_Channel3_IRQHandler    ; DMA2 Channel 3
        DCD     DMA2_Channel4_IRQHandler    ; DMA2 Channel 4
        DCD     DMA2_Channel5_IRQHandler    ; DMA2 Channel 5
        DCD     DMA2_Channel6_IRQHandler    ; DMA2 Channel 6
        DCD     DMA2_Channel7_IRQHandler    ; DMA2 Channel 7
        DCD     DMA2_Channel8_IRQHandler    ; DMA2 Channel 8
        DCD     I2C3_EV_IRQHandler          ; I2C3 event
        DCD     I2C3_ER_IRQHandler          ; I2C3 error
        DCD     SAI1_IRQHandler             ; Serial Audio Interface 1 global interrupt
        DCD     SAI2_IRQHandler             ; Serial Audio Interface 2 global interrupt
        DCD     TSC_IRQHandler              ; Touch Sense Controller global interrupt
        DCD     0                           ; Reserved
        DCD     RNG_IRQHandler              ; RNG global interrupt
        DCD     FPU_IRQHandler              ; FPU
        DCD     HASH_IRQHandler             ; HASH
        DCD     0                           ; Reserved
        DCD     LPTIM3_IRQHandler           ; LP TIM3
        DCD     SPI3_IRQHandler             ; SPI3
        DCD     I2C4_ER_IRQHandler          ; I2C4 error
        DCD     I2C4_EV_IRQHandler          ; I2C4 event
        DCD     DFSDM1_FLT0_IRQHandler      ; DFSDM1 Filter 0 global Interrupt
        DCD     DFSDM1_FLT1_IRQHandler      ; DFSDM1 Filter 1 global Interrupt
        DCD     DFSDM1_FLT2_IRQHandler      ; DFSDM1 Filter 2 global Interrupt
        DCD     DFSDM1_FLT3_IRQHandler      ; DFSDM1 Filter 3 global Interrupt
        DCD     UCPD1_IRQHandler            ; UCPD1
        DCD     ICACHE_IRQHandler           ; ICACHE
        DCD     0                           ; Reserved

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
;.............................................................................
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
        PUBWEAK PVD_PVM_IRQHandler
        PUBWEAK RTC_IRQHandler
        PUBWEAK RTC_S_IRQHandler
        PUBWEAK TAMP_IRQHandler
        PUBWEAK TAMP_S_IRQHandler
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
        PUBWEAK DMAMUX1_IRQHandler
        PUBWEAK DMAMUX1_S_IRQHandler
        PUBWEAK DMA1_Channel1_IRQHandler
        PUBWEAK DMA1_Channel2_IRQHandler
        PUBWEAK DMA1_Channel3_IRQHandler
        PUBWEAK DMA1_Channel4_IRQHandler
        PUBWEAK DMA1_Channel5_IRQHandler
        PUBWEAK DMA1_Channel6_IRQHandler
        PUBWEAK DMA1_Channel7_IRQHandler
        PUBWEAK DMA1_Channel8_IRQHandler
        PUBWEAK ADC1_2_IRQHandler
        PUBWEAK DAC_IRQHandler
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
        PUBWEAK TIM8_BRK_IRQHandler
        PUBWEAK TIM8_UP_IRQHandler
        PUBWEAK TIM8_TRG_COM_IRQHandler
        PUBWEAK TIM8_CC_IRQHandler
        PUBWEAK I2C1_EV_IRQHandler
        PUBWEAK I2C1_ER_IRQHandler
        PUBWEAK I2C2_EV_IRQHandler
        PUBWEAK I2C2_ER_IRQHandler
        PUBWEAK SPI1_IRQHandler
        PUBWEAK SPI2_IRQHandler
        PUBWEAK USART1_IRQHandler
        PUBWEAK USART2_IRQHandler
        PUBWEAK USART3_IRQHandler
        PUBWEAK UART4_IRQHandler
        PUBWEAK UART5_IRQHandler
        PUBWEAK LPUART1_IRQHandler
        PUBWEAK LPTIM1_IRQHandler
        PUBWEAK LPTIM2_IRQHandler
        PUBWEAK TIM15_IRQHandler
        PUBWEAK TIM16_IRQHandler
        PUBWEAK TIM17_IRQHandler
        PUBWEAK COMP_IRQHandler
        PUBWEAK USB_FS_IRQHandler
        PUBWEAK CRS_IRQHandler
        PUBWEAK FMC_IRQHandler
        PUBWEAK OCTOSPI1_IRQHandler
        PUBWEAK SDMMC1_IRQHandler
        PUBWEAK DMA2_Channel1_IRQHandler
        PUBWEAK DMA2_Channel2_IRQHandler
        PUBWEAK DMA2_Channel3_IRQHandler
        PUBWEAK DMA2_Channel4_IRQHandler
        PUBWEAK DMA2_Channel5_IRQHandler
        PUBWEAK DMA2_Channel6_IRQHandler
        PUBWEAK DMA2_Channel7_IRQHandler
        PUBWEAK DMA2_Channel8_IRQHandler
        PUBWEAK I2C3_EV_IRQHandler
        PUBWEAK I2C3_ER_IRQHandler
        PUBWEAK SAI1_IRQHandler
        PUBWEAK SAI2_IRQHandler
        PUBWEAK TSC_IRQHandler
        PUBWEAK RNG_IRQHandler
        PUBWEAK FPU_IRQHandler
        PUBWEAK HASH_IRQHandler
        PUBWEAK LPTIM3_IRQHandler
        PUBWEAK SPI3_IRQHandler
        PUBWEAK I2C4_ER_IRQHandler
        PUBWEAK I2C4_EV_IRQHandler
        PUBWEAK DFSDM1_FLT0_IRQHandler
        PUBWEAK DFSDM1_FLT1_IRQHandler
        PUBWEAK DFSDM1_FLT2_IRQHandler
        PUBWEAK DFSDM1_FLT3_IRQHandler
        PUBWEAK UCPD1_IRQHandler
        PUBWEAK ICACHE_IRQHandler


Default_Handler
WWDG_IRQHandler
PVD_PVM_IRQHandler
RTC_IRQHandler
RTC_S_IRQHandler
TAMP_IRQHandler
TAMP_S_IRQHandler
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
DMAMUX1_IRQHandler
DMAMUX1_S_IRQHandler
DMA1_Channel1_IRQHandler
DMA1_Channel2_IRQHandler
DMA1_Channel3_IRQHandler
DMA1_Channel4_IRQHandler
DMA1_Channel5_IRQHandler
DMA1_Channel6_IRQHandler
DMA1_Channel7_IRQHandler
DMA1_Channel8_IRQHandler
ADC1_2_IRQHandler
DAC_IRQHandler
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
TIM8_BRK_IRQHandler
TIM8_UP_IRQHandler
TIM8_TRG_COM_IRQHandler
TIM8_CC_IRQHandler
I2C1_EV_IRQHandler
I2C1_ER_IRQHandler
I2C2_EV_IRQHandler
I2C2_ER_IRQHandler
SPI1_IRQHandler
SPI2_IRQHandler
USART1_IRQHandler
USART2_IRQHandler
USART3_IRQHandler
UART4_IRQHandler
UART5_IRQHandler
LPUART1_IRQHandler
LPTIM1_IRQHandler
LPTIM2_IRQHandler
TIM15_IRQHandler
TIM16_IRQHandler
TIM17_IRQHandler
COMP_IRQHandler
USB_FS_IRQHandler
CRS_IRQHandler
FMC_IRQHandler
OCTOSPI1_IRQHandler
SDMMC1_IRQHandler
DMA2_Channel1_IRQHandler
DMA2_Channel2_IRQHandler
DMA2_Channel3_IRQHandler
DMA2_Channel4_IRQHandler
DMA2_Channel5_IRQHandler
DMA2_Channel6_IRQHandler
DMA2_Channel7_IRQHandler
DMA2_Channel8_IRQHandler
I2C3_EV_IRQHandler
I2C3_ER_IRQHandler
SAI1_IRQHandler
SAI2_IRQHandler
TSC_IRQHandler
RNG_IRQHandler
FPU_IRQHandler
HASH_IRQHandler
LPTIM3_IRQHandler
SPI3_IRQHandler
I2C4_ER_IRQHandler
I2C4_EV_IRQHandler
DFSDM1_FLT0_IRQHandler
DFSDM1_FLT1_IRQHandler
DFSDM1_FLT2_IRQHandler
DFSDM1_FLT3_IRQHandler
UCPD1_IRQHandler
ICACHE_IRQHandler
        CPSID   i                ; disable all interrupts
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

