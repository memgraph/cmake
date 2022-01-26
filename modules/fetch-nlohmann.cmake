set(NLOHMANN_GIT_TAG "v3.10.5" CACHE STRING "NLohmann git tag")

FetchContent_Declare(json
    GIT_REPOSITORY https://github.com/nlohmann/json
    GIT_TAG        ${NLOHMANN_GIT_TAG}
)
FetchContent_MakeAvailable(json)
