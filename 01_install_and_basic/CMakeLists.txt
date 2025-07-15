# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)

# 创建项目
project(
        demo          # 设置项目名
        LANGUAGES CXX # 指定语言，未指定的语言将不参与构建，例如 test.c 文件
)

# 创建可执行文件
add_executable(
        demo     # 目标名
        main.cpp # 用到的源文件
)