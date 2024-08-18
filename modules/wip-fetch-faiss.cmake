if(NOT DEFINED FAISS_GIT_TAG)
  set(FAISS_GIT_TAG "v1.8.0" CACHE STRING "faiss git tag")
else()
  set(FAISS_GIT_TAG "${FAISS_GIT_TAG}" CACHE STRING "faiss git tag")
endif()

FetchContent_Declare(faiss
  GIT_REPOSITORY     https://github.com/facebookresearch/faiss.git
  GIT_TAG            ${FAISS_GIT_TAG}
)
# Install instructions https://github.com/facebookresearch/faiss/wiki/Installing-Faiss
# Flags https://github.com/facebookresearch/faiss/blob/main/INSTALL.md
# NOTE: OpenMP is required:
#   * MacOS: brew install libomp
#            set(OpenMP_ROOT /opt/homebrew/opt/libomp) | -DOpenMP_ROOT=/opt/homebrew/opt/libomp
set(CMAKE_BUILD_TYPE    Release)
set(BUILD_TESTING       OFF)
set(FAISS_ENABLE_GPU    OFF)
set(FAISS_ENABLE_C_API  OFF)
set(FAISS_ENABLE_PYTHON OFF)
set(FAISS_ENABLE_RAFT   OFF)
# FAISS_OPT_LEVEL (https://github.com/facebookresearch/faiss/blob/main/INSTALL.md#step-1-invoking-cmake):
#   * x86_64:  generic, avx2, avx512
#   * aarch64: generic, sve
if("${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "arm64")
  set(FAISS_OPT_LEVEL   sve)
  message(STATUS "Detected ${CMAKE_HOST_SYSTEM_PROCESSOR} setting FAISS_OPT_LEVEL ${FAISS_OPT_LEVEL}")
else()
  set(FAISS_OPT_LEVEL   generic)
endif()
FetchContent_MakeAvailable(faiss)
