# This file provides a convenient entrypoint for using the CMake functions in
# this package without installing the cython-cmake Python package.


set(cython-cmake-url https://github.com/vyasr/cython-cmake/archive/refs/heads/main.zip)

include(FetchContent)

if(POLICY CMP0135)
  cmake_policy(PUSH)
  cmake_policy(SET CMP0135 NEW)
endif()
FetchContent_Declare(cython-cmake URL "${cython-cmake-url}")
if(POLICY CMP0135)
  cmake_policy(POP)
endif()

FetchContent_GetProperties(rapids-cmake)
if(NOT cython-cmake_POPULATED)
  FetchContent_MakeAvailable(cython-cmake)
  set(cython-cmake-dir "${cython-cmake_SOURCE_DIR}")
endif()

# Set up the CMAKE_MODULE_PATH
if(NOT "${cython-cmake-dir}/cmake" IN_LIST CMAKE_MODULE_PATH)
  list(APPEND CMAKE_MODULE_PATH "${cython-cmake-dir}/cmake")
endif()
