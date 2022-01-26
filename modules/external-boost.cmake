set(BOOST_GIT_TAG "boost-1.78.0" CACHE STRING "Boost git tag")

set(boost_URL "https://github.com/boostorg/boost.git" )
set(boost_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/third_party/boost)
set(boost_INCLUDE_DIR ${boost_INSTALL_DIR}/include)
set(boost_LIB_DIR ${boost_INSTALL_DIR}/lib)
set(boost_LIBRARY_SUFFIX .a)

add_library(boost_headers INTERFACE)
target_include_directories(boost_headers INTERFACE ${boost_INCLUDE_DIR})
list(APPEND boost_MODULES
  "atomic"
  "chrono"
  "container"
  "context"
  "contract"
  "coroutine"
  "date_time"
  "exception"
  "filesystem"
  "graph"
  "iostreams"
  "json"
  "locale"
  "log"
  "log_setup"
  "math_c99"
  "math_c99f"
  "math_c99l"
  "math_tr1"
  "math_tr1f"
  "math_tr1l"
  "nowide"
  "prg_exec_monitor"
  "program_options"
  "python38"
  "random"
  "regex"
  "serialization"
  "system"
  "text_exec_minitor"
  "thread"
  "timer"
  "type_erasure"
  "unit_test_framework"
  "wave"
  "wserialization"
)
foreach(boost_MODULE ${boost_MODULES})
  add_library(boost_${boost_MODULE}_static STATIC IMPORTED)
  set_property(TARGET boost_${boost_MODULE}_static PROPERTY IMPORTED_LOCATION ${boost_LIB_DIR}/libboost_${boost_MODULE}${boost_LIBRARY_SUFFIX})
  add_dependencies(boost_${boost_MODULE}_static boost-proj)
endforeach()

ExternalProject_Add(boost-proj
  GIT_REPOSITORY ${boost_URL}
  GIT_TAG ${BOOST_GIT_TAG}
  PREFIX boost-proj
  BUILD_IN_SOURCE 1
  INSTALL_DIR ${boost_INSTALL_DIR}
  CONFIGURE_COMMAND ./bootstrap.sh --prefix=<INSTALL_DIR>
  BUILD_COMMAND ./b2 install link=static variant=release threading=multi runtime-link=static
  INSTALL_COMMAND ""
)
