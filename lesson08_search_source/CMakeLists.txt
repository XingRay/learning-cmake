# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(lesson08_search_source)

set(CMAKE_CXX_STANDARD 23)

# 仅会收集指定目录下的直接源文件（如 .c、.cpp 等），而不会自动遍历其子目录, 输出到指定的变量中, 如: AUX_SRC_LIST
# 输出值变量不需要提前创建, 只要给出变量名即可, 指令会自动创建和初始化变量
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
message("GLOB_SRC_LIST:${GLOB_SRC_LIST}")

# 获取相对路径  RELATIVE + 目标目录 , 返回相对于目标目录的相对路径, 如: src/main.cpp
file(GLOB GLOB_SRC_LIST RELATIVE "${PROJECT_SOURCE_DIR}"
        src/*.cpp
        src/*.c
        src/*.c++
        src/*.cxx
)
# src/main.cpp
message("GLOB_SRC_LIST:${GLOB_SRC_LIST}")



# 搜索指定路径, 递归包括子目录, 符合要求的所有文件的路径存储到变量中
file(GLOB_RECURSE SRC_LIST
        src/*.cpp
        src/*.c
        src/*.c++
        src/*.cxx
)
# calc/Add.cpp;main.cpp
message("SRC_LIST:${SRC_LIST}")

add_executable(
        ${PROJECT_NAME}
        ${SRC_LIST}
)

set_target_properties(${PROJECT_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output"
)