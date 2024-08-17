// NOTE: From https://github.com/unum-cloud/usearch/tree/main/cpp

#include <usearch/index.hpp>
#include <usearch/index_dense.hpp>

using namespace unum::usearch;

int main(int argc, char **argv) {
    metric_punned_t metric(3, metric_kind_t::l2sq_k, scalar_kind_t::f32_k);

    // If you plan to store more than 4 Billion entries - use `index_dense_big_t`.
    // Or directly instantiate the template variant you need - `index_dense_gt<vector_key_t, internal_id_t>`.
    index_dense_t index = index_dense_t::make(metric);
    float vec[3] = {0.1, 0.3, 0.2};

    index.reserve(10); // Pre-allocate memory for 10 vectors
    index.add(42, &vec[0]); // Pass a key and a vector
    auto results = index.search(&vec[0], 5); // Pass a query and limit number of results

    for (std::size_t i = 0; i != results.size(); ++i)
        // You can access the following properties of every match:
        // results[i].element.key, results[i].element.vector, results[i].distance;
        std::printf("Found matching key: %zu", results[i].member.key);
    return 0;
}
