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

# include(modules/external-boost.cmake)
include(modules/external-cxxtantivy.cmake)
# include(modules/external-fmt.cmake)
# include(modules/external-mgclient.cmake)
include(modules/fetch-gbenchmark.cmake)
include(modules/fetch-gtest.cmake)
include(modules/fetch-nlohmann.cmake)

add_executable(main main.cpp)
target_link_libraries(main PRIVATE nlohmann_json::nlohmann_json cxxtantivy_static)

add_executable(gbenchmark gbenchmark.cpp)
target_link_libraries(gbenchmark PRIVATE benchmark::benchmark)

enable_testing()
add_executable(gtest_example gtest.cpp)
target_link_libraries(gtest_example gtest gtest_main)
add_test(NAME gtest_example COMMAND gtest_example)
