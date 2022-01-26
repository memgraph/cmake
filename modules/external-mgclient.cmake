set(MGCLIENT_GIT_TAG "v1.3.0" CACHE STRING "GTest git tag")

ExternalProject_Add(mgclient-proj
  PREFIX         mgclient
  GIT_REPOSITORY https://github.com/memgraph/mgclient.git
  GIT_TAG        ${MGCLIENT_GIT_TAG}
  CMAKE_ARGS     "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
                 "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
                 "-DBUILD_CPP_BINDINGS=ON"
  INSTALL_DIR    "${PROJECT_BINARY_DIR}/mgclient"
)

ExternalProject_Get_Property(mgclient-proj install_dir)
set(MGCLIENT_ROOT ${install_dir})
set(MGCLIENT_INCLUDE_DIRS ${MGCLIENT_ROOT}/include
    CACHE INTERNAL "Path to mgclient include directory")
set(MGCLIENT_LIBRARY_PATH ${MGCLIENT_ROOT}/lib/libmgclient.so)
message(STATUS "MGCLIENT_LIBRARY_PATH: ${MGCLIENT_LIBRARY_PATH}")
set(MGCLIENT_LIBRARY mgclient-lib)
add_library(${MGCLIENT_LIBRARY} SHARED IMPORTED)
set_property(TARGET ${MGCLIENT_LIBRARY} PROPERTY IMPORTED_LOCATION ${MGCLIENT_LIBRARY_PATH})
add_dependencies(${MGCLIENT_LIBRARY} mgclient-proj)
message(STATUS "MGCLIENT_LIBRARY: ${MGCLIENT_LIBRARY}")
