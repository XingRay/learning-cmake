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

#[[
注意:

"$<IF:$<CONFIG:Debug>,${calc_sdk_root}/lib/Debug/calc.dll,${calc_sdk_root}/lib/Release/calc.dll>"
不能写成
"$<IF:$<CONFIG:Debug>, ${calc_sdk_root}/lib/Debug/calc.dll, ${calc_sdk_root}/lib/Release/calc.dll>"
表达式不能随意添加空格

下面的写法也是错误的,会导致无法正常执行指令:

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        $<IF:$<CONFIG:Debug>,  # 生成器表达式按配置选择
        "${calc_sdk_root}/lib/Debug/calc.so" ,
        "${calc_sdk_root}/lib/Release/calc.so"
        >
        $<TARGET_FILE_DIR:${PROJECT_NAME}>  # 目标输出目录
)

这样写, 表达式会被认为是 copy 指令的多个参数, 在构建期解析为多个字符串:
cmake -E copy "$<IF:$<CONFIG:Debug>" "xxx/lib/Debug/calc.so" "xxx/lib/Release/calc.so" > ...

不要将生成器表达式拆分为多行, 而是改为一行 "$< ... >" ,就算是嵌套也要写成一行 "$<$<...>,$<...>,...>"
而且尽量用 "$<...>" 而不是 $<...>

]]