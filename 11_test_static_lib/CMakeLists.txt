# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)

set(CMAKE_CXX_STANDARD 23)

file(GLOB_RECURSE DEMO_SRC_LIST
        src/*.cpp
)

# 为所有 target 设置链接的库的名称, 推荐使用 target_link_libraries 代替
#link_libraries(
#        calc
#)

# 为所有的 target 设置搜索库的目录, 推荐使用 target_link_directories 代替
#link_directories(
#        "${PROJECT_SOURCE_DIR}/lib"
#)

# 为所有 target 设置头文件搜索目录, 推荐使用 target_include_directories 代替
#include_directories(
#         ${PROJECT_SOURCE_DIR}/include
#)

add_executable(
        demo
        ${DEMO_SRC_LIST}
)

# 为目标指定链接库的名称
target_link_libraries(
        demo
        PRIVATE calc
)

# 为目标指定搜索库的目录
target_link_directories(
        demo
        PRIVATE lib
)

# 为目标指定搜索头文件的目录
target_include_directories(
        demo
        PRIVATE include
)

# 配置输出目录
set_target_properties(demo PROPERTIES
        # exe文件输出目录
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/runtime"

        # 对exe无效
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/library"
        # 对exe无效
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/archive"
)