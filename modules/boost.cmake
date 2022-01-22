# 1.78 latest
# 1.71 on ubuntu 20.04
find_package(Boost 1.71 REQUIRED)

# TODO(gitbuda): Add ExternalProject_Add because of versions.
# https://stackoverflow.com/questions/46825046
# wget https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.gz
# tar -xzf boost_1_78_0.tar.gz
# cd boost_1_78_0
# ./bootstrap.sh --with-toolset=clang
# sudo ./b2 toolset=clang -j$(nproc) install variant=release
