# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)

set(CMAKE_CXX_STANDARD 23)

file(GLOB_RECURSE CALC_SRC_LIST
        src/calc/*.cpp
)

# 旧式全局路径变量（不推荐）
# 所有可执行文件（通过 add_executable 创建的目标）, 影响项目中所有可执行文件，无法针对特定目标单独设置,
# 已被 CMAKE_RUNTIME_OUTPUT_DIRECTORY 替代
#set(EXECUTABLE_OUTPUT_PATH "")
# 全局设置库文件（静态库、动态库）的输出目录, 无法区分静态库（.a/.lib）和动态库（.so/.dll），灵活性差
# 已被 CMAKE_ARCHIVE_OUTPUT_DIRECTORY 和 CMAKE_LIBRARY_OUTPUT_DIRECTORY 替代
#set(LIBRARY_OUTPUT_PATH "")


# 现代目标级路径变量, 影响项目中所有可执行文件，无法针对特定目标单独设置
# 所有静态库（STATIC 类型库）
#set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "")
# 所有动态库（SHARED/MODULE 类型库）
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "")
# 所有可执行文件和 Windows 动态库（.dll）
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "")

# 第一个参数是生成的库(target)的名称
# 第二个参数是生成库的类型, STATIC静态库或者 SHARED 动态库, 可以省略, 默认是STATIC
# 这里制作静态库, 选择 STATIC
#add_library(
#        calc
#        STATIC
#        ${CALC_SRC_LIST}
#)

#  或者省略 STATIC
add_library(
        calc
        ${CALC_SRC_LIST}
)

target_include_directories(
        calc
        PUBLIC include
)

# calc 是静态库 target,  所以输出目录由 ARCHIVE_OUTPUT_DIRECTORY 属性决定
# 编译输出 \build\output\archive\Release\calc.lib
# 这里设置 RUNTIME_OUTPUT_DIRECTORY LIBRARY_OUTPUT_DIRECTORY 没有作用
set_target_properties(calc PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/runtime"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/library"
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/archive"
)