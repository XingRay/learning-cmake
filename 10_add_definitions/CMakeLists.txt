cmake_minimum_required(VERSION 3.31.6)
project(demo)

# 给所有的target定义宏 GLOBAL_DEF1 GLOBAL_DEF2 不推荐这种方式
add_definitions(-DGLOBAL_DEF1 -DGLOBAL_DEF2)

add_executable(demo
        main.cpp
)

# 给指定的 target 添加宏定义
target_compile_definitions(demo
        PRIVATE TEST_DEF1 TEST_DEF2
        PUBLIC TEST_PUB_DEF1
)


# 常用的预定义宏
message("PROJECT_SOURCE_DIR:${PROJECT_SOURCE_DIR}")
message("PROJECT_BINARY_DIR:${PROJECT_BINARY_DIR}")
message("CMAKE_CURRENT_SOURCE_DIR:${CMAKE_CURRENT_SOURCE_DIR}")
message("CMAKE_CURRENT_BINARY_DIR:${CMAKE_CURRENT_BINARY_DIR}")
message("PROJECT_NAME:${PROJECT_NAME}")
message("CMAKE_BINARY_DIR:${CMAKE_BINARY_DIR}")
