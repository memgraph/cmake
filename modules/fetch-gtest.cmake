if(NOT DEFINED GTEST_GIT_TAG)
  set(GTEST_GIT_TAG "v1.14.0" CACHE STRING "GTest git tag")
else()
  set(GTEST_GIT_TAG "${GTEST_GIT_TAG}" CACHE STRING "GTest git tag")
endif()

FetchContent_Declare(googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG        ${GTEST_GIT_TAG}
)
FetchContent_MakeAvailable(googletest)
