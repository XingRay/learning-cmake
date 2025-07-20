cmake_minimum_required(VERSION 3.31.6)
project(demo) # 可以简化
set(CMAKE_CXX_STANDARD 23)

file(GLOB_RECURSE CALC_SRC_LIST
        "src/calc/*.cpp"
)

add_library(calc STATIC
        ${CALC_SRC_LIST}
)

target_include_directories(calc
        PUBLIC include
)

file(GLOB_RECURSE CALC_HEADER_LIST
        "include/*.h"
)

# 安装文件
install(FILES ${CALC_HEADER_LIST}
        DESTINATION "calc/include"

        # 打包相关 CPack
        COMPONENT "include"
)

install(FILES readme.md LICENSE
        DESTINATION "calc/doc"

        # 打包相关
        COMPONENT "doc"

        # 文件不存在不会报错, 也不会影响安装流程
        OPTIONAL
)

# 安装目录
# DIRECTORY "src/calc", 将 src/calc 目录复制到 dist/calc/src 下, 文件路径 dist/calc/src/calc/Add.cpp
# DIRECTORY "src/calc/", 将 src/calc/ 目录中的所有文件及子目录复制到 dist/calc/src 目录下, 文件路径 dist/calc/src/Add.cpp
install(DIRECTORY "src/calc/"
        DESTINATION "calc/src"
        COMPONENT "src"
)

# 安装目标
install(TARGETS calc
        # 静态库
        ARCHIVE DESTINATION "calc/lib/$<CONFIG>"
        # 动态库
        LIBRARY DESTINATION "calc/lib/$<CONFIG>"
        # 可执行文件 / windows dll文件
        RUNTIME DESTINATION "calc/bin/$<CONFIG>"
)

add_executable(demo
        src/main.cpp
)

target_link_libraries(demo
        PRIVATE calc
)

#[[
由于 calc 通过 PUBLIC 设置了头文件搜索路径:
target_include_directories(calc
        PUBLIC include
)

所以这个搜索路径会传播到 demo 中, 所以下面的设置不再需要
target_include_directories(demo
        # 不需要
        PRIVATE include
)
]]