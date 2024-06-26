                     Microsoft's Azure RTOS ThreadX for Cortex-M0

                                Using the GNU Tools

1.  Building the ThreadX run-time Library

First make sure you are in the "example_build" directory. Also, make sure that
you have setup your path and other environment variables necessary for the ARM
gnu (GNU) compiler. At this point you may run the build_threadx.bat batch file.
This will build the ThreadX run-time environment in the "example_build"
directory.

You should observe assembly and compilation of a series of ThreadX source
files. At the end of the batch file, they are all combined into the
run-time library file: tx.a. This file must be linked with your
application in order to use ThreadX.


2.  Demonstration System for Cortex-M0

The ThreadX demonstration is designed to execute on Cortex-M0 evaluation boards
or on a dedicated simulator.

Building the demonstration is easy, simply execute the build_threadx_sample.bat
batch file while inside the "example_build" directory.

You should observe the compilation of sample_threadx.c (which is the demonstration
application) and linking with tx.a. The resulting file sample_threadx.out is a binary
file that can be downloaded and executed on the a simulator, or downloaded to a board.


3.  System Initialization

The entry point in ThreadX for the Cortex-M0 using gnu tools uses the standard GNU
Cortex-M0 reset sequence. From the reset vector the C runtime will be initialized.

The ThreadX tx_initialize_low_level.S file is responsible for setting up
various system data structures, the vector area, and a periodic timer interrupt
source.

In addition, _tx_initialize_low_level determines the first available
address for use by the application, which is supplied as the sole input
parameter to your application definition function, tx_application_define.


4.  Register Usage and Stack Frames

The following defines the saved context stack frames for context switches
that occur as a result of interrupt handling or from thread-level API calls.
All suspended threads have the same stack frame in the Cortex-M0 version of
ThreadX. The top of the suspended thread's stack is pointed to by
tx_thread_stack_ptr in the associated thread control block TX_THREAD.


  Stack Offset     Stack Contents

     0x00               r8
     0x04               r9
     0x08               r10
     0x0C               r11
     0x10               r4
     0x14               r5
     0x18               r6
     0x1C               r7
     0x20               r0          (Hardware stack starts here!!)
     0x24               r1
     0x28               r2
     0x2C               r3
     0x30               r12
     0x34               lr
     0x38               pc
     0x3C               xPSR


5.  Improving Performance

The distribution version of ThreadX is built without any compiler optimizations.
This makes it easy to debug because you can trace or set breakpoints inside of
ThreadX itself. Of course, this costs some performance. To make it run faster,
you can change the build_threadx.bat file to remove the -g option and enable
all compiler optimizations.

In addition, you can eliminate the ThreadX basic API error checking by
compiling your application code with the symbol TX_DISABLE_ERROR_CHECKING
defined.


6.  Interrupt Handling

ThreadX provides complete and high-performance interrupt handling for Cortex-M0
targets. There are a certain set of requirements that are defined in the
following sub-sections:


6.1  Vector Area

The Cortex-M0 vectors start at the label __tx_vectors or similar. The application may modify
the vector area according to its needs. There is code in tx_initialize_low_level() that will
configure the vector base register.


6.2 Managed Interrupts

ISRs can be written completely in C (or assembly language) without any calls to
_tx_thread_context_save or _tx_thread_context_restore. These ISRs are allowed access to the
ThreadX API that is available to ISRs.

ISRs written in C will take the form (where "your_C_isr" is an entry in the vector table):

void    your_C_isr(void)
{

    /* ISR processing goes here, including any needed function calls.  */
}

ISRs written in assembly language will take the form:


        .global  your_assembly_isr
        .thumb_func
your_assembly_isr:
; VOID your_assembly_isr(VOID)
; {
        PUSH    {r0, lr}
;
;    /* Do interrupt handler work here */
;    /* BL <your interrupt routine in C> */

        POP     {r0, r1}
        MOV     lr, r1
        BX      lr
; }


Note: the Cortex-M0 requires exception handlers to be thumb labels, this implies bit 0 set.
To accomplish this, the declaration of the label has to be preceded by the assembler directive
.thumb_func to instruct the linker to create thumb labels. The label __tx_IntHandler needs to
be inserted in the correct location in the interrupt vector table. This table is typically
located in either your runtime startup file or in the tx_initialize_low_level.S file.


7.  Revision History

For generic code revision information, please refer to the readme_threadx_generic.txt
file, which is included in your distribution. The following details the revision
information associated with this specific port of ThreadX:

04-02-2021  Release 6.1.6 changes:
            tx_port.h                           Updated macro definition

03-02-2021  The following files were changed/added for version 6.1.5:
            tx_thread_schedule.s            Added low power feature

09-30-2020  ThreadX update of Cortex-M0/GNU port. The following files were
            changed/added for port specific version 6.1:

            tx_initialize_low_level.S       Comment out DWT code.
            *.S                             Modified comments and whitespace.

05/19/2020  Initial ThreadX 6.0 version for Cortex-M0 using GNU tools.


Copyright(c) 1996-2020 Microsoft Corporation


https://azure.com/rtos

