/*****************************************************************************
* Product: QUTEST port for STM32 NUCLEO-H743ZI board
* Last updated for version 7.2.0
* Last updated on  2022-12-15
*
*                    Q u a n t u m  L e a P s
*                    ------------------------
*                    Modern Embedded Software
*
* Copyright (C) 2005 Quantum Leaps, LLC. All rights reserved.
*
* This program is open source software: you can redistribute it and/or
* modify it under the terms of the GNU General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Alternatively, this program may be distributed and modified under the
* terms of Quantum Leaps commercial licenses, which expressly supersede
* the GNU General Public License and are specifically designed for
* licensees interested in retaining the proprietary status of their code.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <www.gnu.org/licenses/>.
*
* Contact information:
* <www.state-machine.com/licensing>
* <info@state-machine.com>
*****************************************************************************/
#ifndef Q_SPY
    #error "Q_SPY must be defined to compile qutest_port.c"
#endif /* Q_SPY */

#define QP_IMPL       /* this is QP implementation */
#include "qf_port.h"  /* QF port */
#include "qassert.h"  /* QP embedded systems-friendly assertions */
#include "qs_port.h"  /* QS port */
#include "qs_pkg.h"   /* QS package-scope interface */

/* STM32CubeH7 include files */
#include "stm32h7xx_hal.h"
#include "stm32h7xx_nucleo_144.h"
/* add other drivers if necessary... */

//Q_DEFINE_THIS_MODULE("qutest_port")

/* ISRs defined in this BSP ------------------------------------------------*/
void USART3_IRQHandler(void);

/*..........................................................................*/
/*
* ISR for receiving bytes from the QSPY Back-End
* NOTE: This ISR is "QF-unaware" meaning that it does not interact with
* the QF/QK and is not disabled. Such ISRs don't need to call QK_ISR_ENTRY/
* QK_ISR_EXIT and they cannot post or publish events.
*/
void USART3_IRQHandler(void) { /* kernel-unaware interrupt */
    /* is RX register NOT empty? */
    if ((USART3->ISR & USART_ISR_RXNE_RXFNE) != 0U) {
        uint32_t b = USART3->RDR;
        QS_rxPut(b);
        USART3->ISR &= ~USART_ISR_RXNE_RXFNE; /* clear int. */
    }
}

/* QS callbacks ============================================================*/
uint8_t QS_onStartup(void const *arg) {
    Q_UNUSED_PAR(arg);

    static uint8_t qsTxBuf[2*1024]; /* buffer for QS-TX channel */
    static uint8_t qsRxBuf[256];    /* buffer for QS-RX channel */

    QS_initBuf  (qsTxBuf, sizeof(qsTxBuf));
    QS_rxInitBuf(qsRxBuf, sizeof(qsRxBuf));

    static UART_HandleTypeDef uartHandle;
    uartHandle.Instance        = USART3;
    uartHandle.Init.BaudRate   = 115200;
    uartHandle.Init.WordLength = UART_WORDLENGTH_8B;
    uartHandle.Init.StopBits   = UART_STOPBITS_1;
    uartHandle.Init.Parity     = UART_PARITY_NONE;
    uartHandle.Init.HwFlowCtl  = UART_HWCONTROL_NONE;
    uartHandle.Init.Mode       = UART_MODE_TX_RX;
    uartHandle.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;
    if (HAL_UART_Init(&uartHandle) != HAL_OK) {
        return 0U; /* return failure */
    }

    /* Set UART to receive 1 byte at a time via interrupt */
    HAL_UART_Receive_IT(&uartHandle, (uint8_t *)qsRxBuf, 1);

    NVIC_SetPriority(USART3_IRQn,  0U); /* kernel unaware interrupt */
    NVIC_EnableIRQ(USART3_IRQn); /* UART interrupt used for QS-RX */

    return 1U; /* success */
}
/*..........................................................................*/
void QS_onCleanup(void) {
    /* wait as long as the UART is busy */
    while ((USART3->ISR & UART_FLAG_TXE) == 0U) {
    }
    /* delay before returning to allow all produced QS bytes to be received */
    for (uint32_t volatile dly_ctr = 1000000U; dly_ctr > 0U; --dly_ctr) {
    }
}
/*..........................................................................*/
void QS_onFlush(void) {
    for (;;) {
        QF_INT_DISABLE();
        uint16_t b = QS_getByte();
        QF_INT_ENABLE();

        if (b != QS_EOD) { /* not End-Of-Data? */
            /* busy-wait as long as UART-TX not ready */
            while ((USART3->ISR & UART_FLAG_TXE) == 0U) {
            }
            USART3->TDR = (b & 0xFFU);
        }
        else {
            break;
        }
    }
}
/*..........................................................................*/
/*! callback function to reset the target (to be implemented in the BSP) */
void QS_onReset(void) {
    NVIC_SystemReset();
}
/*..........................................................................*/
void QS_doOutput(void) {
    if ((USART3->ISR & UART_FLAG_TXE) != 0U) { /* TXE empty? */

        QF_INT_DISABLE();
        uint16_t b = QS_getByte();
        QF_INT_ENABLE();

        if (b != QS_EOD) {  /* not End-Of-Data? */
            USART3->TDR = (b & 0xFFU);  /* put into TDR */
        }
    }
}
/*..........................................................................*/
void QS_onTestLoop() {
    QS_rxPriv_.inTestLoop = true;
    while (QS_rxPriv_.inTestLoop) {

        QS_rxParse();  /* parse all the received bytes */

        if ((USART3->ISR & UART_FLAG_TXE) != 0U) {

            QF_INT_DISABLE();
            uint16_t b = QS_getByte();
            QF_INT_ENABLE();

            if (b != QS_EOD) { /* not End-Of-Data? */
                USART3->TDR = (b & 0xFFU);
            }
        }
    }
    /* set inTestLoop to true in case calls to QS_onTestLoop() nest,
    * which can happen through the calls to QS_TEST_PAUSE().
    */
    QS_rxPriv_.inTestLoop = true;
}
