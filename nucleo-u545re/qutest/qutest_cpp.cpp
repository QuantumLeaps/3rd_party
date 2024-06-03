//============================================================================
// Product: QUTEST port for NUCLEO-U545RE-Q board
// Last updated for version 7.4.0
// Last updated on  2024-06-24
//
//                    Q u a n t u m  L e a P s
//                    ------------------------
//                    Modern Embedded Software
//
// Copyright (C) 2005 Quantum Leaps, LLC. <state-machine.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-QL-commercial
//
// This software is dual-licensed under the terms of the open source GNU
// General Public License version 3 (or any later version), or alternatively,
// under the terms of one of the closed source Quantum Leaps commercial
// licenses.
//
// The terms of the open source GNU General Public License version 3
// can be found at: <www.gnu.org/licenses/gpl-3.0>
//
// The terms of the closed source Quantum Leaps commercial licenses
// can be found at: <www.state-machine.com/licensing>
//
// Redistributions in source code must retain this top-level comment block.
// Plagiarizing this software to sidestep the license obligations is illegal.
//
// Contact information:
// <www.state-machine.com>
// <info@state-machine.com>
//============================================================================
#ifndef Q_SPY
    #error "Q_SPY must be defined to compile qutest_cpp.cpp"
#endif // Q_SPY

#define QP_IMPL        // this is QP implementation
#include "qp_port.hpp" // QP port
#include "qs_port.hpp" // QS port
#include "qs_pkg.hpp"  // QS package-scope interface
#include "qsafe.h"     // QP Functional Safety (FuSa) Subsystem

#include "stm32u545xx.h"  // CMSIS-compliant header file for the MCU used
// add other drivers if necessary...

//Q_DEFINE_THIS_MODULE("qutest_port")

using namespace QP;

// Local-scope defines -------------------------------------------------------
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
extern "C" {

// ISR for receiving bytes from the QSPY Back-End
// NOTE: This ISR is "QF-unaware" meaning that it does not interact with
// the underlying kernel
void USART1_IRQHandler(void); // prototype
void USART1_IRQHandler(void) { // used in QS-RX (kernel UNAWARE interrupt)
    // while Read Data Register or RX-FIFO Not Empty
    while ((USART1->ISR & USART_ISR_RXNE_Msk ) != 0U) {
        std::uint32_t b = USART1->RDR;
        QP::QS::rxPut(b);
    }
}

//............................................................................
void assert_failed(char const * const module, int_t const id); // prototype
void assert_failed(char const * const module, int_t const id) {
    Q_onError(module, id);
}

} // extern "C"

//============================================================================
// QS callbacks...

static std::uint16_t const QS_UARTPrescTable[12] = {
    1U, 2U, 4U, 6U, 8U, 10U, 12U, 16U, 32U, 64U, 128U, 256U
};

#define __LL_USART_DIV_SAMPLING16(__PERIPHCLK__, __PRESCALER__, __BAUDRATE__) \
  ((((__PERIPHCLK__)/(USART_PRESCALER_TAB[(__PRESCALER__)]))\
    + ((__BAUDRATE__)/2U))/(__BAUDRATE__))

#define QS_UART_DIV_SAMPLING16(__PCLK__, __BAUD__, __CLOCKPRESCALER__) \
  ((((__PCLK__)/QS_UARTPrescTable[(__CLOCKPRESCALER__)]) \
  + ((__BAUD__)/2U)) / (__BAUD__))

// USART1 pins PA.9 and PA.10
#define USART1_TX_PIN 9U
#define USART1_RX_PIN 10U

//............................................................................
bool QS::onStartup(void const *arg) {
    Q_UNUSED_PAR(arg);

    static std::uint8_t qsTxBuf[2*1024]; // buffer for QS-TX channel
    initBuf(qsTxBuf, sizeof(qsTxBuf));

    static std::uint8_t qsRxBuf[256];    // buffer for QS-RX channel
    rxInitBuf(qsRxBuf, sizeof(qsRxBuf));

    // enable peripheral clock for USART1 and its pins
    SET_BIT(RCC->APB2ENR, RCC_APB2ENR_USART1EN); // UART1 clock
    SET_BIT(RCC->AHB2ENR1, RCC_AHB2ENR1_GPIOAEN); // GPIOA clock for pins

    // Configure GPIOA to USART1_RX and USART1_TX pins.........................
    MODIFY_REG(GPIOA->OSPEEDR,
        GPIO_OSPEEDR_OSPEED0 << (USART1_TX_PIN * GPIO_OSPEEDR_OSPEED1_Pos),
        0U << (USART1_TX_PIN * GPIO_OSPEEDR_OSPEED1_Pos)); // speed==0
    MODIFY_REG(GPIOA->OSPEEDR,
        GPIO_OSPEEDR_OSPEED0 << (USART1_RX_PIN * GPIO_OSPEEDR_OSPEED1_Pos),
        0U << (USART1_RX_PIN * GPIO_OSPEEDR_OSPEED1_Pos)); // speed==0

    MODIFY_REG(GPIOA->OTYPER,
        (1U << USART1_TX_PIN) | (1U << USART1_RX_PIN),
        ((1U << USART1_TX_PIN) | (1U << USART1_RX_PIN) * 0U)); // output

    MODIFY_REG(GPIOA->PUPDR,
        GPIO_PUPDR_PUPD0 << (USART1_TX_PIN * GPIO_PUPDR_PUPD1_Pos),
        0U << (USART1_TX_PIN * GPIO_PUPDR_PUPD1_Pos)); // PUSHPULL
    MODIFY_REG(GPIOA->PUPDR,
        GPIO_PUPDR_PUPD0 << (USART1_RX_PIN * GPIO_PUPDR_PUPD1_Pos),
        0U << (USART1_RX_PIN * GPIO_PUPDR_PUPD1_Pos)); // PUSHPULL

    MODIFY_REG(GPIOA->AFR[1],
        GPIO_AFRH_AFSEL8 << ((USART1_TX_PIN - 8U) * GPIO_AFRH_AFSEL9_Pos),
        7U << ((USART1_TX_PIN - 8U) * GPIO_AFRH_AFSEL9_Pos)); // AF_7
    MODIFY_REG(GPIOA->AFR[1],
        GPIO_AFRH_AFSEL8 << ((USART1_RX_PIN - 8U) * GPIO_AFRH_AFSEL9_Pos),
        7U << ((USART1_RX_PIN - 8U) * GPIO_AFRH_AFSEL9_Pos)); // AF_7

    MODIFY_REG(GPIOA->MODER,
        GPIO_MODER_MODE0 << (USART1_TX_PIN * GPIO_MODER_MODE1_Pos),
        2U << (USART1_TX_PIN * GPIO_MODER_MODE1_Pos)); // MODE_2
    MODIFY_REG(GPIOA->MODER,
        GPIO_MODER_MODE0 << (USART1_RX_PIN * GPIO_MODER_MODE1_Pos),
        2U << (USART1_RX_PIN * GPIO_MODER_MODE1_Pos)); // MODE_2

    // configure USART1..............................................
    MODIFY_REG(USART1->CR1,
        (USART_CR1_M | USART_CR1_PCE | USART_CR1_PS |
            USART_CR1_TE | USART_CR1_RE | USART_CR1_OVER8),
        0U | // data==8bits
        0U | // parity==none
        12U | // direction==TX & RX
        0U);  // oversampling==16
    MODIFY_REG(USART1->CR2,
        USART_CR2_STOP,
        0U);  // stop-bits==1
    MODIFY_REG(USART1->CR3,
        USART_CR3_RTSE | USART_CR3_CTSE,
        0U);  // hardware-flow=NO

    // baud rate
    SystemCoreClockUpdate();
    USART1->BRR = QS_UART_DIV_SAMPLING16(
        SystemCoreClock, // USART1 clock
        115200U,         // baud rate
        0U);             // prescaler

    MODIFY_REG(USART1->PRESC,
        USART_PRESC_PRESCALER,
        0U); // prescaler=DIV1

    // FIFO thresholds
    MODIFY_REG(USART1->CR3,
        USART_CR3_TXFTCFG,
        0U << USART_CR3_TXFTCFG_Pos); // TX-FIFO=threshold-1
    MODIFY_REG(USART1->CR3,
        USART_CR3_RXFTCFG,
        0U << USART_CR3_RXFTCFG_Pos); // RX-FIFO=threshold-1

    SET_BIT(USART1->CR1, USART_CR1_FIFOEN);  // enable FIFO

    // asynch mode
    CLEAR_BIT(USART1->CR2, USART_CR2_LINEN | USART_CR2_CLKEN);
    CLEAR_BIT(USART1->CR3, USART_CR3_SCEN | USART_CR3_IREN | USART_CR3_HDSEL);

    // RXNE and RX FIFO Not Empty Interrupt Enable
    SET_BIT(USART1->CR1, USART_CR1_RXNEIE_Msk);

    SET_BIT(USART1->CR1, USART_CR1_UE); // enable USART
    // enable the UART RX interrupt...
    NVIC_EnableIRQ(USART1_IRQn); // interrupt used for QS-RX

    return true; // success
}
//............................................................................
void QS::onCleanup(void) {
    // wait as long as the UART is busy
    while ((USART1->ISR & USART_ISR_TXE_Msk) == 0U) { // TXE not empty
    }
    // delay before returning to allow all produced QS bytes to be received
    for (std::uint32_t volatile dly_ctr = 10000U; dly_ctr > 0U; --dly_ctr) {
    }
}
//............................................................................
// NOTE:
// No critical section in QS::onFlush() to avoid nesting of critical sections
// in case QS_onFlush() is called from Q_onError().
void QS::onFlush(void) {
    for (;;) {
        std::uint16_t b = getByte();
        if (b != QS_EOD) {
            while ((USART1->ISR & USART_ISR_TXE_Msk) == 0U) { // TXE not empty
            }
            USART1->TDR = b;
        }
        else {
            break;
        }
    }
}
//............................................................................
// callback function to reset the target (to be implemented in the BSP)
void QS::onReset(void) {
    NVIC_SystemReset();
}
//............................................................................
void QS::doOutput(void) {
    // while Transmit Data Register Empty or TX-FIFO Not Full
    while ((USART1->ISR & USART_ISR_TXE_TXFNF_Msk) != 0U) {
        QF_INT_DISABLE();
        std::uint16_t b = getByte();
        QF_INT_ENABLE();

        if (b != QS_EOD) {   // not End-Of-Data?
            USART1->TDR = b; // put into the DR register
        }
        else {
            break; // done for now
        }
    }
}
//............................................................................
void QS::onTestLoop() {
    rxPriv_.inTestLoop = true;
    while (rxPriv_.inTestLoop) {

        // toggle an LED LD2 on and then off (not enough LEDs, see NOTE02)
        GPIOA->BSRR = (1U << LD2_PIN); // turn LED[n] on
        GPIOA->BRR  = (1U << LD2_PIN); // turn LED[n] off

        rxParse();  // parse all the received bytes

        // while Transmit Data Register Empty or TX-FIFO Not Full
        while ((USART1->ISR & USART_ISR_TXE_TXFNF_Msk) != 0U) {
            QF_INT_DISABLE();
            std::uint16_t b = getByte();
            QF_INT_ENABLE();

            if (b != QS_EOD) {   // not End-Of-Data?
                USART1->TDR = b; // put into the DR register
            }
            else {
                break; // done for now
            }
        }
    }
    // set inTestLoop to true in case calls to QS_onTestLoop() nest,
    // which can happen through the calls to QS_TEST_PAUSE().
    rxPriv_.inTestLoop = true;
}
//============================================================================
// NOTE0:
// ARM Cortex-M0+ does NOT provide "kernel-unaware" interrupts, and
// consequently *all* interrupts are "kernel-aware". This means that
// the UART interrupt used for QS-RX is frequently DISABLED (e.g., to
// perform QS-TX). That can lead to lost some of the received bytes, and
// consequently some QUTest tests might be failing.
// A fix for that would be to use DMA for handling QS-RX, but this is
// currently not implemented.
//
