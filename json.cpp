#include <iostream>

#include <nlohmann/json.hpp>

int main() {
  nlohmann::json j;
  j["a"] = "b";
  std::cout << j << std::endl;
  return 0;
}
