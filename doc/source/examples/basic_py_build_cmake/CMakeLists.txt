cmake_minimum_required(VERSION 3.15...3.26)
project(cython_cmake LANGUAGES C)

find_package(
  Python
  COMPONENTS Interpreter Development.Module
  REQUIRED)

# Grab the location of the CMake find module via the Python package.
execute_process(
  COMMAND
    "${Python_EXECUTABLE}" -c
    "import cython_cmake; import os; print(os.path.dirname(cython_cmake.__file__))"
  OUTPUT_VARIABLE CYTHON_CMAKE_INCLUDE_DIR
  OUTPUT_STRIP_TRAILING_WHITESPACE)
list(APPEND CMAKE_MODULE_PATH "${CYTHON_CMAKE_INCLUDE_DIR}")

find_package(cython REQUIRED)
cython(SOURCE_FILES example/example.pyx)

python_add_library(example MODULE
                   "${CMAKE_CURRENT_BINARY_DIR}/example/example.c" WITH_SOABI)

install(TARGETS example DESTINATION example/)
