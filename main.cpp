#include <iostream>

#include <nlohmann/json.hpp>

int main() {
  std::cout << "Testing CMake libs" << std::endl;

  nlohmann::json j;
  j["a"] = "b";
  std::cout << j << std::endl;

  return 0;
}
