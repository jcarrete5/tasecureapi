# Copyright Tomas Zeman 2019-2020.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

function(prefix_clangformat_setup prefix)
    set(target "${prefix}_clangformat")

    if(NOT CLANG_FORMAT_EXECUTABLE)
        # Avoid adding targets that use clang-format if it doesn't exist
        return()
    endif()

    foreach(source_file ${ARGN})
        get_filename_component(source_file_path "${source_file}" ABSOLUTE)
        list(APPEND sources "${source_file_path}")
    endforeach()

    add_custom_target(
        "${target}"
        COMMAND "${CLANG_FORMAT_EXECUTABLE}" --style=file -i ${sources}
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        COMMENT "Formatting ${prefix} with ${CLANG_FORMAT_EXECUTABLE} ..."
    )

    if(TARGET clangformat)
        add_dependencies(clangformat "${target}")
    else()
        add_custom_target(clangformat DEPENDS "${target}")
    endif()
endfunction()

function(clangformat_setup)
    prefix_clangformat_setup(${PROJECT_NAME} ${ARGN})
endfunction()

function(target_clangformat_setup target)
    get_target_property(target_sources ${target} SOURCES)
    prefix_clangformat_setup(${target} ${target_sources})
endfunction()
