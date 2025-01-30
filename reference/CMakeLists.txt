#
# Copyright 2020-2025 Comcast Cable Communications Management, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.16)

project(tasecureapi)

option(BUILD_TESTS "Builds and installs the unit tests" ON)
option(BUILD_DOC "Build documentation" ON)
option(ENABLE_CLANG_TIDY "Enable clang-tidy for targets" ON)
option(ENABLE_CLANG_TIDY_TEST "Enable clang-tidy for test targets" ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

find_program(CLANG_TIDY_EXECUTABLE clang-tidy)
if(CLANG_TIDY_EXECUTABLE)
  message(STATUS "Found clang-tidy: ${CLANG_TIDY_EXECUTABLE}")
  list(APPEND CLANG_TIDY_COMMAND_LINE "${CLANG_TIDY_EXECUTABLE}")
else()
  message(STATUS "Missing clang-tidy")
endif()

find_program(CLANG_FORMAT_EXECUTABLE clang-format)
if(CLANG_FORMAT_EXECUTABLE)
  message(STATUS "Found clang-format: ${CLANG_FORMAT_EXECUTABLE}")
else()
  message(STATUS "Missing clang-format")
endif()

if(BUILD_TESTS)
    include(FetchContent)

    # Download and unpack googletest at configure time
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.15.2
    )
    FetchContent_MakeAvailable(googletest)

    # The following line is a hack to avoid adding a bunch of CTest targets to
    # the build. By setting this internal property used by the CTest module and
    # its dependencies, it skips the generation of the extra targets. This
    # property could change in the future.
    # - https://stackoverflow.com/a/57240389
    set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)
    include(CTest)
    include(GoogleTest)
endif()

add_subdirectory(src)
