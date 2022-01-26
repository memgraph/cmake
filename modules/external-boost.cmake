set(BOOST_MODULES "" CACHE STRING "Picks Boost modules separated by space")
if("${BOOST_MODULES}" STREQUAL "")
  message(FATAL_ERROR "Some Boost modules have to be picked")
endif()
set(BOOST_GIT_TAG "boost-1.78.0" CACHE STRING "Boost git tag")

set(boost_URL "https://github.com/boostorg/boost.git" )
set(boost_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/third_party/boost)
set(boost_INCLUDE_DIR ${Boost_INSTALL}/include)
set(boost_LIB_DIR ${Boost_INSTALL}/lib)
set(boost_LIBRARY_SUFFIX .a)

string(REPLACE " " ";" BOOST_MODULES_LIST ${BOOST_MODULES})
string(APPEND boost_CONFIGURED_MODULES "")
foreach(boost_MODULE ${BOOST_MODULES_LIST})
  string(APPEND boost_CONFIGURED_MODULES " --with-libraries=${boost_MODULE} ")
  add_library(boost::${boost_MODULE} STATIC IMPORTED)
  set_property(TARGET boost::${boost_MODULE} PROPERTY IMPORTED_LOCATION ${boost_LIB_DIR}/libboost_${boost_MODULE}${boost_LIBRARY_SUFFIX})
  set_property(TARGET boost::${boost_MODULE} PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${boost_INCLUDE_DIR})
  add_dependencies(boost::${boost_MODULE} boost-proj)
endforeach()

ExternalProject_Add(boost-proj
  GIT_REPOSITORY ${boost_URL}
  GIT_TAG ${BOOST_GIT_TAG}
  PREFIX boost-proj
  BUILD_IN_SOURCE 1
  INSTALL_DIR ${boost_INSTALL_DIR}
  CONFIGURE_COMMAND ./bootstrap.sh ${boost_CONFIGURED_MODULES} --prefix=<INSTALL_DIR>
  BUILD_COMMAND ./b2 install link=static variant=release threading=multi runtime-link=static
  INSTALL_COMMAND ""
)
