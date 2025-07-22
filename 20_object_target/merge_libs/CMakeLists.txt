cmake_minimum_required(VERSION 3.31.6)
project(demo)

add_subdirectory(include)
add_subdirectory(add)
add_subdirectory(sub)

# 创建聚合库
# calc 本身没有源码, 引入两个目标库的对象文件
add_library(
        calc STATIC
        $<TARGET_OBJECTS:add>
        $<TARGET_OBJECTS:sub>
)

target_link_libraries(calc
        PUBLIC calc_interface
)
