cmake_minimum_required(VERSION 3.15...3.26)
project(${SKBUILD_PROJECT_NAME} LANGUAGES C)

find_package(
  Python
  COMPONENTS Interpreter Development.Module
  REQUIRED)

find_package(cython REQUIRED)
cython(SOURCE_FILES example.pyx)

python_add_library(example MODULE "${CMAKE_CURRENT_BINARY_DIR}/example.c"
                   WITH_SOABI)

install(TARGETS example DESTINATION .)
