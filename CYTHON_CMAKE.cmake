# This file provides a convenient entrypoint for using the CMake functions in
# this package without installing the cython-cmake Python package.

set(CYTHON_CMAKE_URL
    https://github.com/vyasr/cython-cmake/archive/refs/heads/main.zip)

include(FetchContent)

if(POLICY CMP0135)
  cmake_policy(PUSH)
  cmake_policy(SET CMP0135 NEW)
endif()
FetchContent_Declare(cython-cmake URL "${CYTHON_CMAKE_URL}")
if(POLICY CMP0135)
  cmake_policy(POP)
endif()

FetchContent_GetProperties(rapids-cmake)
if(NOT cython-cmake_POPULATED)
  FetchContent_MakeAvailable(cython-cmake)
  set(CYTHON_CMAKE_DIR "${cython-cmake_SOURCE_DIR}")
endif()

# Set up the CMAKE_MODULE_PATH
if(NOT "${CYTHON_CMAKE_DIR}/cmake" IN_LIST CMAKE_MODULE_PATH)
  list(APPEND CMAKE_MODULE_PATH "${CYTHON_CMAKE_DIR}/cmake")
endif()
