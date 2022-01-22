ExternalProject_Add(fmtlib
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  EXCLUDE_FROM_ALL TRUE
  BUILD_COMMAND $(MAKE) fmt
  STEP_TARGETS build)
set(fmtlib_BINARY_DIR "${CMAKE_BINARY_DIR}/fmtlib-prefix/src/fmtlib-build")
set(fmtlib_SOURCE_DIR "${CMAKE_BINARY_DIR}/fmtlib-prefix/src/fmtlib/include")
