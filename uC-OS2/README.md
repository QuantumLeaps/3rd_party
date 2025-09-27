# About uC-OS2

uC-OS2 (a.k.a. uC/OS-II or MicroC/OS-II) is a full-featured embedded operating
system originally developed by Micrium. In addition to the two highly popular
kernels, uC-OS2 features support for TCP/IP, USB-Device, USB-Host, and Modbus,
as well as a robust File System.

> **NOTE:** Micrium and all its products, inlcuding uC-OS2, were acquired by
Silicon Labs in 2016. Silicon Labs later decided to release all Micrium
products under the permissive open source Apache License, Version 2.0.
Around 2020, the custody of the uC-OS RTOS and other Mircium products was
taken over by Weston Embedded Solutions, which is a company founded by a
team of former Micrium employees.

# uC-OS2 Source Code

The uC-OS2 code ( V2.93.01) has been forked from the Weston Embedded GitHub
repository:

https://github.com/weston-embedded/uC-OS2

> **NOTE:** The uC-OS2 from GitHub has been __modified__ by Quantum Leaps
to comply with CMSIS and to adapt the GNU-ARM ports for the new GCC ARM toolset.


# Modifications by Quantum Leaps

The uC-OS2 from Weston Embedded has been __modified__ by Quantum Leaps in
the following ways:

## ARM Cortex-M Ports
The original uC-OS2 ports directory has been pruned and only the ports
to ARM Cortex-M relevant to the Quantum Leaps examples have been retained.

## CMSIS Support
The uC-OS2 ports to ARM-Cortex-M have been modified by Quantum Leaps to remove
the dependencies on the Micrium's uC-CPU and uC-LIB components, and instead
to comply with the Cortex Microcontroller Software Interface Standard (CMSIS).
Specifically, the names of the standard exception handlers `OS_CPU_PendSVHandler`
and `OS_CPU_SysTickHanlder` used by the original uC-OS2 ports have been changed
to be CMSIS-compliant names: `PendSV_Handler` and `SysTick_Hanlder`, respectively.

## FPU Support
Additionally, the Cortex-M4F ports have been modified to include the FPU
configuration that is expected by the uC-OS2 port to Cortex-M4F, which
was different from the FPU configuration performed by the CMSIS-compliant
startup code. Specifically, the explicit FPU configuration has been
`OSInitHookEnd()` function in the file `os_cpu_c.c`.

## GCC-ARM 14.3 Support
Additionally, the ARM Cortex-M ports for the GNU toolchain have been modified
for the new binutils 2.44 (present in the GCC-ARM 14.3.1), which require
differnt syntax in assembly. Specifically, assembly functions must be designated
as `.type <function-name>, %function`. Without such designation the GCC linker
reports the following error:

```
dangerous relocation: unsupported relocation
```
