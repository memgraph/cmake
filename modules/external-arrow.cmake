if(NOT DEFINED ARROW_GIT_TAG)
  set(ARROW_GIT_TAG "apache-arrow-15.0.1" CACHE STRING "arrow git tag")
else()
  set(ARROW_GIT_TAG "${ARROW_GIT_TAG}" CACHE STRING "arrow git tag")
endif()

set(ARROW_CMAKE_ARGS
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
    -DARROW_COMPUTE=OFF
    -DARROW_JEMALLOC=OFF
    -DARROW_PYTHON=OFF
)

    # ${CMAKE_CURRENT_BINARY_DIR}/arrow-proj/src/arrow-proj/cpp

# NOTE: If Apache Arrow is installed via package manager, follow the official guide -> https://arrow.apache.org/docs/cpp/build_system.html.
# TODO(gitbuda): Doesn't work, something is broken how arrow's CMake takes the INSTALL_DIR
ExternalProject_Add(arrow-proj
    PREFIX          arrow-proj
    GIT_REPOSITORY  https://github.com/apache/arrow.git
    GIT_TAG         "${ARROW_GIT_TAG}"
    CMAKE_ARGS
      "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
      "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
      "${ARROW_CMAKE_ARGS}"
    INSTALL_DIR     "${PROJECT_BINARY_DIR}/arrow"
    CONFIGURE_COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" "${CMAKE_ARGS}" "${CMAKE_CURRENT_BINARY_DIR}/arrow-proj/src/arrow-proj/cpp"
)

# ExternalProject_Get_Property(arrow-proj install_dir)
# set(ARROW_ROOT ${install_dir})
# add_library(libarrow STATIC IMPORTED)
# add_dependencies(libarrow arrow-proj)
# set_property(TARGET libarrow PROPERTY IMPORTED_LOCATION ${ARROW_ROOT}/lib/libarrow.a)
# # We need to create the include directory first in order to be able to add it
# # as an include directory. The header files in the include directory will be
# # generated later during the build process.
# file(MAKE_DIRECTORY ${ARROW_ROOT}/include)
# set_property(TARGET libarrow PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${ARROW_ROOT}/include)
