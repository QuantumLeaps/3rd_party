;*****************************************************************************
; Modified from the original as follows:
; - removed Stack_Size and Heap_Size EQUs, so that they need to be provided
;   externally in command-line options to the assembler without messing up
;   with this file
; - replaced endless loops in exception handlers (denial of service) with
;   branches to assert_failed
; - provided definitions of assert_failed and Q_onAssert
;
;
; Quantum Leaps, LLC; www.state-machine.com
; 2015-08-27
;******************** (C) COPYRIGHT 2014 STMicroelectronics ********************
;* File Name          : startup_stm32l053xx.s
;* Author             : MCD Application Team
;* Version            : V1.0.0RC1
;* Date               : 15-April-2014
;* Description        : STM32l053xx Devices vector table for MDK-ARM toolchain.
;*                      This module performs:
;*                      - Set the initial SP
;*                      - Set the initial PC == Reset_Handler
;*                      - Set the vector table entries with the exceptions ISR address
;*                      - Branches to __main in the C library (which eventually
;*                        calls main()).
;*                      After Reset the Cortex-M0+ processor is in Thread mode,
;*                      priority is Privileged, and the Stack is set to Main.
;* <<< Use Configuration Wizard in Context Menu >>>
;*******************************************************************************
;*
;* Redistribution and use in source and binary forms, with or without modification,
;* are permitted provided that the following conditions are met:
;*   1. Redistributions of source code must retain the above copyright notice,
;*      this list of conditions and the following disclaimer.
;*   2. Redistributions in binary form must reproduce the above copyright notice,
;*      this list of conditions and the following disclaimer in the documentation
;*      and/or other materials provided with the distribution.
;*   3. Neither the name of STMicroelectronics nor the names of its contributors
;*      may be used to endorse or promote products derived from this software
;*      without specific prior written permission.
;*
;* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
;* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
;* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;*
;*******************************************************************************
;
; Amount of memory (in bytes) allocated for Stack
; Tailor this value to your application needs
; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

; QL: commeted out Stack_Size      EQU     0x00000400

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

; QL: commeted out Heap_Size       EQU     0x00000200

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit

                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset
                AREA    RESET, DATA, READONLY, ALIGN=8
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors
        DCD     __initial_sp                ; Top of Stack
        DCD     Reset_Handler               ; Reset Handler
        DCD     NMI_Handler                 ; NMI Handler
        DCD     HardFault_Handler           ; Hard Fault Handler
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     SVC_Handler                 ; SVCall handler
        DCD     DebugMon_Handler            ; Debug Monitor handler
        DCD     Default_Handler             ; Reserved
        DCD     PendSV_Handler              ; PendSV handler
        DCD     SysTick_Handler             ; SysTick handler

        ; IRQ handlers...
        DCD     WWDG_IRQHandler                ; Window Watchdog
        DCD     PVD_IRQHandler                 ; PVD through EXTI Line detect
        DCD     RTC_IRQHandler                 ; RTC through EXTI Line
        DCD     FLASH_IRQHandler               ; FLASH
        DCD     RCC_CRS_IRQHandler             ; RCC and CRS
        DCD     EXTI0_1_IRQHandler             ; EXTI Line 0 and 1
        DCD     EXTI2_3_IRQHandler             ; EXTI Line 2 and 3
        DCD     EXTI4_15_IRQHandler            ; EXTI Line 4 to 15
        DCD     TSC_IRQHandler                 ; TSC
        DCD     DMA1_Channel1_IRQHandler       ; DMA1 Channel 1
        DCD     DMA1_Channel2_3_IRQHandler     ; DMA1 Channel 2 and Channel 3
        DCD     DMA1_Channel4_5_6_7_IRQHandler ; DMA1 Channel 4, 5, 6 and 7
        DCD     ADC1_COMP_IRQHandler           ; ADC1, COMP1 and COMP2
        DCD     LPTIM1_IRQHandler              ; LPTIM1
        DCD     Default_Handler                ; Reserved
        DCD     TIM2_IRQHandler                ; TIM2
        DCD     Default_Handler                ; Reserved
        DCD     TIM6_DAC_IRQHandler            ; TIM6 and DAC
        DCD     Default_Handler                ; Reserved
        DCD     Default_Handler                ; Reserved
        DCD     TIM21_IRQHandler               ; TIM21
        DCD     Default_Handler                ; Reserved
        DCD     TIM22_IRQHandler               ; TIM22
        DCD     I2C1_IRQHandler                ; I2C1
        DCD     I2C2_IRQHandler                ; I2C2
        DCD     SPI1_IRQHandler                ; SPI1
        DCD     SPI2_IRQHandler                ; SPI2
        DCD     USART1_IRQHandler              ; USART1
        DCD     USART2_IRQHandler              ; USART2
        DCD     RNG_LPUART1_IRQHandler         ; RNG and LPUART1
        DCD     LCD_IRQHandler                 ; LCD
        DCD     USB_IRQHandler                 ; USB

        ; Extend the end of the Vector Table to the 2^8 boundary to ensure
        ; that no other data or code will be placed up to address 0x100.
        ; This might be necessary for NULL-pointer protection by the MPU,
        ; where a protected region of 2^8 bytes spans over the Vector Table.
        ALIGN  8

__Vectors_End

__Vectors_Size  EQU     __Vectors_End - __Vectors


;******************************************************************************
;
; Weak fault handlers...
;
                AREA    |.text|, CODE, READONLY

;.............................................................................
Reset_Handler    PROC
        EXPORT  Reset_Handler                 [WEAK]
        IMPORT  __main
        IMPORT  SystemInit
        LDR     R0, =SystemInit
        BLX     R0
        LDR     R0, =__main
        BX      R0
        ENDP
;.............................................................................
NMI_Handler     PROC
        EXPORT  NMI_Handler     [WEAK]
        MOVS    r0,#0
        MOVS    r1,#2       ; NMI exception number
        B       assert_failed
        ENDP
;.............................................................................
HardFault_Handler PROC
        EXPORT  HardFault_Handler [WEAK]
        MOVS    r0,#0
        MOVS    r1,#3       ; HardFault exception number
        B       assert_failed
        ENDP


;******************************************************************************
;
; Weak non-fault handlers...
;
;******************************************************************************
SVC_Handler PROC
        EXPORT  SVC_Handler   [WEAK]
        MOVS    r0,#0
        MOVS    r1,#11      ; SVCall exception number
        B       assert_failed
        ENDP
;.............................................................................
DebugMon_Handler PROC
        EXPORT  DebugMon_Handler     [WEAK]
        MOVS    r0,#0
        MOVS    r1,#12      ; DebugMon exception number
        B       assert_failed
        ENDP
;.............................................................................
PendSV_Handler PROC
        EXPORT  PendSV_Handler       [WEAK]
        MOVS    r0,#0
        MOVS    r1,#14      ; PendSV exception number
        B       assert_failed
        ENDP
;.............................................................................
SysTick_Handler PROC
        EXPORT  SysTick_Handler     [WEAK]
        MOVS    r0,#0
        MOVS    r1,#15      ; SysTick exception number
        B       assert_failed
        ENDP

;******************************************************************************
;
; Define Default_Handledr as dummy for all IRQ handlers
;
;******************************************************************************
Default_Handler PROC
        EXPORT  WWDG_IRQHandler                [WEAK]
        EXPORT  PVD_IRQHandler                 [WEAK]
        EXPORT  RTC_IRQHandler                 [WEAK]
        EXPORT  FLASH_IRQHandler               [WEAK]
        EXPORT  RCC_CRS_IRQHandler             [WEAK]
        EXPORT  EXTI0_1_IRQHandler             [WEAK]
        EXPORT  EXTI2_3_IRQHandler             [WEAK]
        EXPORT  EXTI4_15_IRQHandler            [WEAK]
        EXPORT  TSC_IRQHandler                 [WEAK]
        EXPORT  DMA1_Channel1_IRQHandler       [WEAK]
        EXPORT  DMA1_Channel2_3_IRQHandler     [WEAK]
        EXPORT  DMA1_Channel4_5_6_7_IRQHandler [WEAK]
        EXPORT  ADC1_COMP_IRQHandler           [WEAK]
        EXPORT  LPTIM1_IRQHandler              [WEAK]
        EXPORT  TIM2_IRQHandler                [WEAK]
        EXPORT  TIM6_DAC_IRQHandler            [WEAK]
        EXPORT  TIM21_IRQHandler               [WEAK]
        EXPORT  TIM22_IRQHandler               [WEAK]
        EXPORT  I2C1_IRQHandler                [WEAK]
        EXPORT  I2C2_IRQHandler                [WEAK]
        EXPORT  SPI1_IRQHandler                [WEAK]
        EXPORT  SPI2_IRQHandler                [WEAK]
        EXPORT  USART1_IRQHandler              [WEAK]
        EXPORT  USART2_IRQHandler              [WEAK]
        EXPORT  RNG_LPUART1_IRQHandler         [WEAK]
        EXPORT  LCD_IRQHandler                 [WEAK]
        EXPORT  USB_IRQHandler                 [WEAK]

WWDG_IRQHandler
PVD_IRQHandler
RTC_IRQHandler
FLASH_IRQHandler
RCC_CRS_IRQHandler
EXTI0_1_IRQHandler
EXTI2_3_IRQHandler
EXTI4_15_IRQHandler
TSC_IRQHandler
DMA1_Channel1_IRQHandler
DMA1_Channel2_3_IRQHandler
DMA1_Channel4_5_6_7_IRQHandler
ADC1_COMP_IRQHandler
LPTIM1_IRQHandler
TIM2_IRQHandler
TIM6_DAC_IRQHandler
TIM21_IRQHandler
TIM22_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI1_IRQHandler
SPI2_IRQHandler
USART1_IRQHandler
USART2_IRQHandler
RNG_LPUART1_IRQHandler
LCD_IRQHandler
USB_IRQHandler
        MOVS    r0,#0
        MOVS    r1,#0xFF
        B       assert_failed
        ENDP

        ALIGN

;*******************************************************************************
; User Stack and Heap initialization
;*******************************************************************************
    IF :DEF:__MICROLIB

        EXPORT  __initial_sp
        EXPORT  __heap_base
        EXPORT  __heap_limit

    ELSE

        IMPORT  __use_two_region_memory
        EXPORT  __user_initial_stackheap

__user_initial_stackheap

        LDR     R0, =Heap_Mem
        LDR     R1, =(Stack_Mem + Stack_Size)
        LDR     R2, =(Heap_Mem +  Heap_Size)
        LDR     R3, =Stack_Mem
        BX      LR

        ALIGN

    ENDIF


;******************************************************************************
; The function assert_failed defines the error/assertion handling policy
; for the application. After making sure that the stack is OK, this function
; calls Q_onAssert, which should NOT return (typically reset the CPU).
;
; NOTE: the function Q_onAssert should NOT return.
;
; The C proptotype of the assert_failed() and Q_onAssert() functions are:
; void assert_failed(char const *file, int line);
; void Q_onAssert   (char const *file, int line);
;******************************************************************************
        EXPORT  assert_failed
        IMPORT  Q_onAssert
assert_failed PROC
        LDR     r2,=__initial_sp ; load the original top of stack
        MOV     sp,r2            ; re-set the SP in case of stack overflow
        BL     Q_onAssert        ; call the application-specific handler

        B       .                ; should never be reached

        ENDP

        ALIGN                    ; make sure the end of this section is aligned

        END                      ; end of module
