#include <cstdio>
#include <cstdlib>
#include <random>

// annoy
#include <annoylib.h>
#include <kissrandom.h>
// faiss
#include <faiss/IndexHNSW.h>
// usearch
#include <usearch/index.hpp>
#include <usearch/index_dense.hpp>

using idx_t = faiss::idx_t;
using namespace unum::usearch;

void run_annoy() {
  Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random,
                    Annoy::AnnoyIndexMultiThreadedBuildPolicy>
      t = Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random,
                            Annoy::AnnoyIndexMultiThreadedBuildPolicy>(40);
}

// https://github.com/facebookresearch/faiss/blob/main/tutorial/cpp/6-HNSW.cpp
void run_faiss() {
    int d = 64;      // dimension
    int nb = 100000; // database size
    int nq = 10000;  // nb of queries
    std::mt19937 rng;
    std::uniform_real_distribution<> distrib;
    float* xb = new float[d * nb];
    float* xq = new float[d * nq];
    for (int i = 0; i < nb; i++) {
        for (int j = 0; j < d; j++)
            xb[d * i + j] = distrib(rng);
        xb[d * i] += i / 1000.;
    }
    for (int i = 0; i < nq; i++) {
        for (int j = 0; j < d; j++)
            xq[d * i + j] = distrib(rng);
        xq[d * i] += i / 1000.;
    }
    int k = 4;
    faiss::IndexHNSWFlat index(d, 32);
    index.add(nb, xb);

    { // search xq
        idx_t* I = new idx_t[k * nq];
        float* D = new float[k * nq];
        index.search(nq, xq, k, D, I);
        printf("I=\n");
        for (int i = nq - 5; i < nq; i++) {
            for (int j = 0; j < k; j++)
                printf("%5lld ", I[i * k + j]);
            printf("\n");
        }
        printf("D=\n");
        for (int i = nq - 5; i < nq; i++) {
            for (int j = 0; j < k; j++)
                printf("%5f ", D[i * k + j]);
            printf("\n");
        }
        delete[] I;
        delete[] D;
    }
    delete[] xb;
    delete[] xq;
}

// NOTE: From https://github.com/unum-cloud/usearch/tree/main/cpp
void run_usearch() {
  metric_punned_t metric(3, metric_kind_t::l2sq_k, scalar_kind_t::f32_k);
  // If you plan to store more than 4 Billion entries - use `index_dense_big_t`.
  // Or directly instantiate the template variant
  // you need - `index_dense_gt<vector_key_t, internal_id_t>`.
  index_dense_t index = index_dense_t::make(metric);
  float vec[3] = {0.1, 0.3, 0.2};
  index.reserve(10);      // Pre-allocate memory for 10 vectors
  index.add(42, &vec[0]); // Pass a key and a vector
                          //
  auto results =
      index.search(&vec[0], 5); // Pass a query and limit number of results
  for (std::size_t i = 0; i != results.size(); ++i)
    // You can access the following properties of every match:
    // results[i].element.key, results[i].element.vector, results[i].distance;
    std::printf("Found matching key: %lu",
                static_cast<size_t>(results[i].member.key));
}

int main(int argc, char **argv) {
  run_annoy();
  run_faiss();
  run_usearch();
  return 0;
}
