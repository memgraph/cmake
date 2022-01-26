set(GTEST_GIT_TAG "release-1.11.0" CACHE STRING "GTest git tag")

FetchContent_Declare(googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG        ${GTEST_GIT_TAG}
)
FetchContent_MakeAvailable(googletest)
