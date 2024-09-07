if(NOT DEFINED STDEXEC_GIT_TAG)
  set(STDEXEC_GIT_TAG "nvhpc-24.09.rc1" CACHE STRING "stdexec git tag")
else()
  set(STDEXEC_GIT_TAG "${STDEXEC_GIT_TAG}" CACHE STRING "stdexec git tag")
endif()
set(STDEXEC_BUILD_TESTS OFF)
set(STDEXEC_BUILD_EXAMPLES OFF)

FetchContent_Declare(stdexec
  GIT_REPOSITORY     https://github.com/NVIDIA/stdexec.git
  GIT_TAG            ${STDEXEC_GIT_TAG}
)
FetchContent_MakeAvailable(stdexec)
