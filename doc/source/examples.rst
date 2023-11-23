========
Examples
========

.. contents:: List of Examples

Using with a supported build backend
====================================

The easiest way to use cython-cmake is to install the Python package and leverage a build backend like `scikit-build-core <https://scikit-build-core.readthedocs.io/>`__ that automatically supports its CMake modules.
With this approach, you can simply find the Cython module and execute the command:

.. literalinclude :: examples/basic_use_package/CMakeLists.txt
   :language: cmake


Using directly via CMake
========================

If for some reason you need access to Cython outside the context of a normal Python package build, or if you simply prefer to rely on raw CMake, the project may be fetched and used directly via the helpful CYTHON_CMAKE.cmake module:

.. literalinclude :: examples/basic_direct_download/CMakeLists.txt
   :language: cmake
