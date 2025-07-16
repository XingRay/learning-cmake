# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)

set(CMAKE_CXX_STANDARD 23)

# 仅会收集指定目录下的直接源文件（如 .c、.cpp 等），而不会自动遍历其子目录
# 变量不需要提前创建, 只要给出变量名即可, 指令会自动创建和初始化变量
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src AUX_SRC_LIST)
# main.cpp
message("AUX_SRC_LIST:${AUX_SRC_LIST}")

# 搜索指定路径, 不包括子目录, 符合要求的所有文件的路径存储到变量中
# 第一个参数是搜索方式
# GLOB: 搜索指定目录, 不包括子目录
# GLOB_RECURSE: 递归包括子目录
# *.cpp: *表示通配符
file(GLOB GLOB_SRC_LIST
        src/*.cpp
        src/*.c
        src/*.c++
        src/*.cxx
)
# main.cpp
message(STATUS "GLOB_SRC_LIST:${GLOB_SRC_LIST}")

# 搜索指定路径, 递归包括子目录, 符合要求的所有文件的路径存储到变量中
file(GLOB_RECURSE SRC_LIST
        src/*.cpp
        src/*.c
        src/*.c++
        src/*.cxx
)
# calc/Add.cpp;main.cpp
message(STATUS "SRC_LIST:${SRC_LIST}")

add_executable(
        demo
        ${SRC_LIST}
)

set_target_properties(demo PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output"
)