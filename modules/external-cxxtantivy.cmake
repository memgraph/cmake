# TODO(gitbuda): Add memcxx version.

ExternalProject_Add(cxxtantivy-proj
  PREFIX         cxxtantivy-proj
  SOURCE_DIR     /Users/buda/Workspace/code/memgraph/cxxtantivy
  # GIT_REPOSITORY https://github.com/memgraph/mgclient.git
  # GIT_TAG        ${MGCLIENT_GIT_TAG}
  CMAKE_ARGS
    "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
    "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
    "-DENABLE_TESTS=OFF"
  INSTALL_DIR    "${PROJECT_BINARY_DIR}/cxxtantivy"
)

ExternalProject_Get_Property(cxxtantivy-proj install_dir)
set(CXXTANTIVY_ROOT ${install_dir})
message(STATUS ${CXXTANTIVY_ROOT})
add_library(cxxtantivy_rust STATIC IMPORTED)
set_property(TARGET cxxtantivy_rust PROPERTY IMPORTED_LOCATION ${CXXTANTIVY_ROOT}/lib/libcxxtantivy_rust.a)
set_property(TARGET cxxtantivy_rust PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${CXXTANTIVY_ROOT}/include)
add_dependencies(cxxtantivy_rust cxxtantivy-proj)
