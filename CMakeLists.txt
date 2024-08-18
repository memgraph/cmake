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
include(modules/external-fmt.cmake)
include(modules/external-mgclient.cmake)

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

# NOTE: Some build issues on Mac M1, works on Linux.
# include(modules/fetch-aws-sdk-cpp.cmake)
# add_executable(aws_example aws.cpp)
# target_link_libraries(aws_example aws-cpp-sdk-core aws-cpp-sdk-s3)

# include(modules/external-aws-sdk-cpp.cmake)
# ExternalProject_Get_Property(libawscpp-proj install_dir)
# set(AWSSDK_DIR ${install_dir})
# # # NOTE: The following doesn't work smootly -> manual target definition required (similar to mgclient).
# # list(APPEND CMAKE_PREFIX_PATH ${AWSSDK_DIR})
# # find_package(AWSSDK REQUIRED COMPONENTS s3)

include(modules/external-arrow.cmake)
add_executable(arrow_example arrow.cpp)
target_link_libraries(arrow_example PRIVATE libarrow)
# find_package(Arrow REQUIRED) # https://arrow.apache.org/install/
# target_link_libraries(arrow_example PRIVATE Arrow::arrow_shared)

message(STATUS "Configuring annoy...")
include(modules/fetch-annoy.cmake)
message(STATUS "Configuring annoy DONE")
message(STATUS "Configuring faiss...")
include(modules/wip-fetch-faiss.cmake)
message(STATUS "Configuring faiss DONE")
message(STATUS "Configuring usearch...")
include(modules/fetch-usearch.cmake)
message(STATUS "Configuring usearch DONE")
add_executable(vector_search vector_search.cpp)
# annoy
add_definitions(-DANNOYLIB_MULTITHREADED_BUILD)
# faiss
target_include_directories(vector_search PRIVATE ${annoy_SOURCE_DIR}/src)
target_include_directories(vector_search PRIVATE /opt/homebrew/opt/libomp/include)
# usearch
target_include_directories(vector_search PRIVATE ${usearch_SOURCE_DIR}/fp16/include)
target_include_directories(vector_search PRIVATE ${usearch_SOURCE_DIR}/stringzilla/include)
target_link_libraries(vector_search PRIVATE usearch faiss)
