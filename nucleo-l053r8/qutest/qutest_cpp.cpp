//============================================================================
//! Product: QUTEST port for the STM32 NUCLEO-L053R8 board
// Last updated for version 7.2.1
// Last updated on  2023-01-24
//
//                    Q u a n t u m  L e a P s
//                    ------------------------
//                    Modern Embedded Software
//
// Copyright (C) 2005 Quantum Leaps. All rights reserved.
//
// This program is open source software: you can redistribute it and/or
// modify it under the terms of the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Alternatively, this program may be distributed and modified under the
// terms of Quantum Leaps commercial licenses, which expressly supersede
// the GNU General Public License and are specifically designed for
// licensees interested in retaining the proprietary status of their code.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <www.gnu.org/licenses>.
//
// Contact information:
// <www.state-machine.com/licensing>
// <info@state-machine.com>
//============================================================================
#ifndef Q_SPY
    #error "Q_SPY must be defined to compile qutest_cpp.cpp"
#endif // Q_SPY

#define QP_IMPL        // this is QP implementation
#include "qf_port.hpp" // QF port
#include "qs_port.hpp" // QS port
#include "qs_pkg.hpp"  // QS package-scope interface
#include "qassert.h"   // QP embedded systems-friendly assertions

#include "stm32l0xx.h" // CMSIS-compliant header file for the MCU used
// add other drivers if necessary...

//Q_DEFINE_THIS_MODULE("qutest_port")

using namespace QP;

// ISRs defined in this BSP --------------------------------------------------
extern "C" void USART2_IRQHandler(void);

// Local-scope objects -------------------------------------------------------
// LED pins available on the board (just one user LED LD2--Green on PA.5)
#define LD2_PIN  5U

// Button pins available on the board (just one user Button B1 on PC.13)
#define B1_PIN   13U

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
extern "C" {

// ISR for receiving bytes from the QSPY Back-End
// NOTE: This ISR is "QF-unaware" meaning that it does not interact with
// the QF/QK and is not disabled. Such ISRs don't need to call QK_ISR_ENTRY/
// QK_ISR_EXIT and they cannot post or publish events.
//
void USART2_IRQHandler(void) { // used in QS-RX (kernel UNAWARE interrupt)
    // is RX register NOT empty?
    while ((USART2->ISR & (1U << 5)) != 0) {
        std::uint32_t b = USART2->RDR;
        QP::QS::rxPut(b);
    }
}

} // extern "C"
// QS callbacks ==============================================================
bool QS::onStartup(void const *arg) {
    Q_UNUSED_PAR(arg);

    static std::uint8_t qsTxBuf[2*1024]; // buffer for QS-TX channel
    static std::uint8_t qsRxBuf[256];    // buffer for QS-RX channel

    initBuf  (qsTxBuf, sizeof(qsTxBuf));
    rxInitBuf(qsRxBuf, sizeof(qsRxBuf));

    // NOTE: SystemInit() already called from the startup code
    //  but SystemCoreClock needs to be updated
    //
    SystemCoreClockUpdate();

    // enable GPIOA clock port for the LED LD2
    RCC->IOPENR |= (1U << 0U);

    // configure LED (PA.5) pin as push-pull output, no pull-up, pull-down
    GPIOA->MODER   &= ~((3U << 2U*LD2_PIN));
    GPIOA->MODER   |=  ((1U << 2U*LD2_PIN));
    GPIOA->OTYPER  &= ~((1U <<    LD2_PIN));
    GPIOA->OSPEEDR &= ~((3U << 2U*LD2_PIN));
    GPIOA->OSPEEDR |=  ((1U << 2U*LD2_PIN));
    GPIOA->PUPDR   &= ~((3U << 2U*LD2_PIN));

    // enable GPIOC clock port for the Button B1
    RCC->IOPENR |=  (1U << 2U);

    // configure Button (PC.13) pins as input, no pull-up, pull-down
    GPIOC->MODER   &= ~(3U << 2U*B1_PIN);
    GPIOC->OSPEEDR &= ~(3U << 2U*B1_PIN);
    GPIOC->OSPEEDR |=  (1U << 2U*B1_PIN);
    GPIOC->PUPDR   &= ~(3U << 2U*B1_PIN);

    // enable peripheral clock for USART2
    RCC->IOPENR  |= ( 1U <<  0U);  // Enable GPIOA clock
    RCC->APB1ENR |= ( 1U << 17U);  // Enable USART#2 clock

    // Configure PA3 to USART2_RX, PA2 to USART2_TX
    GPIOA->AFR[0] &= ~((15U << 4U*USART2_RX_PIN) | (15U << 4U*USART2_TX_PIN) );
    GPIOA->AFR[0] |=  (( 4U << 4U*USART2_RX_PIN) | ( 4U << 4U*USART2_TX_PIN) );
    GPIOA->MODER  &= ~(( 3U << 2U*USART2_RX_PIN) | ( 3U << 2U*USART2_TX_PIN) );
    GPIOA->MODER  |=  (( 2U << 2U*USART2_RX_PIN) | ( 2U << 2U*USART2_TX_PIN) );

    USART2->BRR  = __USART_BRR(SystemCoreClock, 115200U);  // baud rate
    USART2->CR3  = 0x0000U |      // no flow control
                   (1U << 12U);   // disable overrun detection (OVRDIS)
    USART2->CR2  = 0x0000U;       // 1 stop bit
    USART2->CR1  = ((1U <<  2U) | // enable RX
                    (1U <<  3U) | // enable TX
                    (1U <<  5U) | // enable RX interrupt
                    (0U << 12U) | // 8 data bits
                    (0U << 28U) | // 8 data bits
                    (1U <<  0U) );// enable USART

    // explicitly set NVIC priorities of all Cortex-M interrupts used
    NVIC_SetPriorityGrouping(0U);
    NVIC_SetPriority(USART2_IRQn, 0U);

    // enable the UART RX interrupt...
    NVIC_EnableIRQ(USART2_IRQn); // UART2 interrupt used for QS-RX

    return true; // success
}
//............................................................................
void QS::onCleanup(void) {
    // wait as long as the UART is busy
    while ((USART2->ISR & (1U << 7U)) == 0U) {
    }
    // delay before returning to allow all produced QS bytes to be received
    for (std::uint32_t volatile dly_ctr = 10000U; dly_ctr > 0U; --dly_ctr) {
    }
}
//............................................................................
void QS::onFlush(void) {
   for (;;) {
        QF_INT_DISABLE();
        std::uint16_t b = getByte();
        QF_INT_ENABLE();

        if (b != QS_EOD) {
            while ((USART2->ISR & (1U << 7U)) == 0U) {
            }
            USART2->TDR  = (b & 0xFFU);  // put into the DR register
        }
        else {
            break;
        }
    }
}
//............................................................................
//! callback function to reset the target (to be implemented in the BSP)
void QS::onReset(void) {
    NVIC_SystemReset();
}
//............................................................................
void QS::doOutput(void) {
    if ((USART2->ISR & (1U << 7U)) != 0U) {  // is TXE empty?
        QF_INT_DISABLE();
        std::uint16_t b = getByte();
        QF_INT_ENABLE();

        if (b != QS_EOD) {  // not End-Of-Data?
            USART2->TDR = (b & 0xFFU);  // put into the DR register
        }
    }
}
//............................................................................
void QS::onTestLoop() {
    rxPriv_.inTestLoop = true;
    while (rxPriv_.inTestLoop) {

        // toggle an LED LD2 on and then off (not enough LEDs, see NOTE02)
        GPIOA->BSRR = (1U << LD2_PIN);         // turn LED[n] on
        GPIOA->BSRR = (1U << (LD2_PIN + 16U)); // turn LED[n] off

        rxParse();  // parse all the received bytes

        if ((USART2->ISR & (1U << 7U)) != 0U) {  // is TXE empty?
            std::uint16_t b = getByte();
            if (b != QS_EOD) {  // not End-Of-Data?
                USART2->TDR = (b & 0xFFU);  // put into the DR register
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
