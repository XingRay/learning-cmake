# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)

set(CMAKE_CXX_STANDARD 23)

file(GLOB_RECURSE CALC_SRC_LIST
        src/calc/*.cpp
)

# 第一个参数是生成的库(target)的名称
# 第二个参数是生成库的类型, 制作动态库时设置为 SHARED
add_library(
        calc
        SHARED
        ${CALC_SRC_LIST}
)

target_include_directories(
        calc
        PUBLIC include
)

# 如果在 windows 平台
if (WIN32)
    # 为 calc 编译添加宏定义
    target_compile_definitions(calc
            PRIVATE LIB_STORAGE_SHARED LIB_STORAGE_SHARED_EXPORT
    )
endif ()

# calc 是 动态库 target,
# 在windows中认为是 runtime, 输出目录由 RUNTIME_OUTPUT_DIRECTORY 属性决定
# 在 linux/macos 中认为是 library, 输出目录由 LIBRARY_OUTPUT_DIRECTORY 属性决定
# 编译输出 \build\output\runtime\Release\calc.dll
#set_target_properties(calc PROPERTIES
#        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/runtime"
#        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/library"
#        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/archive"
#)

# 如果希望在不同平台都输出到相同的目录, 可以如下设置
set(CALC_LIB_PATH "${CMAKE_SOURCE_DIR}/build/output/calc_lib")
# 输出: \build\output\calc_lib\Release\calc.dll
set_target_properties(calc PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CALC_LIB_PATH}
        LIBRARY_OUTPUT_DIRECTORY ${CALC_LIB_PATH}
        ARCHIVE_OUTPUT_DIRECTORY ${CALC_LIB_PATH}
)