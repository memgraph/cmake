#include <cstdint>
#include <iostream>
#include <thread>

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
  uint64_t vector_size = 1000;
  metric_punned_t metric(vector_size, metric_kind_t::l2sq_k,
                         scalar_kind_t::f32_k);
  uint64_t index_size = 10;
  // using mg_key_t = uint64_t;
  // // NOTE: To make std::string work as a key, I had to replace built-in
  // exchange
  // // (C++11 compatiblity) function by std::exchange.
  // using mg_key_t = std::string;
  // using mg_key_t = std::pair<uint64_t, uint64_t>;
  using mg_key_t = mg_tx_data_t;
  using mg_vector_index_t = index_dense_gt<mg_key_t, uint40_t>;
  mg_vector_index_t index = mg_vector_index_t::make(metric);
  // std::mt19937 rng;
  // std::uniform_real_distribution<> distrib;
  index.reserve(index_size);
  for (int i = 0; i < index_size; ++i) {
    std::vector<float> indexed_vector(vector_size, 0.0);
    for (int j = 0; j < vector_size; ++j) {
      indexed_vector[j] = i + j;
      // indexed_vector[j] = distrib(rng);
    }
    // index.add(i, indexed_vector.data());
    // index.add(std::make_pair(i, i), indexed_vector.data());
    // index.add("key" + std::to_string(i), indexed_vector.data());
    index.add(mg_tx_data_t{.gid = (uint64_t)i, .tx = 0, .cmd = 0},
              indexed_vector.data());
    // NOTE: At 100k of vector of size 1000, RES was ~410MB (on M1).
    // TODO(gitbuda): Estimate/figure_out ratio between in-memory data structure
    // vs raw size of the vectors.
    if (i != 0 && i % 10000 == 0) {
      std::cout << 10000 << " of more vectors added. Now " << i
                << " vectors are indexed" << std::endl;
    }
  }
  std::cout << "Index created." << std::endl;
  // std::this_thread::sleep_for (std::chrono::seconds(100)); // A hack to
  // observe RAM growth.

  std::vector<float> query_vector(vector_size, 0.0);
  for (int j = 0; j < vector_size; ++j) {
    query_vector[j] = j;
  }

  auto results = index.search(query_vector.data(), 5);
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
