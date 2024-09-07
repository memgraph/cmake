#include "stdexec/__detail/__execution_fwd.hpp"
#include <iostream>

#include <exec/static_thread_pool.hpp>
#include <exec/task.hpp>
#include <stdexec/execution.hpp>

// NOTE: 2024-09-07 std::generator is only libstdc++

using namespace stdexec;
using stdexec::sync_wait;

void basic() {
  exec::numa_policy numa{exec::no_numa_policy{}};
  exec::static_thread_pool pool{8};
  auto scheduler = pool.get_scheduler();

  auto begin = schedule(scheduler);
  sender auto hi_again = then(begin, [] {
    std::cout << "Hello world! Have an int.\n";
    return 13;
  });

  sender auto add_42 = then(hi_again, [](int arg) { return arg + 42; });
  auto [i] = sync_wait(std::move(add_42)).value();
  std::cout << "Result: " << i << std::endl;

  std::tuple<run_loop::__scheduler> t = sync_wait(get_scheduler()).value();
  (void)t;

  auto y = let_value(get_scheduler(), [](auto sched) {
    return on(sched, then(just(), [] {
                std::cout << "from run_loop\n";
                return 42;
              }));
  });
  sync_wait(std::move(y));
  sync_wait(when_all(just(42), get_scheduler(), get_stop_token()));
}

template <sender S1, sender S2> exec::task<int> async_answer(S1 s1, S2 s2) {
  // Senders are implicitly awaitable (in this coroutine type):
  co_await static_cast<S2 &&>(s2);
  co_return co_await static_cast<S1 &&>(s1);
}

template <sender S1, sender S2>
exec::task<std::optional<int>> async_answer2(S1 s1, S2 s2) {
  co_return co_await stopped_as_optional(async_answer(s1, s2));
}

exec::task<std::optional<inplace_stop_token>> async_stop_token() {
  co_return co_await stopped_as_optional(get_stop_token());
}

void coro() {
  try {
    auto [i] = stdexec::sync_wait(async_answer2(just(42), just())).value();
    std::cout << "The answer is " << i.value() << '\n';
  } catch (std::exception &e) {
    std::cout << e.what() << '\n';
  }
}

auto cancellable_task(int task_id, int sleep_duration,
                      inplace_stop_token stop_token) {
  return just() | then([task_id, sleep_duration, stop_token]() {
           for (int i = 0; i < sleep_duration * 10; ++i) {
             std::cout << "Task " << task_id << ": " << i << std::endl;
             if (stop_token.stop_requested()) {
               std::cout << "Task " << task_id << " was canceled\n";
               throw std::runtime_error("Task canceled");
             }
             std::this_thread::sleep_for(std::chrono::milliseconds(100));
           }
           std::cout << "Task " << task_id << " completed\n";
           return task_id * 10;
         });
}

void cancel() {
  exec::static_thread_pool pool{8};
  auto sched = pool.get_scheduler();

  inplace_stop_source stop_source;
  auto task1 = cancellable_task(1, 2, stop_source.get_token());
  auto task2 = cancellable_task(2, 1, stop_source.get_token());
  auto task3 = cancellable_task(3, 3, stop_source.get_token());

  auto work = stdexec::when_all(stdexec::on(sched, std::move(task1)),
                                stdexec::on(sched, std::move(task2)),
                                stdexec::on(sched, std::move(task3)));

  std::thread canceller([&stop_source]() {
    std::this_thread::sleep_for(std::chrono::milliseconds(700));
    std::cout << "Canceling tasks...\n";
    stop_source.request_stop();
  });

  try {
    auto [data1, data2, data3] = stdexec::sync_wait(std::move(work)).value();
    std::cout << data1 << " " << data2 << " " << data3 << std::endl;
  } catch (const std::runtime_error &e) {
    std::cout << "Exception caught: " << e.what() << "\n";
  }
  canceller.join();
}

template <typename T> struct generator {
  struct promise_type {
    T current_value;
    using coroutine_handle = std::coroutine_handle<promise_type>;
    generator get_return_object() {
      return generator{coroutine_handle::from_promise(*this)};
    }
    std::suspend_always initial_suspend() const noexcept { return {}; }
    std::suspend_always final_suspend() const noexcept { return {}; }
    std::suspend_always yield_value(T value) noexcept {
      current_value = value;
      return {};
    }
    void return_void() noexcept {}
    void unhandled_exception() { std::terminate(); }
  };
  using coroutine_handle = std::coroutine_handle<promise_type>;
  generator(coroutine_handle h) : coro_handle(h) {}
  ~generator() {
    if (coro_handle) {
      coro_handle.destroy();
    }
  }
  generator(const generator &) = delete;
  generator &operator=(const generator &) = delete;
  generator(generator &&other) noexcept : coro_handle(other.coro_handle) {
    other.coro_handle = nullptr;
  }
  generator &operator=(generator &&other) noexcept {
    if (this != &other) {
      if (coro_handle) {
        coro_handle.destroy();
      }
      coro_handle = other.coro_handle;
      other.coro_handle = nullptr;
    }
    return *this;
  }
  bool move_next() {
    if (!coro_handle.done()) {
      coro_handle.resume();
    }
    return !coro_handle.done();
  }
  T current_value() const { return coro_handle.promise().current_value; }

private:
  coroutine_handle coro_handle;
};

void batch() {
  exec::static_thread_pool pool{8};
  auto scheduler = pool.get_scheduler();

  auto begin = schedule(scheduler);
  auto task0 = then(std::move(begin), []() { return 10; });
  auto task1 =
      then(std::move(task0), [](int batch_size) -> generator<std::vector<int>> {
        for (int i = 0; i < batch_size; ++i) {
          co_yield std::vector<int>(batch_size, i);
        }
      });
  auto task2 = then(std::move(task1), [](generator<std::vector<int>> gen) {
    int sum = 0;
    while (gen.move_next()) {
      // NOTE: This is most likely making vector copy!
      auto batch = gen.current_value();
      for (const auto &value : batch) {
        sum += value;
      }
    }
    return sum;
  });
  auto [i] = sync_wait(std::move(task2)).value();
  std::cout << "Sum of all values: " << i << "\n";
}

int main() {
  basic();
  coro();
  cancel();
  batch();
  return 0;
}
