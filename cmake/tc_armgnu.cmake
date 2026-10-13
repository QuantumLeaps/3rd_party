#============================================================================
# CMake toolchain file for the GNU-ARM (arm-none-eabi) cross-compiler
#
# The compiler is located like in the QP Makefiles:
#   1. -DGNU_ARM=<dir>              (on the command line or in a preset)
#   2. the GNU_ARM environment variable
#   3. the QTOOLS environment variable: %QTOOLS%/gnu_arm-none-eabi
#      (QTOOLS is set by the QP-bundle installer)
#   4. otherwise, the PATH
# where <dir> is the GNU-ARM directory (the one containing
# bin/arm-none-eabi-gcc). A GNU_ARM given in 1. or 2. must be right: there
# is no fallback to the PATH, so that a wrong setting cannot silently
# select another compiler.
#
# This file only selects the compiler and sets compiler-generic defaults
# for bare-metal builds. The CPU flags (-mcpu=..., FPU) come from the board,
# and the project flags from the application.
#============================================================================

set(CMAKE_SYSTEM_NAME Generic)       # bare-metal, no operating system
set(CMAKE_SYSTEM_PROCESSOR arm)

# locate the toolchain ......................................................
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(_exe ".exe")
endif()

set(_strict FALSE)
if(NOT "${GNU_ARM}" STREQUAL "")
    file(TO_CMAKE_PATH "${GNU_ARM}" _dir)
    set(_src "from -DGNU_ARM")
    set(_strict TRUE)
elseif(NOT "$ENV{GNU_ARM}" STREQUAL "")
    file(TO_CMAKE_PATH "$ENV{GNU_ARM}" _dir)
    set(_src "from the GNU_ARM environment variable")
    set(_strict TRUE)
elseif(NOT "$ENV{QTOOLS}" STREQUAL "")
    file(TO_CMAKE_PATH "$ENV{QTOOLS}/gnu_arm-none-eabi" _dir)
    set(_src "from the QTOOLS environment variable, as GNU_ARM is not set")
else()
    set(_dir "")
endif()

# forgive stray quotes and spaces, e.g. from: set GNU_ARM="C:\..."
string(REGEX REPLACE "^[ \t\"]+|[ \t\"]+$" "" _dir "${_dir}")

if(_strict)
    find_program(_arm_gcc arm-none-eabi-gcc PATHS "${_dir}/bin"
        NO_DEFAULT_PATH NO_CACHE)
elseif(_dir)
    find_program(_arm_gcc arm-none-eabi-gcc HINTS "${_dir}/bin" NO_CACHE)
else()
    find_program(_arm_gcc arm-none-eabi-gcc NO_CACHE) # only the PATH
endif()

if(NOT _arm_gcc) # explain the problem as precisely as possible...
    # paths in the message as the user would type them (C:\... on Windows)
    string(REGEX REPLACE "/+$" "" _dir "${_dir}")
    file(TO_NATIVE_PATH "${_dir}" _n)
    file(TO_NATIVE_PATH "${_dir}/bin" _nbin)
    file(TO_NATIVE_PATH "bin/arm-none-eabi-gcc${_exe}" _nexe)
    if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        set(_nqt "%QTOOLS%\\gnu_arm-none-eabi")
    else()
        set(_nqt "$QTOOLS/gnu_arm-none-eabi")
    endif()
    if(_strict)
        set(_msg "arm-none-eabi-gcc not found in ${_nbin} (${_src}).")
    elseif(_dir)
        set(_msg "arm-none-eabi-gcc not found in ${_nbin} (${_src}), "
                 "nor on the PATH.")
    else()
        set(_msg "arm-none-eabi-gcc not found on the PATH "
                 "(GNU_ARM and QTOOLS are not set).")
    endif()
    if(_dir AND EXISTS "${_dir}/arm-none-eabi-gcc${_exe}")
        cmake_path(GET _dir PARENT_PATH _p)
        file(TO_NATIVE_PATH "${_p}" _p)
        list(APPEND _msg "\n${_n} is the bin directory itself. "
            "GNU_ARM must be its parent directory: ${_p}")
    endif()
    message(FATAL_ERROR ${_msg} "\n"
        "Set GNU_ARM to the GNU-ARM directory (the one that contains "
        "${_nexe}), for example:\n"
        "   set GNU_ARM=C:\\qp\\qtools\\gnu_arm-none-eabi\n"
        "(permanently: in the Windows environment variables), "
        "or on the command line:\n"
        "   cmake --preset <preset> --fresh -DGNU_ARM=C:/qp/qtools/gnu_arm-none-eabi\n"
        "(QTOOLS, set by the QP-bundle installer, also works: then "
        "${_nqt} is used.)\n"
        "(Any errors below, for example about Ninja or CMAKE_C_COMPILER, are only "
        "a consequence of this one.)")
endif()
cmake_path(GET _arm_gcc PARENT_PATH _arm_bin)

set(CMAKE_C_COMPILER   "${_arm_gcc}")
set(CMAKE_CXX_COMPILER "${_arm_bin}/arm-none-eabi-g++${_exe}")
set(CMAKE_ASM_COMPILER "${_arm_gcc}")

# test the compiler by building a static library (an executable cannot be
# linked without a startup file and a linker script)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# compiler-generic defaults for bare-metal (*_INIT: the starting values of
# CMAKE_C_FLAGS etc., which the application can still change) ..............
set(CMAKE_C_FLAGS_INIT   "-ffunction-sections -fdata-sections")
set(CMAKE_CXX_FLAGS_INIT "-ffunction-sections -fdata-sections -fno-rtti -fno-exceptions")
set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nano.specs --specs=nosys.specs -Wl,--gc-sections")
