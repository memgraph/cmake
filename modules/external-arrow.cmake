if(NOT DEFINED ARROW_GIT_TAG)
  set(ARROW_GIT_TAG "apache-arrow-15.0.1" CACHE STRING "arrow git tag")
else()
  set(ARROW_GIT_TAG "${ARROW_GIT_TAG}" CACHE STRING "arrow git tag")
endif()

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

# https://github.com/rapidsai/libgdf/blob/master/libgdf/cmake/Templates/Arrow.CMakeLists.txt.cmake
# https://stackoverflow.com/questions/73935448/installing-and-linking-to-apache-arrow-inside-cmake
set(ARROW_CMAKE_ARGS
    -DARROW_BUILD_STATIC=ON
    -DARROW_BUILD_SHARED=OFF
    -DARROW_WITH_LZ4=OFF
    -DARROW_WITH_ZSTD=OFF
    -DARROW_WITH_BROTLI=OFF
    -DARROW_WITH_SNAPPY=OFF
    -DARROW_WITH_ZLIB=OFF
    -DARROW_BUILD_STATIC=ON
    -DARROW_BUILD_SHARED=OFF
    -DARROW_BOOST_USE_SHARED=OFF
    -DARROW_BUILD_TESTS=OFF
    -DARROW_TEST_MEMCHECK=OFF
    -DARROW_BUILD_BENCHMARKS=OFF
    -DARROW_IPC=OFF
    -DARROW_CSV=ON
    -DARROW_PARQUET=ON
    -DARROW_COMPUTE=OFF
    -DARROW_JEMALLOC=OFF
    -DARROW_PYTHON=OFF
)

# NOTE: If Apache Arrow is installed via package manager,
#       follow the official guide -> https://arrow.apache.org/docs/cpp/build_system.html.
ExternalProject_Add(arrow-proj
    PREFIX          arrow-proj
    GIT_REPOSITORY  https://github.com/apache/arrow.git
    GIT_TAG         "${ARROW_GIT_TAG}"
    SOURCE_SUBDIR   cpp
    CMAKE_ARGS
      "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
      "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
      "${ARROW_CMAKE_ARGS}"
    INSTALL_DIR     "${PROJECT_BINARY_DIR}/arrow"
)

ExternalProject_Get_Property(arrow-proj install_dir)
set(ARROW_ROOT ${install_dir})
# We need to create the include directory first in order to be able to add it
# as an include directory. The header files in the include directory will be
# generated later during the build process.
file(MAKE_DIRECTORY ${ARROW_ROOT}/include)

add_library(libarrow STATIC IMPORTED)
set_property(TARGET libarrow PROPERTY IMPORTED_LOCATION ${ARROW_ROOT}/lib/libarrow.a)
set_property(TARGET libarrow PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${ARROW_ROOT}/include)
add_dependencies(libarrow arrow-proj)

add_library(libparquet STATIC IMPORTED)
set_property(TARGET libparquet PROPERTY IMPORTED_LOCATION ${ARROW_ROOT}/lib/libparquet.a)
set_property(TARGET libparquet PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${ARROW_ROOT}/include)
add_dependencies(libparquet arrow-proj)
