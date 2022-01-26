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
include(ExternalProject)

include(modules/external-boost.cmake)
# include(modules/fmt.cmake)
include(modules/gbenchmark.cmake)
include(modules/gtest.cmake)
# include(modules/mgclient.cmake)

add_executable(main main.cpp)
target_link_libraries(main PRIVATE benchmark::benchmark)

add_executable(gbenchmark gbenchmark.cpp)
target_link_libraries(gbenchmark PRIVATE benchmark::benchmark)
