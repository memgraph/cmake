# Memgraph CMake

This is a collection of CMake modules that are useful for all Memgraph
projects.

[CMake Guidelines](https://docs.salome-platform.org/latest/dev/cmake/html/various.html)

Possible usage:
```
file(DOWNLOAD https://github.com/memgraph/cmake/blob/main/modules/external-boost.cmake
    ${CMAKE_BINARY_DIR}/external-boost.cmake)
include(${CMAKE_BINARY_DIR}/external-boost.cmake)
```
