//============================================================================
// QUTEST port for NUCLEO-H533RE board
//
// Copyright (C) 2005 Quantum Leaps, LLC. All rights reserved.
//
//                    Q u a n t u m  L e a P s
//                    ------------------------
//                    Modern Embedded Software
//
// SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-QL-commercial
//
// This software is dual-licensed under the terms of the open-source GNU
// General Public License (GPL) or under the terms of one of the closed-
// source Quantum Leaps commercial licenses.
//
// Redistributions in source code must retain this top-level comment block.
// Plagiarizing this software to sidestep the license obligations is illegal.
//
// NOTE:
// The GPL does NOT permit the incorporation of this code into proprietary
// programs. Please contact Quantum Leaps for commercial licensing options,
// which expressly supersede the GPL and are designed explicitly for
// closed-source distribution.
//
// Quantum Leaps contact information:
// <www.state-machine.com/licensing>
// <info@state-machine.com>
//============================================================================
#ifndef Q_SPY
    #error "Q_SPY must be defined to compile qutest_port.c"
#endif // Q_SPY

#define QP_IMPL        // this is QP implementation
#include "qp_port.h"   // QP port
#include "qs_port.h"   // QS port
#include "qs_pkg.h"    // QS package-scope interface
#include "qsafe.h"     // QP Functional Safety (FuSa) Subsystem

#include "stm32h533xx.h"  // CMSIS-compliant header file for the MCU used
// add other drivers if necessary...

//============================================================================
//Q_DEFINE_THIS_MODULE("qutest_port") // name of this file for assertions

// HSI CPU clock (64MHz) divisor (allowed 1U, 2U, 4U, 8U)
#define HSI_CLK_DIV 4U  // 64MHz/4 == 16MHz

// LED pins available on the board (just one user LED LD2--Green on PA.5)
#define LD2_PIN  5U

// Button pins available on the board (just one user Button B1 on PC.13)
#define B1_PIN   13U

// macros from STM32Cube LL:
#define SET_BIT(REG, BIT)     ((REG) |= (BIT))
#define CLEAR_BIT(REG, BIT)   ((REG) &= ~(BIT))
#define READ_BIT(REG, BIT)    ((REG) & (BIT))
#define CLEAR_REG(REG)        ((REG) = (0x0))
#define WRITE_REG(REG, VAL)   ((REG) = (VAL))
#define READ_REG(REG)         ((REG))
#define MODIFY_REG(REG, CLEARMASK, SETMASK) \
    WRITE_REG((REG), ((READ_REG(REG) & (~(CLEARMASK))) | (SETMASK)))

//............................................................................
// ISR for receiving bytes from the QSPY Back-End
// NOTE: This ISR is "QF-unaware" meaning that it does not interact with
// the underlying kernel
void USART2_IRQHandler(void); // prototype
void USART2_IRQHandler(void) { // used in QS-RX (kernel UNAWARE interrupt)
    // while Read Data Register or RX-FIFO Not Empty
    while ((USART2->ISR & USART_ISR_RXNE_Msk ) != 0U) {
        uint32_t const b = USART2->RDR;
        QS_RX_PUT(b);
    }
}
//............................................................................
// assertion failure handler for the startup code and libraries
void assert_failed(char const * const module, int_t const id); // prototype
void assert_failed(char const * const module, int_t const id) {
    Q_onError(module, id);
}

//============================================================================
// QS callbacks...

//..........................................................................
static void SystemClock_Config(void) {
#if HSI_CLK_DIV == 1U
    uint32_t const rcc_cr_hisdiv = 0U;              // div by 1
    uint32_t const flash_latency = FLASH_ACR_LATENCY_3WS;
#elif HSI_CLK_DIV == 2U
    uint32_t const rcc_cr_hisdiv = RCC_CR_HSIDIV_0; // div by 2
    uint32_t const flash_latency = FLASH_ACR_LATENCY_1WS;
#elif HSI_CLK_DIV == 4U
    uint32_t const rcc_cr_hisdiv = RCC_CR_HSIDIV_1; // div by 4
    uint32_t const flash_latency = FLASH_ACR_LATENCY_0WS;
#elif HSI_CLK_DIV == 8U
    uint32_t const rcc_cr_hisdiv = RCC_CR_HSIDIV;   // div by 8
    uint32_t const flash_latency = FLASH_ACR_LATENCY_0WS;
#else
    error Unsupported HSI_CLK_DIV
#endif

    // Flash latency depends on the clock speed...
    MODIFY_REG(FLASH->ACR, FLASH_ACR_LATENCY, flash_latency);
    while (READ_BIT(FLASH->ACR, 0U)) {
    }

    MODIFY_REG(PWR->VOSCR, PWR_VOSCR_VOS, 0U);
    while (READ_BIT(PWR->VOSSR, PWR_VOSSR_VOSRDY) != PWR_VOSSR_VOSRDY) {
    }

    SET_BIT(RCC->CR, RCC_CR_HSION);
    while (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != RCC_CR_HSIRDY) {
    }

    MODIFY_REG(RCC->HSICFGR, RCC_HSICFGR_HSITRIM, 64U << RCC_HSICFGR_HSITRIM_Pos);
    MODIFY_REG(RCC->CR, RCC_CR_HSIDIV, rcc_cr_hisdiv);
    MODIFY_REG(RCC->CFGR1, RCC_CFGR1_SW, 0x0);
    while (READ_BIT(RCC->CFGR1, RCC_CFGR1_SWS) != 0U) {
    }

    MODIFY_REG(RCC->CFGR2, RCC_CFGR2_HPRE, 0U);
    MODIFY_REG(RCC->CFGR2, RCC_CFGR2_PPRE1, 0U);
    MODIFY_REG(RCC->CFGR2, RCC_CFGR2_PPRE2, 0U);
    MODIFY_REG(RCC->CFGR2, RCC_CFGR2_PPRE3, 0U);

    // update SystemCoreClock
    SystemCoreClockUpdate();
}

//............................................................................
static uint16_t const QS_UARTPrescTable[12] = {
    1U, 2U, 4U, 6U, 8U, 10U, 12U, 16U, 32U, 64U, 128U, 256U
};

#define __LL_USART_DIV_SAMPLING16(__PERIPHCLK__, __PRESCALER__, __BAUDRATE__) \
  ((((__PERIPHCLK__)/(USART_PRESCALER_TAB[(__PRESCALER__)]))\
    + ((__BAUDRATE__)/2U))/(__BAUDRATE__))

#define QS_UART_DIV_SAMPLING16(__PCLK__, __BAUD__, __CLOCKPRESCALER__) \
  ((((__PCLK__)/QS_UARTPrescTable[(__CLOCKPRESCALER__)]) \
  + ((__BAUD__)/2U)) / (__BAUD__))

// USART2 pins PA.2 and PA.3
#define USART2_TX_PIN 2U
#define USART2_RX_PIN 3U

//............................................................................
uint8_t QS_onStartup(void const *arg) {
    Q_UNUSED_PAR(arg);

    SystemClock_Config(); // configure the CPU clock

    static uint8_t qsTxBuf[2*1024]; // buffer for QS-TX channel
    QS_initBuf(qsTxBuf, sizeof(qsTxBuf));

    static uint8_t qsRxBuf[256];    // buffer for QS-RX channel
    QS_rxInitBuf(qsRxBuf, sizeof(qsRxBuf));

    // enable GPIOA clock port for the LD2 LED
    SET_BIT(RCC->AHB2ENR, RCC_AHB2ENR_GPIOAEN);

    // set LD2_PIN as output, no pull-up, pull-down
    MODIFY_REG(GPIOA->OSPEEDR,
               GPIO_OSPEEDR_OSPEED0 << (LD2_PIN * GPIO_OSPEEDR_OSPEED1_Pos),
               1U << (LD2_PIN * GPIO_OSPEEDR_OSPEED1_Pos)); // speed==1
    MODIFY_REG(GPIOA->OTYPER,
               1U << LD2_PIN,
               0U << LD2_PIN); // output
    MODIFY_REG(GPIOA->PUPDR,
               GPIO_PUPDR_PUPD0 << (LD2_PIN * GPIO_PUPDR_PUPD1_Pos),
               0U << (LD2_PIN * GPIO_PUPDR_PUPD1_Pos)); // PUSHPULL
    MODIFY_REG(GPIOA->MODER,
               GPIO_MODER_MODE0 << (LD2_PIN * GPIO_MODER_MODE1_Pos),
               1U << (LD2_PIN * GPIO_MODER_MODE1_Pos)); // MODE_1

    // enable peripheral clock for USART2 and its pins
    SET_BIT(RCC->APB1LENR, RCC_APB1LENR_USART2EN); // USART2 clock
    SET_BIT(RCC->AHB2ENR, RCC_AHB2ENR_GPIOAEN); // GPIOA clock for pins

    // configure GPIOA to USART2_TX and USART2_RX pins.........................
    uint32_t tmp;

    // configure GPIOA to USART2_TX ...........................................
    // configure alternate function
    tmp = GPIOA->AFR[USART2_TX_PIN >> 3U];
    tmp &= ~(0x0FUL << ((USART2_TX_PIN & 0x07U) * GPIO_AFRL_AFSEL1_Pos));
    tmp |= (7U << ((USART2_TX_PIN & 0x07U) * GPIO_AFRL_AFSEL1_Pos));
    GPIOA->AFR[USART2_TX_PIN >> 3U] = tmp; // 0x700

    // configure IO Direction mode (Input, Output, Alternate or Analog)
    tmp = GPIOA->MODER;
    tmp &= ~(GPIO_MODER_MODE0 << (USART2_TX_PIN * GPIO_MODER_MODE1_Pos));
    tmp |= (2U << (USART2_TX_PIN * GPIO_MODER_MODE1_Pos));
    GPIOA->MODER = tmp;

    // configure the IO Speed
    tmp = GPIOA->OSPEEDR;
    tmp &= ~(GPIO_OSPEEDR_OSPEED0 << (USART2_TX_PIN * GPIO_OSPEEDR_OSPEED1_Pos));
    tmp |= (2U << (USART2_TX_PIN * GPIO_OSPEEDR_OSPEED1_Pos));
    GPIOA->OSPEEDR = tmp;

    // configure the IO Output Type
    tmp = GPIOA->OTYPER;
    tmp &= ~(GPIO_OTYPER_OT0 << USART2_TX_PIN) ;
    GPIOA->OTYPER = tmp;

    // activate the Pull-up or Pull down resistor for the current IO
    tmp = GPIOA->PUPDR;
    tmp &= ~(GPIO_PUPDR_PUPD0 << (USART2_TX_PIN * GPIO_PUPDR_PUPD1_Pos));
    tmp |= (1U << (USART2_TX_PIN * GPIO_PUPDR_PUPD1_Pos));
    GPIOA->PUPDR = tmp;

    // configure GPIOA to USART2_RX ...........................................

    // configure alternate function
    tmp = GPIOA->AFR[USART2_RX_PIN >> 3U];
    tmp &= ~(0xFU << ((USART2_RX_PIN & 0x07U) * GPIO_AFRL_AFSEL1_Pos));
    tmp |= (7U << ((USART2_RX_PIN & 0x7U) * GPIO_AFRL_AFSEL1_Pos));
    GPIOA->AFR[USART2_RX_PIN >> 3U] = tmp;

    // configure IO Direction mode (Input, Output, Alternate or Analog)
    tmp = GPIOA->MODER;
    tmp &= ~(GPIO_MODER_MODE0 << (USART2_RX_PIN * GPIO_MODER_MODE1_Pos));
    tmp |= (2U << (USART2_RX_PIN * GPIO_MODER_MODE1_Pos));
    GPIOA->MODER = tmp;

    // configure the IO Speed
    tmp = GPIOA->OSPEEDR;
    tmp &= ~(GPIO_OSPEEDR_OSPEED0 << (USART2_RX_PIN * GPIO_OSPEEDR_OSPEED1_Pos));
    tmp |= (2U << (USART2_RX_PIN * GPIO_OSPEEDR_OSPEED1_Pos));
    GPIOA->OSPEEDR = tmp;

    // configure the IO Output Type
    tmp = GPIOA->OTYPER;
    tmp &= ~(GPIO_OTYPER_OT0 << USART2_RX_PIN) ;
    GPIOA->OTYPER = tmp;

    // activate the Pull-up or Pull down resistor for the current IO
    tmp = GPIOA->PUPDR;
    tmp &= ~(GPIO_PUPDR_PUPD0 << (USART2_RX_PIN * GPIO_PUPDR_PUPD1_Pos));
    tmp |= (1U << (USART2_RX_PIN * GPIO_PUPDR_PUPD1_Pos));
    GPIOA->PUPDR = tmp;


    // configure USART2..............................................
    MODIFY_REG(USART2->CR1,
        (USART_CR1_M | USART_CR1_PCE | USART_CR1_PS |
         USART_CR1_TE | USART_CR1_RE | USART_CR1_OVER8),
        0U  | // data==8bits
        0U  | // parity==none
        12U | // direction==TX & RX
        0U);  // oversampling==16
    MODIFY_REG(USART2->CR2,
        USART_CR2_STOP,
        0U);  // stop-bits==1
    MODIFY_REG(USART2->CR3,
        USART_CR3_RTSE | USART_CR3_CTSE,
        0U);  // hardware-flow=NO

    // baud rate
    SystemCoreClockUpdate();
    USART2->BRR = QS_UART_DIV_SAMPLING16(
        SystemCoreClock, // USART2 clock
        115200U,         // baud rate
        0U);             // prescaler

    MODIFY_REG(USART2->PRESC,
        USART_PRESC_PRESCALER,
        0U); // prescaler=DIV1

    // FIFO thresholds
    MODIFY_REG(USART2->CR3,
        USART_CR3_TXFTCFG,
        0U << USART_CR3_TXFTCFG_Pos); // TX-FIFO=threshold-1
    MODIFY_REG(USART2->CR3,
        USART_CR3_RXFTCFG,
        0U << USART_CR3_RXFTCFG_Pos); // RX-FIFO=threshold-1

    SET_BIT(USART2->CR1, USART_CR1_FIFOEN);  // enable FIFO

    // asynch mode
    CLEAR_BIT(USART2->CR2, USART_CR2_LINEN | USART_CR2_CLKEN);
    CLEAR_BIT(USART2->CR3, USART_CR3_SCEN | USART_CR3_IREN | USART_CR3_HDSEL);

    // RXNE and RX FIFO Not Empty Interrupt Enable
    SET_BIT(USART2->CR1, USART_CR1_RXNEIE_Msk);

    SET_BIT(USART2->CR1, USART_CR1_UE); // enable USART

    // enable the UART RX interrupt...
    NVIC_EnableIRQ(USART2_IRQn); // interrupt used for QS-RX

    return 1U; // return success
}
//............................................................................
void QS_onCleanup(void) {
    // wait as long as the UART is busy
    while ((USART2->ISR & USART_ISR_TXE_Msk) == 0U) { // TXE not empty
    }
    // delay before returning to allow all produced QS bytes to be received
    for (uint32_t volatile dly_ctr = 10000U; dly_ctr > 0U; --dly_ctr) {
    }
}
//............................................................................
// NOTE:
// No critical section in QS_onFlush() to avoid nesting of critical sections
// in case QS_onFlush() is called from Q_onError().
void QS_onFlush(void) {
    GPIOA->BSRR = (1U << LD2_PIN); // turn LD2 on
    for (;;) {
        uint16_t const b = QS_getByte();
        if (b != QS_EOD) {
            while ((USART2->ISR & USART_ISR_TXE_Msk) == 0U) { // TXE not empty
            }
            USART2->TDR = b;
        }
        else {
            break;
        }
    }
    GPIOA->BRR  = (1U << LD2_PIN); // turn LD2 off
}
//............................................................................
// callback function to reset the target (to be implemented in the BSP)
void QS_onReset(void) {
    NVIC_SystemReset();
}
//............................................................................
void QS_doOutput(void) {
    GPIOA->BSRR = (1U << LD2_PIN); // turn LD2 on
    // while Transmit Data Register Empty or TX-FIFO Not Full
    while ((USART2->ISR & USART_ISR_TXE_TXFNF_Msk) != 0U) {
        uint16_t const b = QS_getByte();
        if (b != QS_EOD) {   // not End-Of-Data?
            USART2->TDR = b; // put into the DR register
        }
        else {
            break; // done for now
        }
    }
    GPIOA->BRR  = (1U << LD2_PIN); // turn LD2 off
}
//............................................................................
void QS_onTestLoop() {
    QS_tstPriv_.inTestLoop = true;
    while (QS_tstPriv_.inTestLoop) {
        QS_rxParse();  // parse all received bytes

        // while Transmit Data Register Empty or TX-FIFO Not Full
        while ((USART2->ISR & USART_ISR_TXE_TXFNF_Msk) != 0U) {
            uint16_t const b = QS_getByte();
            if (b != QS_EOD) {   // not End-Of-Data?
                USART2->TDR = b; // put into the DR register
            }
            else {
                break; // done for now
            }
        }

        // blink LD2 as "heartbeat"
        static uint32_t ctr = 1U;
        static enum { OFF, ON } state = OFF;
        if (--ctr == 0U) {
            if (state == OFF) {
                GPIOA->BSRR = (1U << LD2_PIN); // turn LD2 on
                ctr = 10000U;
                state = ON;
            }
            else {
                GPIOA->BRR  = (1U << LD2_PIN); // turn LD2 off
                ctr = 80000U;
                state = OFF;
           }
        }
    }
    // set inTestLoop to true in case calls to QS_onTestLoop() nest,
    // which can happen through the calls to QS_TEST_PAUSE().
    QS_tstPriv_.inTestLoop = true;
}
