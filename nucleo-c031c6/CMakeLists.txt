#============================================================================
# NUCLEO-C031C6 board (STM32C031C6, ARM Cortex-M0+) -- CMake support
#
# Usage in the application's CMakeLists.txt:
#
#   add_subdirectory(<qp>/3rd_party/nucleo-c031c6 nucleo-c031c6)
#   target_link_libraries(qpc_config INTERFACE nucleo-c031c6::cpu) # for QP (qpcpp: qpcpp_config)
#   target_link_libraries(<app> PRIVATE nucleo-c031c6)             # for app
#   link_image(<app> <linker-script>)   # .elf, .map, .bin (see ../cmake)
#
# nucleo-c031c6::cpu  CPU flags, device define and include directories
# nucleo-c031c6       the above + the startup and system code
#
# Compilers: GNU-ARM, ARMClang (Keil). For ARMClang, the startup code
# reserves the stack and heap; the application can set their sizes with
# BOARD_STACK_SIZE and BOARD_HEAP_SIZE (default: 2048 and 16 bytes) before
# add_subdirectory(). (The stack size must match the scatter file.)
#============================================================================

# CPU flags, device define, include directories .............................
add_library(nucleo-c031c6_cpu INTERFACE)
add_library(nucleo-c031c6::cpu ALIAS nucleo-c031c6_cpu)

target_compile_definitions(nucleo-c031c6_cpu INTERFACE STM32C031xx)
cmake_path(SET _cmsis NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/../CMSIS/Include)
target_include_directories(nucleo-c031c6_cpu INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_cmsis}
)

if(CMAKE_C_COMPILER_ID STREQUAL "GNU") #------------------------------ GNU-ARM
    set(_cpu -mcpu=cortex-m0plus -mthumb)
    target_compile_options(nucleo-c031c6_cpu INTERFACE ${_cpu})
    target_link_options(nucleo-c031c6_cpu INTERFACE ${_cpu}) # selects libc
    set(_startup gnu/startup_stm32c031xx.c)

elseif(CMAKE_C_COMPILER_ID STREQUAL "ARMClang") #------------- ARMClang (Keil)
    target_compile_options(nucleo-c031c6_cpu INTERFACE
        "$<$<COMPILE_LANGUAGE:C,CXX>:-mcpu=cortex-m0plus>"
        "$<$<COMPILE_LANGUAGE:ASM>:--cpu=Cortex-M0plus>"       # armasm
    )
    target_link_options(nucleo-c031c6_cpu INTERFACE --cpu=Cortex-M0plus) # armlink

    enable_language(ASM)              # the startup code is in assembly
    set(_startup arm/startup_stm32c031xx.s)
    if(NOT DEFINED BOARD_STACK_SIZE)
        set(BOARD_STACK_SIZE 2048)
    endif()
    if(NOT DEFINED BOARD_HEAP_SIZE)
        set(BOARD_HEAP_SIZE 16)
    endif()
    set(_asm_opts # armasm options for the startup code
        "$<$<COMPILE_LANGUAGE:ASM>:SHELL:--pd \"Stack_Size SETA ${BOARD_STACK_SIZE}\">"
        "$<$<COMPILE_LANGUAGE:ASM>:SHELL:--pd \"Heap_Size SETA ${BOARD_HEAP_SIZE}\">"
    )

else()
    message(FATAL_ERROR "nucleo-c031c6: compiler '${CMAKE_C_COMPILER_ID}' "
        "not supported yet")
endif()

# startup and system code ...................................................
# (an OBJECT library: its object files go directly into the application)
add_library(nucleo-c031c6 OBJECT
    system_stm32c0xx.c
    ${_startup}
)
target_link_libraries(nucleo-c031c6 PUBLIC nucleo-c031c6_cpu)
target_compile_options(nucleo-c031c6 PRIVATE ${_asm_opts})

# link_image() for the application .........................................
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/link_image.cmake)
