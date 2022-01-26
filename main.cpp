#include <iostream>

#include <boost/chrono.hpp>
#include <boost/thread.hpp>

void wait(int seconds) {
  boost::this_thread::sleep_for(boost::chrono::seconds{seconds});
}

void thread() {
  for (int i = 0; i < 5; ++i) {
    wait(1);
    std::cout << i << '\n';
  }
}

int main() {
  std::cout << boost::chrono::system_clock::now() << std::endl;
  boost::thread t{thread};
  t.join();
  return 0;
}
