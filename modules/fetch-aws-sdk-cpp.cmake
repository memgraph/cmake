if(NOT DEFINED AWS_SDK_CPP_GIT_TAG)
  set(AWS_SDK_CPP_GIT_TAG "1.11.238" CACHE STRING "aws-sdk-cpp git tag")
else()
  set(AWS_SDK_CPP_GIT_TAG "${AWS_SDK_CPP_GIT_TAG}" CACHE STRING "aws-sd-cpp git tag")
endif()

FetchContent_Declare(
    awscppsdk
    GIT_REPOSITORY  https://github.com/aws/aws-sdk-cpp.git
    GIT_TAG         "${AWS_SDK_CPP_GIT_TAG}"
)
set(LIST_SEPARATOR       "|")
set(BUILD_SHARED_LIBS    OFF)
set(ENABLE_TESTING       OFF)
set(CMAKE_INSTALL_PREFIX <INSTALL_DIR>)
set(BUILD_ONLY           s3)
set(BUILD_ALWAYS         FALSE)
FetchContent_MakeAvailable(awscppsdk)
