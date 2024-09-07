#include "stdexec/__detail/__execution_fwd.hpp"
#include <iostream>

#include <exec/static_thread_pool.hpp>
#include <exec/task.hpp>
#include <stdexec/execution.hpp>

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

auto get_batch(int how_many) {
  std::vector data(10, 1);
  return data; // co_yield and co_return
}

void batch() {}

int main() {
  basic();
  coro();
  cancel();
  batch();
  return 0;
}
