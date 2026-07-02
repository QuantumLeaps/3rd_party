;*****************************************************************************
; @file     startup_stm32h533retx.s for ARM-KEIL ARM assembler
; @brief    CMSIS Cortex-M33 Core Device Startup File for tm32h533ret
; @date     23 Jun 2026
;
; Modified by Quantum Leaps:
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
        EXPORT  PVD_AVD_IRQHandler          [WEAK]
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
        EXPORT  GPDMA1_Channel0_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel1_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel2_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel3_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel4_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel5_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel6_IRQHandler  [WEAK]
        EXPORT  GPDMA1_Channel7_IRQHandler  [WEAK]
        EXPORT  IWDG_IRQHandler             [WEAK]
        EXPORT  SAES_IRQHandler             [WEAK]
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
        EXPORT  I2C1_EV_IRQHandler          [WEAK]
        EXPORT  I2C1_ER_IRQHandler          [WEAK]
        EXPORT  I2C2_EV_IRQHandler          [WEAK]
        EXPORT  I2C2_ER_IRQHandler          [WEAK]
        EXPORT  SPI1_IRQHandler             [WEAK]
        EXPORT  SPI2_IRQHandler             [WEAK]
        EXPORT  SPI3_IRQHandler             [WEAK]
        EXPORT  USART1_IRQHandler           [WEAK]
        EXPORT  USART2_IRQHandler           [WEAK]
        EXPORT  USART3_IRQHandler           [WEAK]
        EXPORT  UART4_IRQHandler            [WEAK]
        EXPORT  UART5_IRQHandler            [WEAK]
        EXPORT  LPUART1_IRQHandler          [WEAK]
        EXPORT  LPTIM1_IRQHandler           [WEAK]
        EXPORT  TIM8_BRK_IRQHandler         [WEAK]
        EXPORT  TIM8_UP_IRQHandler          [WEAK]
        EXPORT  TIM8_TRG_COM_IRQHandler     [WEAK]
        EXPORT  TIM8_CC_IRQHandler          [WEAK]
        EXPORT  ADC2_IRQHandler             [WEAK]
        EXPORT  LPTIM2_IRQHandler           [WEAK]
        EXPORT  TIM15_IRQHandler            [WEAK]
        EXPORT  USB_DRD_FS_IRQHandler       [WEAK]
        EXPORT  CRS_IRQHandler              [WEAK]
        EXPORT  UCPD1_IRQHandler            [WEAK]
        EXPORT  FMC_IRQHandler              [WEAK]
        EXPORT  OCTOSPI1_IRQHandler         [WEAK]
        EXPORT  SDMMC1_IRQHandler           [WEAK]
        EXPORT  I2C3_EV_IRQHandler          [WEAK]
        EXPORT  I2C3_ER_IRQHandler          [WEAK]
        EXPORT  SPI4_IRQHandler             [WEAK]
        EXPORT  USART6_IRQHandler           [WEAK]
        EXPORT  GPDMA2_Channel0_IRQHandler  [WEAK]
        EXPORT  GPDMA2_Channel1_IRQHandler  [WEAK]
        EXPORT  GPDMA2_Channel2_IRQHandler  [WEAK]
        EXPORT  GPDMA2_Channel3_IRQHandler  [WEAK]
        EXPORT  GPDMA2_Channel4_IRQHandler  [WEAK]
        EXPORT  GPDMA2_Channel5_IRQHandler  [WEAK]
        EXPORT  GPDMA2_Channel6_IRQHandler  [WEAK]
        EXPORT  GPDMA2_Channel7_IRQHandler  [WEAK]
        EXPORT  FPU_IRQHandler              [WEAK]
        EXPORT  ICACHE_IRQHandler           [WEAK]
        EXPORT  DCACHE1_IRQHandler          [WEAK]
        EXPORT  DCMI_PSSI_IRQHandler        [WEAK]
        EXPORT  FDCAN2_IT0_IRQHandler       [WEAK]
        EXPORT  FDCAN2_IT1_IRQHandler       [WEAK]
        EXPORT  DTS_IRQHandler              [WEAK]
        EXPORT  RNG_IRQHandler              [WEAK]
        EXPORT  OTFDEC1_IRQHandler          [WEAK]
        EXPORT  AES_IRQHandler              [WEAK]
        EXPORT  HASH_IRQHandler             [WEAK]
        EXPORT  PKA_IRQHandler              [WEAK]
        EXPORT  CEC_IRQHandler              [WEAK]
        EXPORT  TIM12_IRQHandler            [WEAK]
        EXPORT  I3C1_EV_IRQHandler          [WEAK]
        EXPORT  I3C1_ER_IRQHandler          [WEAK]
        EXPORT  I3C2_EV_IRQHandler          [WEAK]
        EXPORT  I3C2_ER_IRQHandler          [WEAK]
        EXPORT  Reserved72_Handler          [WEAK]
        EXPORT  Reserved73_Handler          [WEAK]
        EXPORT  Reserved83_Handler          [WEAK]
        EXPORT  Reserved84_Handler          [WEAK]
        EXPORT  Reserved86_Handler          [WEAK]
        EXPORT  Reserved87_Handler          [WEAK]
        EXPORT  Reserved88_Handler          [WEAK]
        EXPORT  Reserved89_Handler          [WEAK]
        EXPORT  Reserved98_Handler          [WEAK]
        EXPORT  Reserved99_Handler          [WEAK]
        EXPORT  Reserved100_Handler         [WEAK]
        EXPORT  Reserved101_Handler         [WEAK]
        EXPORT  Reserved102_Handler         [WEAK]
        EXPORT  Reserved106_Handler         [WEAK]
        EXPORT  Reserved107_Handler         [WEAK]
        EXPORT  Reserved111_Handler         [WEAK]
        EXPORT  Reserved112_Handler         [WEAK]
        EXPORT  Reserved121_Handler         [WEAK]
        EXPORT  Reserved122_Handler         [WEAK]
        EXPORT  Reserved125_Handler         [WEAK]
        EXPORT  Reserved126_Handler         [WEAK]
        EXPORT  Reserved127_Handler         [WEAK]
        EXPORT  Reserved128_Handler         [WEAK]
        EXPORT  Reserved129_Handler         [WEAK]
        EXPORT  Reserved130_Handler         [WEAK]


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
