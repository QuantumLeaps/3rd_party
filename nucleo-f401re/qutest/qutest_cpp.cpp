//============================================================================
// Product: QUTEST port for NUCLEO-F401RE board
// Last updated for version 8.0.0
// Last updated on  2024-11-08
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

#include "stm32f4xx.h"  // CMSIS-compliant header file for the MCU used
// add other drivers if necessary...

using namespace QP;

//Q_DEFINE_THIS_MODULE("qutest_port")

// Local-scope defines -------------------------------------------------------
// LED pins available on the board (just one user LED LD2--Green on PA.5)
#define LD2_PIN  5U

// Button pins available on the board (just one user Button B1 on PC.13)
#define B1_PIN   13U

//............................................................................
extern "C" {

// ISR for receiving bytes from the QSPY Back-End
// NOTE: This ISR is "QF-unaware" meaning that it does not interact with
// the underlying kernel
void USART2_IRQHandler(void); // prototype
void USART2_IRQHandler(void) { // used in QS-RX (kernel UNAWARE interrupt)
    while ((USART2->SR & USART_SR_RXNE) != 0U) { // is RX register NOT empty?
        uint32_t b = USART2->DR;
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

//............................................................................
#define __DIV(__PCLK, __BAUD)       (((__PCLK / 4) *25)/(__BAUD))
#define __DIVMANT(__PCLK, __BAUD)   (__DIV(__PCLK, __BAUD)/100)
#define __DIVFRAQ(__PCLK, __BAUD)   \
    (((__DIV(__PCLK, __BAUD) - (__DIVMANT(__PCLK, __BAUD) * 100)) \
        * 16 + 50) / 100)
#define __USART_BRR(__PCLK, __BAUD) \
    ((__DIVMANT(__PCLK, __BAUD) << 4)|(__DIVFRAQ(__PCLK, __BAUD) & 0x0F))

// USART2 pins PA.2 and PA.3
#define USART2_TX_PIN 2U
#define USART2_RX_PIN 3U

//............................................................................
bool QS::onStartup(void const *arg) {
    Q_UNUSED_PAR(arg);

    static std::uint8_t qsTxBuf[2*1024]; // buffer for QS-TX channel
    initBuf(qsTxBuf, sizeof(qsTxBuf));

    static std::uint8_t qsRxBuf[100];    // buffer for QS-RX channel
    rxInitBuf(qsRxBuf, sizeof(qsRxBuf));

    // NOTE: SystemInit() already called from the startup code
    //  but SystemCoreClock needs to be updated
    SystemCoreClockUpdate();

    // enable peripheral clock for USART2
    RCC->AHB1ENR |= ( 1U <<  0U);  // Enable GPIOA clock
    RCC->APB1ENR |= ( 1U << 17U);  // Enable USART#2 clock

    // Configure PA3 to USART2_RX, PA2 to USART2_TX
    GPIOA->AFR[0] &= ~((15U << 4U*USART2_RX_PIN) | (15U << 4U*USART2_TX_PIN));
    GPIOA->AFR[0] |=  (( 7U << 4U*USART2_RX_PIN) | ( 7U << 4U*USART2_TX_PIN));
    GPIOA->MODER  &= ~(( 3U << 2U*USART2_RX_PIN) | ( 3U << 2U*USART2_TX_PIN));
    GPIOA->MODER  |=  (( 2U << 2U*USART2_RX_PIN) | ( 2U << 2U*USART2_TX_PIN));

    USART2->BRR  = __USART_BRR(SystemCoreClock, 115200U);  // baud rate
    USART2->CR3  = 0x0000U;         // no flow control
    USART2->CR2  = 0x0000U;         // 1 stop bit
    USART2->CR1  = ((1U <<  2U) |   // enable RX
                    (1U <<  3U) |   // enable TX
                    (1U <<  5U) |   // enable RX interrupt
                    (0U << 12U) |   // 8 data bits
                    (0U << 28U) |   // 8 data bits
                    (1U << 13U));   // enable USART

    // enable the UART RX interrupt...
    NVIC_EnableIRQ(USART2_IRQn); // UART2 interrupt used for QS-RX

    return true; // success
}
//............................................................................
void QS::onCleanup(void) {
    // wait as long as the UART is busy
    while ((USART2->SR & USART_SR_TXE) == 0U) { // while TXE not empty
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
            while ((USART2->SR & USART_SR_TXE) == 0U) { // while TXE not empty
            }
            USART2->DR = b; // put into the DR register
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
    // while Transmit Data Register Empty
    while ((USART2->SR & USART_SR_TXE) != 0) { // TXE empty?
        QF_INT_DISABLE();
        std::uint16_t b = getByte();
        QF_INT_ENABLE();

        if (b != QS_EOD) {  // not End-Of-Data?
            USART2->DR = b; // put into the DR register
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
        GPIOA->BSRR = (1U << LD2_PIN); // turn LD2 on
        GPIOA->BSRR = (1U << (LD2_PIN + 16U)); // turn LD2 off

        rxParse();  // parse all the received bytes

        // while Transmit Data Register not empty
        while ((USART2->SR & USART_SR_TXE) != 0) { // TXE empty?
            QF_INT_DISABLE();
            std::uint16_t b = getByte();
            QF_INT_ENABLE();

            if (b != QS_EOD) {  // not End-Of-Data?
                USART2->DR = b; // put into the DR register
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
