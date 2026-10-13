#============================================================================
# link_image(<target> <linker-script>)
#
# For bare-metal executables (with or without an RTOS): links <target> with
# <linker-script> (GNU: .ld, ARMClang: scatter file .sct), writes the map
# file <target>.map, prints the memory usage, and produces the binary image
# <target>.bin (for drag-and-drop flashing) next to the executable
# <target>.elf. What gets linked in is decided by target_link_libraries().
#
# Depends only on the compiler (GNU or ARMClang); shared by qpc and qpcpp.
#============================================================================
include_guard(GLOBAL)

if(COMMAND link_image)
    message(WARNING "link_image(): a command with this name already exists "
        "and is now replaced (${CMAKE_CURRENT_LIST_FILE})")
endif()

function(link_image tgt script)
    set(_out ${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/${tgt})
    set_target_properties(${tgt} PROPERTIES
        SUFFIX ".elf"
        LINK_DEPENDS ${script}             # relink when the script changes
    )

    if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
        target_link_options(${tgt} PRIVATE
            -T${script}
            -Wl,-Map=${_out}.map
            -Wl,--print-memory-usage
        )
        set(_bin_cmd ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${tgt}> ${_out}.bin)

    elseif(CMAKE_C_COMPILER_ID STREQUAL "ARMClang")
        # armlink options
        target_link_options(${tgt} PRIVATE
            --scatter=${script}
            --entry=Reset_Handler
            --map --list=${_out}.map        # the map goes into the file
            --info=summarysizes
            --summary_stderr                # also show the summary
        )
        cmake_path(GET CMAKE_C_COMPILER PARENT_PATH _bin)
        find_program(_fromelf fromelf HINTS ${_bin} NO_CACHE REQUIRED)
        set(_bin_cmd ${_fromelf} --bin --output=${_out}.bin $<TARGET_FILE:${tgt}>)

    else()
        message(FATAL_ERROR "link_image(): compiler "
            "'${CMAKE_C_COMPILER_ID}' not supported yet")
    endif()

    add_custom_command(TARGET ${tgt} POST_BUILD
        COMMAND ${_bin_cmd}
        BYPRODUCTS ${_out}.bin
        VERBATIM
    )
endfunction()
