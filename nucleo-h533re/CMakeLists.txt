#============================================================================
# NUCLEO-H533RE board (STM32H533RE, ARM Cortex-M33 with FPU) -- CMake support
#
# Usage in the application's CMakeLists.txt:
#
#   add_subdirectory(<qp>/3rd_party/nucleo-h533re nucleo-h533re)
#   target_link_libraries(qpc_config INTERFACE nucleo-h533re::cpu) # for QP (qpcpp: qpcpp_config)
#   target_link_libraries(<app> PRIVATE nucleo-h533re)             # for app
#   link_image(<app> <linker-script>)   # .elf, .map, .bin (see ../cmake)
#
# nucleo-h533re::cpu  CPU flags, device define and include directories
# nucleo-h533re       the above + the startup and system code
#
# Compilers: GNU-ARM, ARMClang (Keil). For ARMClang, the startup code
# reserves the stack and heap; the application can set their sizes with
# BOARD_STACK_SIZE and BOARD_HEAP_SIZE (default: 2048 and 16 bytes) before
# add_subdirectory(). (The stack size must match the scatter file.)
#============================================================================

# CPU flags, device define, include directories .............................
add_library(nucleo-h533re_cpu INTERFACE)
add_library(nucleo-h533re::cpu ALIAS nucleo-h533re_cpu)

target_compile_definitions(nucleo-h533re_cpu INTERFACE STM32H533xx)
cmake_path(SET _cmsis NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/../CMSIS/Include)
target_include_directories(nucleo-h533re_cpu INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_cmsis}
)

if(CMAKE_C_COMPILER_ID STREQUAL "GNU") #------------------------------ GNU-ARM
    set(_cpu -mcpu=cortex-m33 -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb)
    target_compile_options(nucleo-h533re_cpu INTERFACE ${_cpu})
    target_link_options(nucleo-h533re_cpu INTERFACE ${_cpu}) # selects libc
    set(_startup gnu/startup_stm32h533retx.c)

elseif(CMAKE_C_COMPILER_ID STREQUAL "ARMClang") #------------- ARMClang (Keil)
    target_compile_options(nucleo-h533re_cpu INTERFACE
        "$<$<COMPILE_LANGUAGE:C,CXX>:-mcpu=cortex-m33;-mfpu=fpv5-sp-d16;-mfloat-abi=hard>"
        "$<$<COMPILE_LANGUAGE:ASM>:--cpu=Cortex-M33;--fpu=FPv5-SP>"       # armasm
    )
    target_link_options(nucleo-h533re_cpu INTERFACE --cpu=Cortex-M33 --fpu=FPv5-SP) # armlink

    enable_language(ASM)              # the startup code is in assembly
    set(_startup arm/startup_stm32h533retx.s)
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
    message(FATAL_ERROR "nucleo-h533re: compiler '${CMAKE_C_COMPILER_ID}' "
        "not supported yet")
endif()

# startup and system code ...................................................
# (an OBJECT library: its object files go directly into the application)
add_library(nucleo-h533re OBJECT
    system_stm32h5xx.c
    ${_startup}
)
target_link_libraries(nucleo-h533re PUBLIC nucleo-h533re_cpu)
target_compile_options(nucleo-h533re PRIVATE ${_asm_opts})

# link_image() for the application .........................................
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/link_image.cmake)
