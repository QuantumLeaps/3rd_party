;/***************************************************************************/
; * @file     startup_efm32pg1b.s for IAR ARM assembler
; * @brief    CMSIS Cortex-M4F Core Device Startup File for TM4C123GH6PM
; * @version  CMSIS 5.5.1
; * @date     13 May 2019
; *
; * Modified by Quantum Leaps:
; * Added relocating of the Vector Table to free up the 256B region at 0x0
; * for NULL-pointer protection by the MPU.
; *
; * @description
; * Created from the CMSIS template for the specified device
; * Quantum Leaps, www.state-machine.com
; *
; * @note
; * The function assert_failed defined at the end of this file defines
; * the error/assertion handling policy for the application and might
; * need to be customized for each project. This function is defined in
; * assembly to re-set the stack pointer, in case it is corrupted by the
; * time assert_failed is called.
; *
; ***************************************************************************/
;/* Copyright (c) 2012 ARM LIMITED
;
;  All rights reserved.
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions are met:
;  - Redistributions of source code must retain the above copyright
;    notice, this list of conditions and the following disclaimer.
;  - Redistributions in binary form must reproduce the above copyright
;    notice, this list of conditions and the following disclaimer in the
;    documentation and/or other materials provided with the distribution.
;  - Neither the name of ARM nor the names of its contributors may be used
;    to endorse or promote products derived from this software without
;    specific prior written permission.
;
;  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;  ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
;  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;  POSSIBILITY OF SUCH DAMAGE.
;---------------------------------------------------------------------------*/

        MODULE  ?cstartup

        ;; Forward declaration of sections.
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
    ; Initial Vector Table before relocation
        DCD     sfe(CSTACK)
        DCD     Reset_Handler               ; Reset Handler
        DCD     NMI_Handler                 ; NMI Handler
        DCD     HardFault_Handler           ; Hard Fault Handler
        DCD     MemManage_Handler           ; The MPU fault handler
        DCD     BusFault_Handler            ; The bus fault handler
        DCD     UsageFault_Handler          ; The usage fault handler
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     SVC_Handler                 ; SVCall handler
        DCD     DebugMon_Handler            ; Debug monitor handler
        DCD     Default_Handler             ; Reserved
        DCD     PendSV_Handler              ; The PendSV handler
        DCD     SysTick_Handler             ; The SysTick handler
        ALIGNROM 8   ; Extend the initial Vector Table to the 2^8==256B

    ; Relocated Vector Table beyond the 256B region around address 0.
    ; That region is used for NULL-pointer protection by the MPU.
__relocated_vector_table
        DCD     sfe(CSTACK)
        DCD     Reset_Handler               ; Reset Handler
        DCD     NMI_Handler                 ; NMI Handler
        DCD     HardFault_Handler           ; Hard Fault Handler
        DCD     MemManage_Handler           ; The MPU fault handler
        DCD     BusFault_Handler            ; The bus fault handler
        DCD     UsageFault_Handler          ; The usage fault handler
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     Default_Handler             ; Reserved
        DCD     SVC_Handler                 ; SVCall handler
        DCD     DebugMon_Handler            ; Debug monitor handler
        DCD     Default_Handler             ; Reserved
        DCD     PendSV_Handler              ; The PendSV handler
        DCD     SysTick_Handler             ; The SysTick handler

        ; IRQ handlers...
        DCD     EMU_IRQHandler              ; 0 - EMU
        DCD     Default_Handler             ; 1 - Reserved
        DCD     WDOG0_IRQHandler            ; 2 - WDOG0
        DCD     Default_Handler             ; 3 - Reserved
        DCD     Default_Handler             ; 4 - Reserved
        DCD     Default_Handler             ; 5 - Reserved
        DCD     Default_Handler             ; 6 - Reserved
        DCD     Default_Handler             ; 7 - Reserved
        DCD     LDMA_IRQHandler             ; 8 - LDMA
        DCD     GPIO_EVEN_IRQHandler        ; 9 - GPIO_EVEN
        DCD     TIMER0_IRQHandler           ; 10 - TIMER0
        DCD     USART0_RX_IRQHandler        ; 11 - USART0_RX
        DCD     USART0_TX_IRQHandler        ; 12 - USART0_TX
        DCD     ACMP0_IRQHandler            ; 13 - ACMP0
        DCD     ADC0_IRQHandler             ; 14 - ADC0
        DCD     IDAC0_IRQHandler            ; 15 - IDAC0
        DCD     I2C0_IRQHandler             ; 16 - I2C0
        DCD     GPIO_ODD_IRQHandler         ; 17 - GPIO_ODD
        DCD     TIMER1_IRQHandler           ; 18 - TIMER1
        DCD     USART1_RX_IRQHandler        ; 19 - USART1_RX
        DCD     USART1_TX_IRQHandler        ; 20 - USART1_TX
        DCD     LEUART0_IRQHandler          ; 21 - LEUART0
        DCD     PCNT0_IRQHandler            ; 22 - PCNT0
        DCD     CMU_IRQHandler              ; 23 - CMU
        DCD     MSC_IRQHandler              ; 24 - MSC
        DCD     CRYPTO_IRQHandler           ; 25 - CRYPTO
        DCD     LETIMER0_IRQHandler         ; 26 - LETIMER0
        DCD     Default_Handler             ; 27 - Reserved
        DCD     Default_Handler             ; 28 - Reserved
        DCD     RTCC_IRQHandler             ; 29 - RTCC
        DCD     Default_Handler             ; 30 - Reserved
        DCD     CRYOTIMER_IRQHandler        ; 31 - CRYOTIMER
        DCD     Default_Handler             ; 32 - Reserved
        DCD     FPUEH_IRQHandler            ; 33 - FPUEH

        ; Extend the end of the Vector Table to the 2^8 boundary to ensure
        ; that no other data or code will be placed up to address 0x100.
        ; This might be necessary for NULL-pointer protection by the MPU,
        ; where a protected region of 2^8 bytes spans over the Vector Table.
        ALIGNRAM 8

__Vectors_End

__Vectors       EQU   __vector_table
__Vectors_Size  EQU   __Vectors_End - __Vectors

;******************************************************************************
;
; Weak fault handlers...
;
        SECTION .text:CODE:REORDER:NOROOT(2)

;.............................................................................
        PUBWEAK Reset_Handler
        EXTERN  SystemInit
        EXTERN  __iar_program_start
Reset_Handler

        ; relocate the Vector Table
        LDR     r0, =0xE000ED08 ; System Control Block/Vector Table Offset Reg
        LDR     r1, =__relocated_vector_table
        STR     r1,[r0]         ; SCB->VTOR := __Vector_Table

        BL      SystemInit  ; CMSIS system initialization

        ; pre-fill the CSTACK with 0xDEADBEEF...................
        LDR     r0,=0xDEADBEEF
        MOV     r1,r0
        LDR     r2,=sfb(CSTACK)
        LDR     r3,=sfe(CSTACK)
Reset_stackInit_fill:
        STMIA   r2!,{r0,r1}
        CMP     r2,r3
        BLT.N   Reset_stackInit_fill

        BL      __iar_program_start ; IAR startup code
;.............................................................................
        PUBWEAK NMI_Handler
NMI_Handler
        LDR     r0,=str_NMI
        MOVS    r1,#1
        B       assert_failed
str_NMI
        DCB     "NMI"
        ALIGNROM 2
;.............................................................................
        PUBWEAK HardFault_Handler
HardFault_Handler
        LDR     r0,=str_HardFault
        MOVS    r1,#1
        B       assert_failed
str_HardFault
        DCB     "HardFault"
        ALIGNROM 2
;.............................................................................
        PUBWEAK MemManage_Handler
MemManage_Handler
        LDR     r0,=str_MemManage
        MOVS    r1,#1
        B       assert_failed
str_MemManage
        DCB     "MemManage"
        ALIGNROM 2
;.............................................................................
        PUBWEAK BusFault_Handler
BusFault_Handler
        LDR     r0,=str_BusFault
        MOVS    r1,#1
        B       assert_failed
str_BusFault
        DCB     "BusFault"
        ALIGNROM 2
;.............................................................................
        PUBWEAK UsageFault_Handler
UsageFault_Handler
        LDR     r0,=str_UsageFault
        MOVS    r1,#1
        B       assert_failed
str_UsageFault
        DCB     "UsageFault"
        ALIGNROM 2

;******************************************************************************
;
; Weak non-fault handlers...
;

        PUBWEAK SVC_Handler
SVC_Handler
        LDR     r0,=str_SVC
        MOVS    r1,#1
        B       assert_failed
str_SVC
        DCB     "SVC"
        ALIGNROM 2
;.............................................................................
        PUBWEAK DebugMon_Handler
DebugMon_Handler
        LDR     r0,=str_DebugMon
        MOVS    r1,#1
        B       assert_failed
str_DebugMon
        DCB     "DebugMon"
        ALIGNROM 2
;.............................................................................
        PUBWEAK PendSV_Handler
PendSV_Handler
        LDR     r0,=str_PendSV
        MOVS    r1,#1
        B       assert_failed
str_PendSV
        DCB     "PendSV"
        ALIGNROM 2
;.............................................................................
        PUBWEAK SysTick_Handler
SysTick_Handler
        LDR     r0,=str_SysTick
        MOVS    r1,#1
        B       assert_failed
str_SysTick
        DCB     "SysTick"
        ALIGNROM 2

;******************************************************************************
;
; Weak IRQ handlers...
;

        PUBWEAK  Default_Handler
        PUBWEAK  EMU_IRQHandler
        PUBWEAK  WDOG0_IRQHandler
        PUBWEAK  LDMA_IRQHandler
        PUBWEAK  GPIO_EVEN_IRQHandler
        PUBWEAK  TIMER0_IRQHandler
        PUBWEAK  USART0_RX_IRQHandler
        PUBWEAK  USART0_TX_IRQHandler
        PUBWEAK  ACMP0_IRQHandler
        PUBWEAK  ADC0_IRQHandler
        PUBWEAK  IDAC0_IRQHandler
        PUBWEAK  I2C0_IRQHandler
        PUBWEAK  GPIO_ODD_IRQHandler
        PUBWEAK  TIMER1_IRQHandler
        PUBWEAK  USART1_RX_IRQHandler
        PUBWEAK  USART1_TX_IRQHandler
        PUBWEAK  LEUART0_IRQHandler
        PUBWEAK  PCNT0_IRQHandler
        PUBWEAK  CMU_IRQHandler
        PUBWEAK  MSC_IRQHandler
        PUBWEAK  CRYPTO_IRQHandler
        PUBWEAK  LETIMER0_IRQHandler
        PUBWEAK  RTCC_IRQHandler
        PUBWEAK  CRYOTIMER_IRQHandler
        PUBWEAK  FPUEH_IRQHandler

Default_Handler
EMU_IRQHandler
WDOG0_IRQHandler
LDMA_IRQHandler
GPIO_EVEN_IRQHandler
TIMER0_IRQHandler
USART0_RX_IRQHandler
USART0_TX_IRQHandler
ACMP0_IRQHandler
ADC0_IRQHandler
IDAC0_IRQHandler
I2C0_IRQHandler
GPIO_ODD_IRQHandler
TIMER1_IRQHandler
USART1_RX_IRQHandler
USART1_TX_IRQHandler
LEUART0_IRQHandler
PCNT0_IRQHandler
CMU_IRQHandler
MSC_IRQHandler
CRYPTO_IRQHandler
LETIMER0_IRQHandler
RTCC_IRQHandler
CRYOTIMER_IRQHandler
FPUEH_IRQHandler

        LDR     r0,=str_Undefined
        MOVS    r1,#1
        B       assert_failed
str_Undefined
        DCB     "Undefined"
        ALIGNROM 2

;*****************************************************************************
; The function assert_failed defines the error/assertion handling policy
; for the application. After making sure that the stack is OK, this function
; calls Q_onAssert, which should NOT return (typically reset the CPU).
;
; NOTE: the function Q_onAssert should NOT return.
;
; The C proptotype of the assert_failed() and Q_onAssert() functions are:
; void assert_failed(char const *file, int line);
; void Q_onAssert   (char const *file, int line);
;*****************************************************************************
        PUBLIC  assert_failed
        EXTERN  Q_onAssert
assert_failed
        LDR    r2,=sfe(CSTACK)   ; load the original top of stack
        MOV    sp,r2             ; re-set the SP in case of stack overflow
        BL     Q_onAssert        ; call the application-specific handler

        B      .                 ; should not be reached, but just in case...

        END                      ; end of module

