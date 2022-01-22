cmake_minimum_required(VERSION 3.10)

project(mgcmake VERSION 0.1.0)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)
set(C_STANDARD_REQUIRED ON)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(project_options INTERFACE)
include(cmake/Sanitizers.cmake)
enable_sanitizers(project_options)

add_library(project_warnings INTERFACE)
include(cmake/CompilerWarnings.cmake)
set_project_warnings(project_warnings)

include(FetchContent)

FetchContent_Declare(googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG        release-1.11.0
)

set(BENCHMARK_ENABLE_TESTING off)
FetchContent_Declare(googlebenchmark
  GIT_REPOSITORY https://github.com/google/benchmark.git
  GIT_TAG        v1.6.1)
FetchContent_MakeAvailable(googletest googlebenchmark)

add_executable(main main.cpp)
target_link_libraries(main PRIVATE benchmark::benchmark)

add_executable(gbenchmark gbenchmark.cpp)
target_link_libraries(gbenchmark PRIVATE benchmark::benchmark)
