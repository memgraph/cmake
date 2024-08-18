if(NOT DEFINED FAISS_GIT_TAG)
  set(FAISS_GIT_TAG "v1.8.0" CACHE STRING "faiss git tag")
else()
  set(FAISS_GIT_TAG "${FAISS_GIT_TAG}" CACHE STRING "faiss git tag")
endif()

FetchContent_Declare(faiss
  GIT_REPOSITORY    https://github.com/facebookresearch/faiss.git
  GIT_TAG           ${FAISS_GIT_TAG}
  CMAKE_ARGS        -DFAISS_ENABLE_GPU=OFF
)
FetchContent_MakeAvailable(faiss)
