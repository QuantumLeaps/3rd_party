/***************************************************************************
 * Copyright (c) 2024 Microsoft Corporation
 *
 * This program and the accompanying materials are made available under the
 * terms of the MIT License which is available at
 * https://opensource.org/licenses/MIT.
 *
 * SPDX-License-Identifier: MIT
 **************************************************************************/


/**************************************************************************/
/**************************************************************************/
/**                                                                       */
/** ThreadX Component                                                     */
/**                                                                       */
/**   Module Manager                                                      */
/**                                                                       */
/**************************************************************************/
/**************************************************************************/

#define TX_SOURCE_CODE

#include "tx_api.h"
#include "tx_thread.h"
#include "txm_module.h"


/* Define the external user's fault notification callback function pointer.  This is
   setup via the txm_module_manager_memory_fault_notify API.  */

extern VOID    (*_txm_module_manager_fault_notify)(TX_THREAD *, TXM_MODULE_INSTANCE *);



/**************************************************************************/
/*                                                                        */
/*  FUNCTION                                               RELEASE        */
/*                                                                        */
/*    _txm_module_manager_memory_fault_notify             Cortex-Mx       */
/*                                                           6.1.9        */
/*  AUTHOR                                                                */
/*                                                                        */
/*    Scott Larson, Microsoft Corporation                                 */
/*                                                                        */
/*  DESCRIPTION                                                           */
/*                                                                        */
/*    This function registers an application callback when/if a memory    */
/*    fault occurs. The supplied thread is automatically terminated, but  */
/*    any other threads in the same module may still execute.             */
/*                                                                        */
/*  INPUT                                                                 */
/*                                                                        */
/*    notify_function                   Memory fault notification         */
/*                                        function, NULL disables.        */
/*                                                                        */
/*  OUTPUT                                                                */
/*                                                                        */
/*    status                            Completion status                 */
/*                                                                        */
/*  CALLS                                                                 */
/*                                                                        */
/*    None                                                                */
/*                                                                        */
/*  CALLED BY                                                             */
/*                                                                        */
/*    Application Code                                                    */
/*                                                                        */
/*  RELEASE HISTORY                                                       */
/*                                                                        */
/*    DATE              NAME                      DESCRIPTION             */
/*                                                                        */
/*  10-15-2021      Scott Larson            Initial Version 6.1.9         */
/*                                                                        */
/**************************************************************************/
UINT  _txm_module_manager_memory_fault_notify(VOID (*notify_function)(TX_THREAD *, TXM_MODULE_INSTANCE *))
{
    /* Setup notification function.  */
    _txm_module_manager_fault_notify =  notify_function;

    /* Return success.  */
    return(TX_SUCCESS);
}
