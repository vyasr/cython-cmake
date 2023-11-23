cmake_minimum_required(VERSION 3.15...3.26)
project(example_project LANGUAGES C)

find_package(
  Python
  COMPONENTS Interpreter Development.Module
  REQUIRED)

if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/CYTHON_CMAKE.cmake)
  file(
    DOWNLOAD
    https://raw.githubusercontent.com/vyasr/cython-cmake/main/CYTHON_CMAKE.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/CYTHON_CMAKE.cmake)
endif()
include(${CMAKE_CURRENT_BINARY_DIR}/CYTHON_CMAKE.cmake)

find_package(cython REQUIRED)
cython(SOURCE_FILES example.pyx)

python_add_library(example MODULE "${CMAKE_CURRENT_BINARY_DIR}/example.c"
                   WITH_SOABI)

install(TARGETS example DESTINATION .)
