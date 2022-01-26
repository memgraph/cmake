set(MGCLIENT_GIT_TAG "v1.3.0" CACHE STRING "GTest git tag")

ExternalProject_Add(mgclient-proj
  PREFIX         mgclient-proj
  GIT_REPOSITORY https://github.com/memgraph/mgclient.git
  GIT_TAG        ${MGCLIENT_GIT_TAG}
  CMAKE_ARGS
    "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
    "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
    "-DBUILD_CPP_BINDINGS=ON"
  INSTALL_DIR    "${PROJECT_BINARY_DIR}/mgclient"
)

ExternalProject_Get_Property(mgclient-proj install_dir)
set(MGCLIENT_ROOT ${install_dir})
set(MGCLIENT_INCLUDE_DIR ${MGCLIENT_ROOT}/include)
file(MAKE_DIRECTORY ${MGCLIENT_INCLUDE_DIR})
set(MGCLIENT_LIBRARY_PATH ${MGCLIENT_ROOT}/lib/libmgclient.so)
set(MGCLIENT_LIBRARY mgclient_shared)
add_library(${MGCLIENT_LIBRARY} SHARED IMPORTED)
set_property(TARGET ${MGCLIENT_LIBRARY} PROPERTY IMPORTED_LOCATION ${MGCLIENT_LIBRARY_PATH})
set_property(TARGET ${MGCLIENT_LIBRARY} PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${MGCLIENT_INCLUDE_DIR})
add_dependencies(${MGCLIENT_LIBRARY} mgclient-proj)
