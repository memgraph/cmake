if(NOT DEFINED AWS_SDK_CPP_GIT_TAG)
  set(AWS_SDK_CPP_GIT_TAG "1.11.238" CACHE STRING "aws-sdk-cpp git tag")
else()
  set(AWS_SDK_CPP_GIT_TAG "${AWS_SDK_CPP_GIT_TAG}" CACHE STRING "aws-sd-cpp git tag")
endif()

# TODO(gitbuda): The issue here is that find_package can't easily be used.
ExternalProject_Add(libawscpp-proj
    PREFIX          libawscpp-proj
    GIT_REPOSITORY  https://github.com/aws/aws-sdk-cpp.git
    GIT_TAG         "${AWS_SDK_CPP_GIT_TAG}"
    LIST_SEPARATOR  "|"
    CMAKE_ARGS      DBUILD_SHARED_LIBS=OFF
                    DENABLE_TESTING=OFF
                    DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                    DBUILD_ONLY=monitoring|logs|s3
    BUILD_ALWAYS    FALSE
    TEST_COMMAND    ""
)
