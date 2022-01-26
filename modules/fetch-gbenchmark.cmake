set(GBENCHMARK_GIT_TAG "v1.6.1" CACHE STRING "GBenchmark git tag")

set(BENCHMARK_ENABLE_TESTING off)
FetchContent_Declare(googlebenchmark
  GIT_REPOSITORY https://github.com/google/benchmark.git
  GIT_TAG        ${GBENCHMARK_GIT_TAG}
)
FetchContent_MakeAvailable(googlebenchmark)
