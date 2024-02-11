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
# include(modules/external-fmt.cmake)
# include(modules/external-mgclient.cmake)

include(modules/fetch-nlohmann.cmake)
add_executable(json_example json.cpp)
target_link_libraries(json_example PRIVATE nlohmann_json::nlohmann_json)

include(modules/fetch-gbenchmark.cmake)
add_executable(gbenchmark_example gbenchmark.cpp)
target_link_libraries(gbenchmark_example PRIVATE benchmark::benchmark)

include(modules/fetch-gtest.cmake)
enable_testing()
add_executable(gtest_example gtest.cpp)
target_link_libraries(gtest_example gtest gtest_main)
add_test(NAME gtest_example COMMAND gtest_example)

include(modules/fetch-nlohmann.cmake)
include(modules/external-mgcxx.cmake)
add_executable(mgcxx_text_search_example mgcxx_text_search.cpp)
target_link_libraries(mgcxx_text_search_example PRIVATE nlohmann_json::nlohmann_json mgcxx_text_search tantivy_text_search)

# # https://www.jwlawson.co.uk/interest/2020/02/23/cmake-external-project.html
# # https://coderefinery.github.io/cmake-workshop/fetch-content/
# include(modules/external-aws-sdk-cpp.cmake)
# set(AWSSDK_DIR "${CMAKE_BINARY_DIR}/libawscpp-proj")
# list(APPEND CMAKE_PREFIX_PATH ${AWSSDK_DIR})
# # TODO(gitbuda): Figure out a way how to combine ExternalProject and find_package -> NOT POSSIBLE EASILY because find_package is configure-time, ExternalProject is build-time.
# find_package(AWSSDK REQUIRED COMPONENTS s3)
# message(STATUS "${AWSSDK_PLATFORM_DEPS} ${AWSSDK_LINK_LIBRARIES}")
# get_property(target_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY BUILDSYSTEM_TARGETS)
# message(STATUS ${target_names})

include(modules/fetch-aws-sdk-cpp.cmake)
add_executable(aws_example aws.cpp)
target_link_libraries(aws_example aws-cpp-sdk-core aws-cpp-sdk-s3)
