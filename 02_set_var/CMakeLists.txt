# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)

set(SRC main.cpp Add.cpp)

add_executable(
        demo
        ${SRC}
)