#include <iostream>

#include <nlohmann/json.hpp>
#include "text_search.hpp"

int main() {
  std::cout << "Testing CMake libs" << std::endl;

  nlohmann::json j;
  j["a"] = "b";
  std::cout << j << std::endl;

  memcxx::text_search::init("");

  return 0;
}
