if(NOT DEFINED MGCXX_GIT_TAG)
  set(MGCXX_GIT_TAG "v0.0.3" CACHE STRING "mgcxx git tag")
else()
  set(MGCXX_GIT_TAG "${MGCXX_GIT_TAG}" CACHE STRING "mgcxx git tag")
endif()

ExternalProject_Add(mgcxx-proj
  PREFIX         mgcxx-proj
  GIT_REPOSITORY https://github.com/memgraph/mgcxx.git
  GIT_TAG        ${MGCXX_GIT_TAG}
  CMAKE_ARGS
    "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
    "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
    "-DENABLE_TESTS=OFF"
  INSTALL_DIR    "${PROJECT_BINARY_DIR}/mgcxx"
)
ExternalProject_Get_Property(mgcxx-proj install_dir)
set(MGCXX_ROOT ${install_dir})

add_library(tantivy_text_search STATIC IMPORTED)
add_dependencies(tantivy_text_search mgcxx-proj)
set_property(TARGET tantivy_text_search PROPERTY IMPORTED_LOCATION ${MGCXX_ROOT}/lib/libtantivy_text_search.a)

add_library(mgcxx_text_search STATIC IMPORTED)
add_dependencies(mgcxx_text_search mgcxx-proj)
set_property(TARGET mgcxx_text_search PROPERTY IMPORTED_LOCATION ${MGCXX_ROOT}/lib/libmgcxx_text_search.a)
# We need to create the include directory first in order to be able to add it
# as an include directory. The header files in the include directory will be
# generated later during the build process.
file(MAKE_DIRECTORY ${MGCXX_ROOT}/include)
set_property(TARGET mgcxx_text_search PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${MGCXX_ROOT}/include)
