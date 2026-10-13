#============================================================================
# CMake toolchain file for ARM Compiler 6 (armclang), as in Keil MDK
#
# The compiler is located:
#   1. -DARMCLANG=<dir>             (on the command line or in a preset)
#   2. the ARMCLANG environment variable
#   3. the default Keil MDK location C:/Keil_v5/ARM/ARMCLANG (Windows only)
#   4. otherwise, the PATH
# where <dir> is the ARMCLANG directory (the one containing bin/armclang).
# An ARMCLANG given in 1. or 2. must be right: there is no fallback to the
# PATH, so that a wrong setting cannot silently select another compiler.
#
# This file only selects the compiler. The CPU flags (-mcpu=..., FPU) come
# from the board, and the project flags from the application.
#============================================================================

set(CMAKE_SYSTEM_NAME Generic)       # bare-metal, no operating system
set(CMAKE_SYSTEM_PROCESSOR arm)

# locate the toolchain ......................................................
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(_exe ".exe")
endif()

if(NOT "${ARMCLANG}" STREQUAL "")
    file(TO_CMAKE_PATH "${ARMCLANG}" _dir)
    set(_src "from -DARMCLANG")
    set(_strict TRUE)
elseif(NOT "$ENV{ARMCLANG}" STREQUAL "")
    file(TO_CMAKE_PATH "$ENV{ARMCLANG}" _dir)
    set(_src "from the ARMCLANG environment variable")
    set(_strict TRUE)
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(_dir "C:/Keil_v5/ARM/ARMCLANG")
    set(_src "the default Keil MDK location, as ARMCLANG is not set")
    set(_strict FALSE)
else() # no default location outside Windows
    set(_dir "")
    set(_strict FALSE)
endif()

# forgive stray quotes and spaces, e.g. from: set ARMCLANG="C:\..."
string(REGEX REPLACE "^[ \t\"]+|[ \t\"]+$" "" _dir "${_dir}")

if(_strict)
    find_program(_armclang armclang PATHS "${_dir}/bin" NO_DEFAULT_PATH NO_CACHE)
elseif(_dir)
    find_program(_armclang armclang HINTS "${_dir}/bin" NO_CACHE)
else()
    find_program(_armclang armclang NO_CACHE) # only the PATH
endif()

if(NOT _armclang) # explain the problem as precisely as possible...
    # paths in the message as the user would type them (C:\... on Windows)
    string(REGEX REPLACE "/+$" "" _dir "${_dir}")
    file(TO_NATIVE_PATH "${_dir}" _n)
    file(TO_NATIVE_PATH "${_dir}/bin" _nbin)
    file(TO_NATIVE_PATH "bin/armclang${_exe}" _nexe)
    if(_strict)
        set(_msg "armclang not found in ${_nbin} (${_src}).")
    elseif(_dir)
        set(_msg "armclang not found in ${_nbin} (${_src}), "
                 "nor on the PATH.")
    else()
        set(_msg "armclang not found on the PATH (ARMCLANG is not set).")
    endif()
    if(_dir AND EXISTS "${_dir}/armclang${_exe}")
        cmake_path(GET _dir PARENT_PATH _p)
        file(TO_NATIVE_PATH "${_p}" _p)
        list(APPEND _msg "\n${_n} is the bin directory itself. "
            "ARMCLANG must be its parent directory: ${_p}")
    elseif(_dir AND EXISTS "${_dir}/ARM/ARMCLANG/bin/armclang${_exe}")
        file(TO_NATIVE_PATH "${_dir}/ARM/ARMCLANG" _p)
        list(APPEND _msg "\n${_n} is the Keil MDK directory. "
            "ARMCLANG must be: ${_p}")
    endif()
    message(FATAL_ERROR ${_msg} "\n"
        "Set ARMCLANG to the ARMCLANG directory of your Keil MDK "
        "installation (the one that contains ${_nexe}), "
        "for example:\n"
        "   set ARMCLANG=C:\\Keil_v5\\ARM\\ARMCLANG\n"
        "(permanently: in the Windows environment variables), "
        "or on the command line:\n"
        "   cmake --preset <preset> --fresh -DARMCLANG=C:/Keil_v5/ARM/ARMCLANG\n"
        "(Any errors below, for example about Ninja or CMAKE_C_COMPILER, are only "
        "a consequence of this one.)")
endif()
cmake_path(GET _armclang PARENT_PATH _armclang_bin)

set(CMAKE_C_COMPILER   "${_armclang}")
set(CMAKE_CXX_COMPILER "${_armclang}")
set(CMAKE_C_COMPILER_TARGET   arm-arm-none-eabi)
set(CMAKE_CXX_COMPILER_TARGET arm-arm-none-eabi)

# the CMSIS startup files for Keil are in the legacy armasm syntax,
# so the assembler is armasm (not armclang)
set(CMAKE_ASM_COMPILER "${_armclang_bin}/armasm${_exe}")
set(CMAKE_ASM_COMPILER_ID ARMCC)     # armasm command line (not armclang's)

# armasm (Keil MDK 5.37+) warns on every file that it is deprecated:
# "A1950W: The legacy armasm assembler is deprecated..." -- harmless, silenced
set(CMAKE_ASM_FLAGS_INIT "--diag_suppress=A1950")

# armclang cannot compile anything without a CPU (-mcpu=...), which comes
# from the board, after this point. Therefore CMake's compiler test (which
# compiles a small file) is skipped. (The compiler is still identified.)
set(CMAKE_C_COMPILER_FORCED   TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)
