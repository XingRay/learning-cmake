cmake_minimum_required(VERSION 3.31.6)
project(lesson14_add_definitions)

# 给所有的target定义宏 GLOBAL_DEF1 GLOBAL_DEF2 不推荐这种方式, 推荐使用 target_compile_definitions
add_definitions(-DGLOBAL_DEF1 -DGLOBAL_DEF2)

add_executable(${PROJECT_NAME}
        main.cpp
)

# 给指定的 target 添加宏定义
target_compile_definitions(${PROJECT_NAME}
        PRIVATE TEST_DEF1 TEST_DEF2
        PUBLIC TEST_PUB_DEF1
)