# Memgraph CMake

This is a collection of CMake modules that are useful for all Memgraph
projects.

Possible usage:
```
include(FetchContent)
include(ExternalProject)

file(DOWNLOAD https://raw.githubusercontent.com/memgraph/cmake/main/modules/external-boost.cmake
     ${CMAKE_BINARY_DIR}/external-boost.cmake)
include(${CMAKE_BINARY_DIR}/external-boost.cmake)

file(DOWNLOAD https://raw.githubusercontent.com/memgraph/cmake/main/modules/fetch-nlohmann.cmake
     ${CMAKE_BINARY_DIR}/fetch-nlohmann.cmake)
include(${CMAKE_BINARY_DIR}/fetch-nlohmann.cmake)
```

## References

* [CMake Guidelines](https://docs.salome-platform.org/latest/dev/cmake/html/various.html)
* [FetchContent vs ExternalProject](https://www.scivision.dev/cmake-fetchcontent-vs-external-project)
