set(BENCHMARK_ENABLE_TESTING off)
FetchContent_Declare(googlebenchmark
  GIT_REPOSITORY https://github.com/google/benchmark.git
  GIT_TAG        v1.6.1)
FetchContent_MakeAvailable(googlebenchmark)
