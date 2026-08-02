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
set(TOOLCHAIN_PREFIX arm-none-eabi)

# check if toolchain can be found in standard PATH
find_path(TOOLCHAIN_PATH
    NAMES
        ${TOOLCHAIN_PREFIX}-gcc ${TOOLCHAIN_PREFIX}-gcc.exe
    PATH_SUFFIXES
        bin
    NO_CACHE
)
if(NOT TOOLCHAIN_PATH)
    message(FATAL_ERROR "'${TOOLCHAIN_PREFIX}-gcc' cannot be found in 'PATH' env variable! - ABORT -")
endif()

#---------------------------------------------------------------------------------------
# Set compilers
#---------------------------------------------------------------------------------------
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++ CACHE INTERNAL "C++ Compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}-gcc CACHE INTERNAL "ASM Compiler")
set(CMAKE_SIZE ${TOOLCHAIN_PREFIX}-size CACHE INTERNAL "GNU size for arm")

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
set(OBJECT_GEN_FLAGS "-mthumb -Wall -Wextra -Wpedantic -fno-builtin")
set(OBJECT_GEN_FLAGS "${OBJECT_GEN_FLAGS} -ffunction-sections -fdata-sections -fomit-frame-pointer")
set(OBJECT_GEN_FLAGS "${OBJECT_GEN_FLAGS} -fmessage-length=0 -funsigned-char -fshort-enums")
# set(OBJECT_GEN_FLAGS "${OBJECT_GEN_FLAGS} -fmessage-length=0 -funsigned-char -fshort-enums -fshort-wchar")

set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS}" CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} -fno-rtti -fno-exceptions -fno-threadsafe-statics" CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "${OBJECT_GEN_FLAGS} -x assembler-with-cpp -MMD -MP" CACHE INTERNAL "ASM Compiler options")


# -Wl,--gc-sections       Perform the dead code elimination.
# --specs=nano.specs      Link with newlib-nano.
# --specs=nosys.specs     No syscalls, provide empty implementations for the POSIX system calls.
# --specs=picolibc.specs  Link with picolibc
# set(CMAKE_C_LINK_FLAGS "-mthumb -mfloat-abi=soft -nostartfiles -static --specs=nano.specs --specs=nosys.specs")
set(CMAKE_C_LINK_FLAGS "-mthumb -mfloat-abi=soft -static --specs=nano.specs --specs=nosys.specs")
# set(CMAKE_C_LINK_FLAGS "-mthumb -nostartfiles -static --specs=picolibc.specs --specs=nosys.specs -flto")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -Wl,--gc-sections,--cref,--print-memory-usage")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -Wl,--start-group -lc -lm -Wl,--end-group")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS}" CACHE INTERNAL "Linker options")

set(CMAKE_CXX_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -Wl,--start-group -lstdc++ -lsupc++ -Wl,--end-group")

#---------------------------------------------------------------------------------------
# Set debug/release build configuration Options
#---------------------------------------------------------------------------------------

# Options for DEBUG build
# -Og   Enables optimizations that do not interfere with debugging.
# -g    Produce debugging information in the operating system’s native format.
set(CMAKE_C_FLAGS_DEBUG "-gdwarf-4 -O0 -fstack-usage" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_DEBUG "-gdwarf-4 -O0" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_ASM_FLAGS_DEBUG "-gdwarf-4 -O0" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_C_LINK_FLAGS_DEBUG "-gdwarf-4 -O0" CACHE INTERNAL "Linker options for debug build type")
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
set(CMAKE_C_FLAGS_RELEASE "-gdwarf-4 -Os" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_RELEASE "-gdwarf-4 -Os" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_ASM_FLAGS_RELEASE "-gdwarf-4 -Os" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_C_LINK_FLAGS_RELEASE "-gdwarf-4 -Os" CACHE INTERNAL "Linker options for release build type")
set(CMAKE_CXX_LINK_FLAGS_RELEASE "${CMAKE_C_LINK_FLAGS_RELEASE}" CACHE INTERNAL "Linker options for release build type")

#---------------------------------------------------------------------------------------
# Set FIND strategies
#---------------------------------------------------------------------------------------
set(CMAKE_FIND_ROOT_PATH  ${TOOLCHAIN_PATH})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
