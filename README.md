# Memgraph CMake

This is a collection of CMake modules that are useful for all Memgraph
projects.

## Hints

To list all targets run `cmake --build . --target help`.

## Possible usages

```
include(FetchContent)
include(ExternalProject)

# Boost
file(DOWNLOAD https://raw.githubusercontent.com/memgraph/cmake/main/modules/external-boost.cmake
     ${CMAKE_BINARY_DIR}/external-boost.cmake)
include(${CMAKE_BINARY_DIR}/external-boost.cmake)
target_link_libraries({{target}} PRIVATE boost_headers boost_thread_static)

# fmtlib
file(DOWNLOAD https://raw.githubusercontent.com/memgraph/cmake/main/modules/external-fmt.cmake
     ${CMAKE_BINARY_DIR}/external-fmt.cmake)
include(${CMAKE_BINARY_DIR}/external-fmt.cmake)
target_link_libraries({{target}} PRIVATE fmtlib_static)

# mgclient
file(DOWNLOAD https://raw.githubusercontent.com/memgraph/cmake/main/modules/external-mgclient.cmake
     ${CMAKE_BINARY_DIR}/external-mgclient.cmake)
include(${CMAKE_BINARY_DIR}/external-mgclient.cmake)
target_link_libraries({{target}} PRIVATE mgclient_shared)

# Google Benchmark
file(DOWNLOAD https://raw.githubusercontent.com/memgraph/cmake/main/modules/fetch-gbenchmark.cmake
     ${CMAKE_BINARY_DIR}/fetch-gbenchmark.cmake)
include(${CMAKE_BINARY_DIR}/fetch-gbenchmark.cmake)
target_link_libraries({{target}} PRIVATE benchmark::benchmark)

# Google Test
file(DOWNLOAD https://raw.githubusercontent.com/memgraph/cmake/main/modules/fetch-gtest.cmake
     ${CMAKE_BINARY_DIR}/fetch-gtest.cmake)
include(${CMAKE_BINARY_DIR}/fetch-gtest.cmake)
target_link_libraries({{target}} PRIVATE gtest gtest_main)

# NLohmann JSON
file(DOWNLOAD https://raw.githubusercontent.com/memgraph/cmake/main/modules/fetch-nlohmann.cmake
     ${CMAKE_BINARY_DIR}/fetch-nlohmann.cmake)
include(${CMAKE_BINARY_DIR}/fetch-nlohmann.cmake)
target_link_libraries({{target}} PRIVATE nlohmann_json::nlohmann_json)
```

## References

* [CMake Guidelines](https://docs.salome-platform.org/latest/dev/cmake/html/various.html)
* [FetchContent vs ExternalProject](https://www.scivision.dev/cmake-fetchcontent-vs-external-project)
  * https://www.jwlawson.co.uk/interest/2020/02/23/cmake-external-project.html
  * https://coderefinery.github.io/cmake-workshop/fetch-content/
  * NOTE: It's not easy to combine ExternalProject and find_package because find_package is configure-time, ExternalProject is build-time.
