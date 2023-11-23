============
cython-cmake
============

|GitHub-Actions|
|GitHub-Stars|

.. |GitHub-Actions| image:: https://github.com/vyasr/cython-cmake/workflows/test/badge.svg
   :target: https://github.com/vyasr/cython-cmake/actions
.. |GitHub-Stars| image:: https://img.shields.io/github/stars/vyasr/cython-cmake.svg?style=social
   :target: https://github.com/vyasr/cython-cmake


This package provides a standard interface to building Cython from CMake.
It assumes that users will rely on CMake's facilities for compiling the generated C/C++ code and focuses only on enabling transpilation.
This package supports multiple approaches to make it as easy as possible to integrate into existing builds regardless of the choice of build backend.
