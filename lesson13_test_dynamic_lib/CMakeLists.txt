# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(lesson13_test_dynamic_lib)

set(CMAKE_CXX_STANDARD 23)

file(GLOB_RECURSE DEMO_SRC_LIST
        src/*.cpp
)

#add_library(calc SHARED IMPORTED)
#set_target_properties(calc PROPERTIES
##        IMPORTED_IMPLIB "${CMAKE_SOURCE_DIR}/lib/calc.lib"   # 虚构的.lib路径（占位）
#        IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/calc.dll" # 实际.dll路径
#)

add_executable(
        ${PROJECT_NAME}
        ${DEMO_SRC_LIST}
)

# 为目标指定链接库的名称
# Windows平台下动态库的链接机制与Linux/macOS不同，CMake在链接阶段需要.lib文件（动态库的导入库），而非直接使用.dll文件
target_link_libraries(
        ${PROJECT_NAME}
        PRIVATE calc
)

# 为目标指定搜索库的目录
target_link_directories(
        ${PROJECT_NAME}
        PRIVATE lib
)

# 为目标指定搜索头文件的目录
target_include_directories(
        ${PROJECT_NAME}
        PRIVATE include
)

# 实测可以加这个定义, 也可以不加
#if (WIN32)
#    target_compile_definitions(demo
#            PRIVATE LIB_STORAGE_SHARED
#    )
#endif ()

# 配置输出目录
set_target_properties(demo PROPERTIES
        # exe文件输出目录
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/runtime"

        # 对exe无效
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/library"
        # 对exe无效
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output/archive"
)

if (WIN32)
    # path/to/cmake.exe
    message("CMAKE_COMMAND:${CMAKE_COMMAND}")
    # (CMakeLists.txt).dir
    message("CMAKE_SOURCE_DIR:${CMAKE_SOURCE_DIR}")

    # 构建完成后, 将 lib/calc.dll 复制到exe输出目录中, exe启动时会自动加载 dll 文件
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
            # cmake -E copy ./lib/calc.dll ./build/output/runtime/Release/calc.dll
            COMMAND ${CMAKE_COMMAND} -E copy
            "${CMAKE_SOURCE_DIR}/lib/calc.dll"
            "${CMAKE_SOURCE_DIR}/build/output/runtime/Release"
    )
endif ()