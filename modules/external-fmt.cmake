set(FMTLIB_GIT_TAG "10.1.0" CACHE STRING "fmtlib git tag")

set(fmtlib_INSTALL_DIR "${CMAKE_BINARY_DIR}/fmtlib-proj/install")
file(MAKE_DIRECTORY ${fmtlib_INSTALL_DIR}/include)
ExternalProject_Add(fmtlib-proj
  PREFIX           fmtlib-proj
  GIT_REPOSITORY   https://github.com/fmtlib/fmt.git
  GIT_TAG          ${FMTLIB_GIT_TAG}
  EXCLUDE_FROM_ALL TRUE
  CMAKE_ARGS
    "-DCMAKE_INSTALL_PREFIX=${fmtlib_INSTALL_DIR}"
    "-DFMT_TEST=OFF"
  BUILD_COMMAND    $(MAKE) fmt
  STEP_TARGETS     build
)

add_library(fmtlib_static STATIC IMPORTED)
set_property(TARGET fmtlib_static PROPERTY IMPORTED_LOCATION ${fmtlib_INSTALL_DIR}/lib/libfmt.a)
set_property(TARGET fmtlib_static PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${fmtlib_INSTALL_DIR}/include)
add_dependencies(fmtlib_static fmtlib-proj)
