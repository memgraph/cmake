if(NOT DEFINED USEARCH_GIT_TAG)
  set(USEARCH_GIT_TAG "v2.13.4" CACHE STRING "USearch git tag")
else()
  set(USEARCH_GIT_TAG "${USEARCH_GIT_TAG}" CACHE STRING "USearch git tag")
endif()

FetchContent_Declare(usearch
  GIT_REPOSITORY https://github.com/unum-cloud/usearch.git
  GIT_TAG        ${USEARCH_GIT_TAG}
)
FetchContent_MakeAvailable(usearch)
