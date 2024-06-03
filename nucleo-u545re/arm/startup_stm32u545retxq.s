;*****************************************************************************
; @file     startup_stm32u545retxq.s for ARM-KEIL ARM assembler
; @brief    CMSIS Cortex-M4F Core Device Startup File for stm32u545retx6
; @date     23 Jun 2024
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
;
; @note
; The symbols Stack_Size and Heap_Size should be provided on the command-
; line options to the assembler, for example as:
;     --pd "Stack_Size SETA 1024" --pd "Heap_Size SETA 0"


;******************************************************************************
; Allocate space for the stack.
;
        AREA    STACK, NOINIT, READWRITE, ALIGN=3
__stack_base
StackMem
        SPACE   Stack_Size    ; provided in command-line option, for example:
                              ; --pd "Stack_Size SETA 512"
__stack_limit
__initial_sp

;******************************************************************************
; Allocate space for the heap.
;
        AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
HeapMem
        SPACE   Heap_Size     ; provided in command-line option, for example:
                              ; --pd "Heap_Size SETA 0"
__heap_limit

; Indicate that the code in this file preserves 8-byte alignment of the stack.
        PRESERVE8

;******************************************************************************
; The vector table.
;
; Place code into the reset code section.
        AREA   RESET, DATA, READONLY, ALIGN=8
        EXPORT  __Vectors
        EXPORT  __Vectors_End
        EXPORT  __Vectors_Size

__Vectors
        DCD     __initial_sp                ; Top of Stack
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
        DCD     PVD_PVM_IRQHandler          ; [  1]
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
        DCD     IWDG_IRQHandler             ; [ 27]
        DCD     SAES_IRQHandler             ; [ 28]
        DCD     GPDMA1_Channel0_IRQHandler  ; [ 29]
        DCD     GPDMA1_Channel1_IRQHandler  ; [ 30]
        DCD     GPDMA1_Channel2_IRQHandler  ; [ 31]
        DCD     GPDMA1_Channel3_IRQHandler  ; [ 32]
        DCD     GPDMA1_Channel4_IRQHandler  ; [ 33]
        DCD     GPDMA1_Channel5_IRQHandler  ; [ 34]
        DCD     GPDMA1_Channel6_IRQHandler  ; [ 35]
        DCD     GPDMA1_Channel7_IRQHandler  ; [ 36]
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
        DCD     TIM8_BRK_IRQHandler         ; [ 51]
        DCD     TIM8_UP_IRQHandler          ; [ 52]
        DCD     TIM8_TRG_COM_IRQHandler     ; [ 53]
        DCD     TIM8_CC_IRQHandler          ; [ 54]
        DCD     I2C1_EV_IRQHandler          ; [ 55]
        DCD     I2C1_ER_IRQHandler          ; [ 56]
        DCD     I2C2_EV_IRQHandler          ; [ 57]
        DCD     I2C2_ER_IRQHandler          ; [ 58]
        DCD     SPI1_IRQHandler             ; [ 59]
        DCD     SPI2_IRQHandler             ; [ 60]
        DCD     USART1_IRQHandler           ; [ 61]
        DCD     Reserved62_Handler          ; [ 62]
        DCD     USART3_IRQHandler           ; [ 63]
        DCD     UART4_IRQHandler            ; [ 64]
        DCD     UART5_IRQHandler            ; [ 65]
        DCD     LPUART1_IRQHandler          ; [ 66]
        DCD     LPTIM1_IRQHandler           ; [ 67]
        DCD     LPTIM2_IRQHandler           ; [ 68]
        DCD     TIM15_IRQHandler            ; [ 69]
        DCD     TIM16_IRQHandler            ; [ 70]
        DCD     TIM17_IRQHandler            ; [ 71]
        DCD     COMP_IRQHandler             ; [ 72]
        DCD     USB_IRQHandler              ; [ 73]
        DCD     CRS_IRQHandler              ; [ 74]
        DCD     Reserved75_Handler          ; [ 75]
        DCD     OCTOSPI1_IRQHandler         ; [ 76]
        DCD     PWR_S3WU_IRQHandler         ; [ 77]
        DCD     SDMMC1_IRQHandler           ; [ 78]
        DCD     Reserved79_Handler          ; [ 79]
        DCD     GPDMA1_Channel8_IRQHandler  ; [ 80]
        DCD     GPDMA1_Channel9_IRQHandler  ; [ 81]
        DCD     GPDMA1_Channel10_IRQHandler ; [ 82]
        DCD     GPDMA1_Channel11_IRQHandler ; [ 83]
        DCD     GPDMA1_Channel12_IRQHandler ; [ 84]
        DCD     GPDMA1_Channel13_IRQHandler ; [ 85]
        DCD     GPDMA1_Channel14_IRQHandler ; [ 86]
        DCD     GPDMA1_Channel15_IRQHandler ; [ 87]
        DCD     I2C3_EV_IRQHandler          ; [ 88]
        DCD     I2C3_ER_IRQHandler          ; [ 89]
        DCD     SAI1_IRQHandler             ; [ 90]
        DCD     Reserved91_Handler          ; [ 91]
        DCD     TSC_IRQHandler              ; [ 92]
        DCD     AES_IRQHandler              ; [ 93]
        DCD     RNG_IRQHandler              ; [ 94]
        DCD     FPU_IRQHandler              ; [ 95]
        DCD     HASH_IRQHandler             ; [ 96]
        DCD     PKA_IRQHandler              ; [ 97]
        DCD     LPTIM3_IRQHandler           ; [ 98]
        DCD     SPI3_IRQHandler             ; [ 99]
        DCD     I2C4_ER_IRQHandler          ; [100]
        DCD     I2C4_EV_IRQHandler          ; [101]
        DCD     MDF1_FLT0_IRQHandler        ; [102]
        DCD     MDF1_FLT1_IRQHandler        ; [103]
        DCD     Reserved104_Handler         ; [104]
        DCD     Reserved105_Handler         ; [105]
        DCD     Reserved106_Handler         ; [106]
        DCD     ICACHE_IRQHandler           ; [107]
        DCD     OTFDEC1_IRQHandler          ; [108]
        DCD     Reserved109_Handler         ; [109]
        DCD     LPTIM4_IRQHandler           ; [110]
        DCD     DCACHE1_IRQHandler          ; [111]
        DCD     ADF1_IRQHandler             ; [112]
        DCD     ADC4_IRQHandler             ; [113]
        DCD     LPDMA1_Channel0_IRQHandler  ; [114]
        DCD     LPDMA1_Channel1_IRQHandler  ; [115]
        DCD     LPDMA1_Channel2_IRQHandler  ; [116]
        DCD     LPDMA1_Channel3_IRQHandler  ; [117]
        DCD     Reserved118_Handler         ; [118]
        DCD     DCMI_PSSI_IRQHandler        ; [119]
        DCD     Reserved120_Handler         ; [120]
        DCD     Reserved121_Handler         ; [121]
        DCD     Reserved122_Handler         ; [122]
        DCD     CORDIC_IRQHandler           ; [113]
        DCD     FMAC_IRQHandler             ; [114]
        DCD     LSECSSD_IRQHandler          ; [115]

__Vectors_End

__Vectors_Size  EQU   __Vectors_End - __Vectors


;******************************************************************************
; This is the code for exception handlers.
;
        AREA    |.text|, CODE, READONLY

;******************************************************************************
; This is the code that gets called when the processor first starts execution
; following a reset event.
;
Reset_Handler   PROC
        EXPORT  Reset_Handler   [WEAK]
        IMPORT  SystemInit
        IMPORT  __main
        IMPORT  assert_failed

        LDR     r0,=SystemInit  ; CMSIS system initialization
        BLX     r0

        ; Call the C library entry point that handles startup. This will copy
        ; the .data section initializers from flash to SRAM and zero fill the
        ; .bss section.
        ; NOTE: The __main function clears the C stack as well
        LDR     r0,=__main
        BX      r0

        ; __main calls the main() function, which should not return,
        ; but just in case jump to assert_failed() if main returns.
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_EXIT
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_EXIT
        DCB     "EXIT"
        ALIGN
        ENDP

;******************************************************************************
NMI_Handler     PROC
        EXPORT  NMI_Handler     [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_NMI
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_NMI
        DCB     "NMI"
        ALIGN
        ENDP

;******************************************************************************
HardFault_Handler PROC
        EXPORT  HardFault_Handler [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_HardFault
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_HardFault
        DCB     "HardFault"
        ALIGN
        ENDP

;******************************************************************************
MemManage_Handler PROC
        EXPORT  MemManage_Handler [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_MemManage
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_MemManage
        DCB     "MemManage"
        ALIGN
        ENDP

;******************************************************************************
BusFault_Handler PROC
        EXPORT  BusFault_Handler  [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_BusFault
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_BusFault
        DCB     "BusFault"
        ALIGN
        ENDP

;******************************************************************************
UsageFault_Handler PROC
        EXPORT  UsageFault_Handler [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_UsageFault
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_UsageFault
        DCB     "UsageFault"
        ALIGN
        ENDP

;******************************************************************************
SecureFault_Handler PROC
        EXPORT  SecureFault_Handler [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_UsageFault
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_SecureFault
        DCB     "SecureFault"
        ALIGN
        ENDP


;******************************************************************************
;
; Weak non-fault handlers...
;

;******************************************************************************
SVC_Handler PROC
        EXPORT  SVC_Handler       [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_SVC
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_SVC
        DCB     "SVC"
        ALIGN
        ENDP

;******************************************************************************
DebugMon_Handler PROC
        EXPORT  DebugMon_Handler  [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_DebugMon
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_DebugMon
        DCB     "DebugMon"
        ALIGN
        ENDP

;******************************************************************************
PendSV_Handler PROC
        EXPORT  PendSV_Handler    [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_PendSV
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_PendSV
        DCB     "PendSV"
        ALIGN
        ENDP

;******************************************************************************
SysTick_Handler PROC
        EXPORT  SysTick_Handler   [WEAK]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_SysTick
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_SysTick
        DCB     "SysTick"
        ALIGN
        ENDP

;******************************************************************************
Default_Handler PROC
        EXPORT  WWDG_IRQHandler             [WEAK]
        EXPORT  PVD_PVM_IRQHandler          [WEAK]
        EXPORT  RTC_IRQHandler              [WEAK]
        EXPORT  RTC_S_IRQHandler            [WEAK]
        EXPORT  TAMP_IRQHandler             [WEAK]
        EXPORT  RAMCFG_IRQHandler           [WEAK]
        EXPORT  FLASH_IRQHandler            [WEAK]
        EXPORT  FLASH_S_IRQHandler          [WEAK]
        EXPORT  GTZC_IRQHandler             [WEAK]
        EXPORT  RCC_IRQHandler              [WEAK]
        EXPORT  RCC_S_IRQHandler            [WEAK]
        EXPORT  EXTI0_IRQHandler            [WEAK]
        EXPORT  EXTI1_IRQHandler            [WEAK]
        EXPORT  EXTI2_IRQHandler            [WEAK]
        EXPORT  EXTI3_IRQHandler            [WEAK]
        EXPORT  EXTI4_IRQHandler            [WEAK]
        EXPORT  EXTI5_IRQHandler            [WEAK]
        EXPORT  EXTI6_IRQHandler            [WEAK]
        EXPORT  EXTI7_IRQHandler            [WEAK]
        EXPORT  EXTI8_IRQHandler            [WEAK]
        EXPORT  EXTI9_IRQHandler            [WEAK]
        EXPORT  EXTI10_IRQHandler           [WEAK]
        EXPORT  EXTI11_IRQHandler           [WEAK]
        EXPORT  EXTI12_IRQHandler           [WEAK]
        EXPORT  EXTI13_IRQHandler           [WEAK]
        EXPORT  EXTI14_IRQHandler           [WEAK]
        EXPORT  EXTI15_IRQHandler           [WEAK]
        EXPORT  IWDG_IRQHandler             [WEAK]
        EXPORT  SAES_IRQHandler             [WEAK]
        EXPORT  GPDMA1_Channel0_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel1_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel2_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel3_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel4_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel5_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel6_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel7_IRQHandler  [WEAK]
        EXPORT  ADC1_IRQHandler             [WEAK]
        EXPORT  DAC1_IRQHandler             [WEAK]
        EXPORT  FDCAN1_IT0_IRQHandler       [WEAK]
        EXPORT  FDCAN1_IT1_IRQHandler       [WEAK]
        EXPORT  TIM1_BRK_IRQHandler         [WEAK]
        EXPORT  TIM1_UP_IRQHandler          [WEAK]
        EXPORT  TIM1_TRG_COM_IRQHandler     [WEAK]
        EXPORT  TIM1_CC_IRQHandler          [WEAK]
        EXPORT  TIM2_IRQHandler             [WEAK]
        EXPORT  TIM3_IRQHandler             [WEAK]
        EXPORT  TIM4_IRQHandler             [WEAK]
        EXPORT  TIM5_IRQHandler             [WEAK]
        EXPORT  TIM6_IRQHandler             [WEAK]
        EXPORT  TIM7_IRQHandler             [WEAK]
        EXPORT  TIM8_BRK_IRQHandler         [WEAK]
        EXPORT  TIM8_UP_IRQHandler          [WEAK]
        EXPORT  TIM8_TRG_COM_IRQHandler     [WEAK]
        EXPORT  TIM8_CC_IRQHandler          [WEAK]
        EXPORT  I2C1_EV_IRQHandler          [WEAK]
        EXPORT  I2C1_ER_IRQHandler          [WEAK]
        EXPORT  I2C2_EV_IRQHandler          [WEAK]
        EXPORT  I2C2_ER_IRQHandler          [WEAK]
        EXPORT  SPI1_IRQHandler             [WEAK]
        EXPORT  SPI2_IRQHandler             [WEAK]
        EXPORT  USART1_IRQHandler           [WEAK]
        EXPORT  USART3_IRQHandler           [WEAK]
        EXPORT  UART4_IRQHandler            [WEAK]
        EXPORT  UART5_IRQHandler            [WEAK]
        EXPORT  LPUART1_IRQHandler          [WEAK]
        EXPORT  LPTIM1_IRQHandler           [WEAK]
        EXPORT  LPTIM2_IRQHandler           [WEAK]
        EXPORT  TIM15_IRQHandler            [WEAK]
        EXPORT  TIM16_IRQHandler            [WEAK]
        EXPORT  TIM17_IRQHandler            [WEAK]
        EXPORT  COMP_IRQHandler             [WEAK]
        EXPORT  USB_IRQHandler              [WEAK]
        EXPORT  CRS_IRQHandler              [WEAK]
        EXPORT  OCTOSPI1_IRQHandler         [WEAK]
        EXPORT  PWR_S3WU_IRQHandler         [WEAK]
        EXPORT  SDMMC1_IRQHandler           [WEAK]
        EXPORT  GPDMA1_Channel8_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel9_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel10_IRQHandler [WEAK]
        EXPORT  GPDMA1_Channel11_IRQHandler [WEAK]
        EXPORT  GPDMA1_Channel12_IRQHandler [WEAK]
        EXPORT  GPDMA1_Channel13_IRQHandler [WEAK]
        EXPORT  GPDMA1_Channel14_IRQHandler [WEAK]
        EXPORT  GPDMA1_Channel15_IRQHandler [WEAK]
        EXPORT  I2C3_EV_IRQHandler          [WEAK]
        EXPORT  I2C3_ER_IRQHandler          [WEAK]
        EXPORT  SAI1_IRQHandler             [WEAK]
        EXPORT  TSC_IRQHandler              [WEAK]
        EXPORT  AES_IRQHandler              [WEAK]
        EXPORT  RNG_IRQHandler              [WEAK]
        EXPORT  FPU_IRQHandler              [WEAK]
        EXPORT  HASH_IRQHandler             [WEAK]
        EXPORT  PKA_IRQHandler              [WEAK]
        EXPORT  LPTIM3_IRQHandler           [WEAK]
        EXPORT  SPI3_IRQHandler             [WEAK]
        EXPORT  I2C4_ER_IRQHandler          [WEAK]
        EXPORT  I2C4_EV_IRQHandler          [WEAK]
        EXPORT  MDF1_FLT0_IRQHandler        [WEAK]
        EXPORT  MDF1_FLT1_IRQHandler        [WEAK]
        EXPORT  ICACHE_IRQHandler           [WEAK]
        EXPORT  OTFDEC1_IRQHandler          [WEAK]
        EXPORT  LPTIM4_IRQHandler           [WEAK]
        EXPORT  DCACHE1_IRQHandler          [WEAK]
        EXPORT  ADF1_IRQHandler             [WEAK]
        EXPORT  ADC4_IRQHandler             [WEAK]
        EXPORT  LPDMA1_Channel0_IRQHandler  [WEAK]
        EXPORT  LPDMA1_Channel1_IRQHandler  [WEAK]
        EXPORT  LPDMA1_Channel2_IRQHandler  [WEAK]
        EXPORT  LPDMA1_Channel3_IRQHandler  [WEAK]
        EXPORT  DCMI_PSSI_IRQHandler        [WEAK]
        EXPORT  CORDIC_IRQHandler           [WEAK]
        EXPORT  FMAC_IRQHandler             [WEAK]
        EXPORT  LSECSSD_IRQHandler          [WEAK]
        EXPORT  Reserved62_Handler          [WEAK]
        EXPORT  Reserved75_Handler          [WEAK]
        EXPORT  Reserved79_Handler          [WEAK]
        EXPORT  Reserved91_Handler          [WEAK]
        EXPORT  Reserved104_Handler         [WEAK]
        EXPORT  Reserved105_Handler         [WEAK]
        EXPORT  Reserved106_Handler         [WEAK]
        EXPORT  Reserved109_Handler         [WEAK]
        EXPORT  Reserved118_Handler         [WEAK]
        EXPORT  Reserved120_Handler         [WEAK]
        EXPORT  Reserved121_Handler         [WEAK]
        EXPORT  Reserved122_Handler         [WEAK]


WWDG_IRQHandler
PVD_PVM_IRQHandler
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
IWDG_IRQHandler
SAES_IRQHandler
GPDMA1_Channel0_IRQHandler
GPDMA1_Channel1_IRQHandler
GPDMA1_Channel2_IRQHandler
GPDMA1_Channel3_IRQHandler
GPDMA1_Channel4_IRQHandler
GPDMA1_Channel5_IRQHandler
GPDMA1_Channel6_IRQHandler
GPDMA1_Channel7_IRQHandler
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
USB_IRQHandler
CRS_IRQHandler
OCTOSPI1_IRQHandler
PWR_S3WU_IRQHandler
SDMMC1_IRQHandler
GPDMA1_Channel8_IRQHandler
GPDMA1_Channel9_IRQHandler
GPDMA1_Channel10_IRQHandler
GPDMA1_Channel11_IRQHandler
GPDMA1_Channel12_IRQHandler
GPDMA1_Channel13_IRQHandler
GPDMA1_Channel14_IRQHandler
GPDMA1_Channel15_IRQHandler
I2C3_EV_IRQHandler
I2C3_ER_IRQHandler
SAI1_IRQHandler
TSC_IRQHandler
AES_IRQHandler
RNG_IRQHandler
FPU_IRQHandler
HASH_IRQHandler
PKA_IRQHandler
LPTIM3_IRQHandler
SPI3_IRQHandler
I2C4_ER_IRQHandler
I2C4_EV_IRQHandler
MDF1_FLT0_IRQHandler
MDF1_FLT1_IRQHandler
ICACHE_IRQHandler
OTFDEC1_IRQHandler
LPTIM4_IRQHandler
DCACHE1_IRQHandler
ADF1_IRQHandler
ADC4_IRQHandler
LPDMA1_Channel0_IRQHandler
LPDMA1_Channel1_IRQHandler
LPDMA1_Channel2_IRQHandler
LPDMA1_Channel3_IRQHandler
DCMI_PSSI_IRQHandler
CORDIC_IRQHandler
FMAC_IRQHandler
LSECSSD_IRQHandler
Reserved62_Handler            ; [ 62]
Reserved75_Handler            ; [ 75]
Reserved79_Handler            ; [ 79]
Reserved91_Handler            ; [ 91]
Reserved104_Handler           ; [104]
Reserved105_Handler           ; [105]
Reserved106_Handler           ; [106]
Reserved109_Handler           ; [109]
Reserved118_Handler           ; [118]
Reserved120_Handler           ; [120]
Reserved121_Handler           ; [121]
Reserved122_Handler           ; [122]
        CPSID   i                 ; disable all interrupts
        LDR     r0,=str_Undefined
        MOVS    r1,#1
        LDR     r2,=__initial_sp  ; re-set the SP in case of stack overflow
        MOV     sp,r2
        LDR     r2,=assert_failed
        BX      r2
str_Undefined
        DCB     "Undefined"
        ALIGN
        ENDP

        ALIGN               ; make sure the end of this section is aligned

;******************************************************************************
; The function expected of the C library startup code for defining the stack
; and heap memory locations.  For the C library version of the startup code,
; provide this function so that the C library initialization code can find out
; the location of the stack and heap.
;
    IF :DEF: __MICROLIB
        EXPORT  __initial_sp
        EXPORT  __stack_limit
        EXPORT  __heap_base
        EXPORT  __heap_limit
    ELSE
        IMPORT  __use_two_region_memory
        EXPORT  __user_initial_stackheap

__user_initial_stackheap PROC
        LDR     R0, =__heap_base
        LDR     R1, =__stack_limit
        LDR     R2, =__heap_limit
        LDR     R3, =__stack_base
        BX      LR
        ENDP
    ENDIF
        ALIGN               ; make sure the end of this section is aligned

    END                     ; end of module

