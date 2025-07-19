# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)

set(CMAKE_CXX_STANDARD 23)

file(GLOB_RECURSE SRC_LIST
        src/*.cpp
        src/*.c
        src/*.c++
        src/*.cxx
)

# 设置头文件的搜索目录, 使用不带 target_ 的方法会给所有的 target 设置, 会产生属性污染的问题, 不推荐使用
#include_directories(
#        include
#)

add_executable(
        demo
        ${SRC_LIST}
)
# 使用 include_directories 指令后, 每个 target 的 INCLUDE_DIRECTORIES 属性都会添加指定的值
#get_target_property(demo_include_dirs demo INCLUDE_DIRECTORIES)
## include
#message("demo_include_dirs: ${demo_include_dirs}")

# 单独给target设置头文件搜索路径, 推荐使用
# 需哟设置传递性
# PUBLIC: 传递给使用者
# PRIVATE: 不传递给使用者
# INTERFACE: 用于接口库
# 如果需要引入多个目录, 并且访问权限不一致, 可以按照下面的方式引入
#target_include_directories(
#        demo
#        PUBLIC include include2
#        PRIVATE include3
#        PRIVATE include4
#        INTERFACE include5
#)

target_include_directories(
        demo
        PUBLIC include
)
# target_include_directories 指令与直接设置属性 INCLUDE_DIRECTORIES 的值等效,
# 但是通常使用 target_include_directories 指令
#set_target_properties(demo PROPERTIES
#        INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/include"
#)

get_target_property(demo_target_include_dirs demo INCLUDE_DIRECTORIES)
message("demo_target_include_dirs:${demo_target_include_dirs}")

set_target_properties(demo PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output"
)