#include <cstdint>
#include <iostream>

// CPP: https://github.com/unum-cloud/usearch/tree/main/cpp
// REF: https://unum-cloud.github.io/usearch/cpp/reference.html
#include <usearch/index.hpp>
#include <usearch/index_dense.hpp>

using namespace unum::usearch;

struct mg_tx_data_t {
  uint64_t gid;
  uint64_t tx;
  uint64_t cmd;
  bool operator==(const mg_tx_data_t &rhs) const {
    return (gid == rhs.gid) && (tx == rhs.tx) && (cmd == rhs.cmd);
  }
};
template <> struct unum::usearch::hash_gt<mg_tx_data_t> {
  std::size_t operator()(mg_tx_data_t const &element) const noexcept {
    return element.gid ^ element.tx ^ element.cmd;
  }
};

template <> struct unum::usearch::hash_gt<std::pair<uint64_t, uint64_t>> {
  std::size_t
  operator()(std::pair<uint64_t, uint64_t> const &element) const noexcept {
    return std::hash<uint64_t>{}(element.first) ^
           std::hash<uint64_t>{}(element.second);
  }
};

void run_usearch() {
  metric_punned_t metric(1000, metric_kind_t::l2sq_k, scalar_kind_t::f32_k);
  // using mg_key_t = uint64_t;
  // // NOTE: To make std::string work as a key, I had to replace built-in exchange
  // // (C++11 compatiblity) function by std::exchange.
  // using mg_key_t = std::string;
  // using mg_key_t = std::pair<uint64_t, uint64_t>;
  using mg_key_t = mg_tx_data_t;
  using mg_vector_index_t = index_dense_gt<mg_key_t, uint40_t>;
  mg_vector_index_t index = mg_vector_index_t::make(metric);
  index.reserve(10);
  for (int i = 0; i < 10; ++i) {
    std::vector<float> vec(1000, 0.0);
    for (int j = 0; j < 1000; ++j) {
      vec[j] = i + j;
    }
    // index.add(i, vec.data());
    // index.add(std::make_pair(i, i), vec.data());
    // index.add("key" + std::to_string(i), vec.data());
    index.add(mg_tx_data_t{.gid = (uint64_t)i, .tx = 0, .cmd = 0}, vec.data());
  }

  std::vector<float> vec(1000, 0.0);
  for (int j = 0; j < 1000; ++j) {
    vec[j] = j;
  }

  auto results = index.search(vec.data(), 5);
  for (std::size_t i = 0; i != results.size(); ++i) {
    auto key = static_cast<mg_key_t>(results[i].member.key);
    auto distance = results[i].distance;
    // std::cout << "Item({ key:" << key << ", distance:" << distance << " })"
    // << std::endl; std::cout << "Item({ key:" << key.first << ", distance:" <<
    // distance << " })" << std::endl;
    std::cout << "Item({ key:" << key.gid << ", distance:" << distance << " })"
              << std::endl;
  }
}

int main(int argc, char **argv) {
  run_usearch();
  return 0;
}
