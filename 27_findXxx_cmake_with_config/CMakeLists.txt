# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)
set(CMAKE_CXX_STANDARD 23)

# 让 CMake 工程能够找到 FindCalc.cmake
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# 找到 SDK
find_package(Calc)

# 添加可执行文件并链接
set(SRC_LIST main.cpp)

add_executable(
        ${PROJECT_NAME}
        ${SRC_LIST}
)

target_link_libraries(
        ${PROJECT_NAME}
        PRIVATE calc
)

# 编译完成后将 calc.dll/so 文件复制到 exe 所在目录
if (WIN32)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy
            # 生成器表达式按配置选择
            "$<IF:$<CONFIG:Debug>,${calc_sdk_root}/lib/Debug/calc.dll,${calc_sdk_root}/lib/Release/calc.dll>"
            $<TARGET_FILE_DIR:${PROJECT_NAME}>  # 目标输出目录
    )
else ()
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy
            "$<IF:$<CONFIG:Debug>,${calc_sdk_root}/lib/Debug/calc.so,${calc_sdk_root}/lib/Release/calc.so>"
            $<TARGET_FILE_DIR:${PROJECT_NAME}>  # 目标输出目录
    )
endif ()