if(NOT DEFINED ANNOY_GIT_TAG)
  set(ANNOY_GIT_TAG "v1.17.2" CACHE STRING "annoy git tag")
else()
  set(ANNOY_GIT_TAG "${ANNOY_GIT_TAG}" CACHE STRING "annoy git tag")
endif()

FetchContent_Declare(annoy
  GIT_REPOSITORY https://github.com/spotify/annoy.git
  GIT_TAG        ${ANNOY_GIT_TAG}
)
FetchContent_MakeAvailable(annoy)
