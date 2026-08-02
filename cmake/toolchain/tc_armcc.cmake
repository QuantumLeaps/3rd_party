# Append current directory to CMAKE_MODULE_PATH for making device specific cmake modules visible
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# Target definition
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)
# set(CMAKE_C_COMPILER_ID GNU)
# set(CMAKE_CXX_COMPILER_ID GNU)

#---------------------------------------------------------------------------------------
# Set toolchain paths
#---------------------------------------------------------------------------------------
set(TOOLCHAIN_PREFIX arm)

# check if toolchain can be found in standard PATH
find_path(TOOLCHAIN_PATH
    NAMES
        ${TOOLCHAIN_PREFIX}clang ${TOOLCHAIN_PREFIX}clang.exe
    PATH_SUFFIXES
        bin
    NO_CACHE
)
if(NOT TOOLCHAIN_PATH)
    message(FATAL_ERROR "'${TOOLCHAIN_PREFIX}clang' cannot be found in 'PATH' env variable! - ABORT -")
endif()

#---------------------------------------------------------------------------------------
# Set compilers
#---------------------------------------------------------------------------------------
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}clang CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}clang CACHE INTERNAL "C++ Compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}clang CACHE INTERNAL "ASM Compiler")
set(CMAKE_OBJCOPY fromelf CACHE INTERNAL "ARM objcopy replacement")
set(CMAKE_SIZE ${CMAKE_OBJCOPY} CACHE INTERNAL "ARM size replacement")

# toolchain creates ELF executables
set(CMAKE_EXECUTABLE_SUFFIX_ASM     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C       ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX     ".elf")

# Perform compiler test with static library
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#---------------------------------------------------------------------------------------
# Set compiler/linker flags
#---------------------------------------------------------------------------------------

# Object build options
# -O0                   No optimizations, reduce compilation time and make debugging produce the expected results.
# -mthumb               Generat thumb instructions.
# -fno-builtin          Do not use built-in functions provided by GCC.
# -Wall                 Print only standard warnings, for all use Wextra
# -ffunction-sections   Place each function item into its own section in the output file.
# -fdata-sections       Place each data item into its own section in the output file.
# -fomit-frame-pointer  Omit the frame pointer in functions that don’t need one.
# -mabi=aapcs           Defines enums to be a variable sized type.
set(OBJECT_GEN_FLAGS "--target=arm-arm-none-eabi -mthumb -D__MICROLIB -nostdlib  -Wall -fno-builtin")
set(OBJECT_GEN_FLAGS "${OBJECT_GEN_FLAGS} -ffunction-sections -fdata-sections -fomit-frame-pointer")
set(OBJECT_GEN_FLAGS "${OBJECT_GEN_FLAGS} -fmessage-length=0 -funsigned-char -fshort-enums -fshort-wchar  -D__MICROLIB")
set(OBJECT_LNK_FLAGS "--library-type=microlib -mthumb --strict --summary_stderr --info summarysizes --info sizes --info totals")
 set(OBJECT_LNK_FLAGS "${OBJECT_LNK_FLAGS} --info unused --info veneers")

set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS}" CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} -fno-rtti -fno-exceptions -fno-threadsafe-statics" CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "${OBJECT_GEN_FLAGS} -x assembler-with-cpp -masm=gnu -MMD -MP" CACHE INTERNAL "ASM Compiler options")
set(CMAKE_EXE_LINKER_FLAGS "${OBJECT_LNK_FLAGS} --map --load_addr_map_info --xref --callgraph --symbols" CACHE INTERNAL "LINK Linker options")

#---------------------------------------------------------------------------------------
# Set debug/release build configuration Options
#---------------------------------------------------------------------------------------

# Options for DEBUG build
# -Og   Enables optimizations that do not interfere with debugging.
# -g    Produce debugging information in the operating system’s native format.
# use '-Os' optimization also for debug builds on 32k TDK chips. Standard should be '-O0' or '-O1'
set(CMAKE_C_FLAGS_DEBUG "--debug -gdwarf-4 -Oz" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_DEBUG "--debug -gdwarf-4 -Oz" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_ASM_FLAGS_DEBUG "--debug -gdwarf-4 -Oz" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_C_LINK_FLAGS_DEBUG "--debug" CACHE INTERNAL "Linker options for debug build type")
set(CMAKE_CXX_LINK_FLAGS_DEBUG "${CMAKE_C_LINK_FLAGS_DEBUG}" CACHE INTERNAL "Linker options for debug build type")

# Options for SPY build are identical to DEBUG build
set(CMAKE_C_FLAGS_SPY "${CMAKE_C_FLAGS_DEBUG} -DQ_SPY=1" CACHE INTERNAL "C Compiler options for spy build type")
set(CMAKE_CXX_FLAGS_SPY "${CMAKE_CXX_FLAGS_DEBUG} -DQ_SPY=1" CACHE INTERNAL "C++ Compiler options for spy build type")
set(CMAKE_ASM_FLAGS_SPY "${CMAKE_ASM_FLAGS_DEBUG} -DQ_SPY=1" CACHE INTERNAL "ASM Compiler options for spy build type")
set(CMAKE_C_LINK_FLAGS_SPY "${CMAKE_C_LINK_FLAGS_DEBUG}" CACHE INTERNAL "Linker options for spy build type")
set(CMAKE_CXX_LINK_FLAGS_SPY "${CMAKE_CXX_LINK_FLAGS_DEBUG}" CACHE INTERNAL "Linker options for spy build type")

# Options for RELEASE build
# -Os   Optimize for size. -Os enables all -O2 optimizations.
# -flto Runs the standard link-time optimizer.
set(CMAKE_C_FLAGS_RELEASE "-Oz -g0" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_RELEASE "-Oz -g0" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_ASM_FLAGS_RELEASE "-Oz -g0" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_C_LINK_FLAGS_RELEASE "-Omin --no_debug" CACHE INTERNAL "Linker options for release build type")
set(CMAKE_CXX_LINK_FLAGS_RELEASE "${CMAKE_C_LINK_FLAGS_RELEASE}" CACHE INTERNAL "Linker options for release build type")

#---------------------------------------------------------------------------------------
# Set FIND strategies
#---------------------------------------------------------------------------------------
set(CMAKE_FIND_ROOT_PATH  ${TOOLCHAIN_PATH})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
