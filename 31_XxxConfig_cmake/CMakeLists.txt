cmake_minimum_required(VERSION 3.31.6)
project(calc)
set(CMAKE_CXX_STANDARD 23)

file(GLOB_RECURSE CALC_SRC_LIST
        "src/calc/*.cpp"
)

# 手动指定库的类型
#add_library(calc STATIC
#        ${CALC_SRC_LIST}
#)

# 不手动指定库的类型的情况下, 由 BUILD_SHARED_LIBS 变量控制, BUILD_SHARED_LIBS 默认为 OFF ,也就是编译静态库
message("BUILD_SHARED_LIBS:${BUILD_SHARED_LIBS}")
add_library(calc
        ${CALC_SRC_LIST}
)

target_include_directories(calc
        # 编译期: ${PROJECT_SOURCE_DIR}/include , 这里不能使用相对路径
        # 安装期: calc/include, 会自动补上前缀, 如: build/dist
        PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> $<INSTALL_INTERFACE:calc/include>
)

# 如果在 windows 平台
if (WIN32)
    # 为 calc 编译添加宏定义
    target_compile_definitions(calc
            PRIVATE LIB_STORAGE_SHARED LIB_STORAGE_SHARED_EXPORT
    )
endif ()

# cmake --build xxx 中的 xxx 参数所指代的目录
message("CMAKE_CURRENT_BINARY_DIR:${CMAKE_CURRENT_BINARY_DIR}")
set_target_properties(calc PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/output/runtime
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/output/lib
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/output/lib
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
# 声明导出目标
# 注意参数的顺序必须是
#[[
TARGETS xxx
EXPORT xxxModule
#其他参数
...
]]
install(TARGETS calc

        EXPORT CalcModule

        # 静态库
        ARCHIVE DESTINATION "calc/lib/$<CONFIG>"
        # 动态库
        LIBRARY DESTINATION "calc/lib/$<CONFIG>"
        # 可执行文件 / windows dll文件
        RUNTIME DESTINATION "calc/bin/$<CONFIG>"

)

# 导出目标是个虚拟的概念, 还需要真正的导出成文件才能被其他的用户使用
install(EXPORT CalcModule
        # 导出的文件名 CalcModule.cmake CalcModule-release.cmake CalcModule-debug.cmake
        FILE CalcModule.cmake
        # 导出文件所在的目录(相对于 ${CMAKE_INSTALL_PREFIX}的目录)
        # 实际目录 ${CMAKE_INSTALL_PREFIX}/calc/lib/cmake
        DESTINATION "calc/lib/cmake"
)


# CalcConfig.cmake 中需要使用的参数
# 记录库的实际构建类型（固化到配置文件中）
if (BUILD_SHARED_LIBS)
    set(Calc_BUILD_TYPE "SHARED")
else ()
    set(Calc_BUILD_TYPE "STATIC")
endif ()
configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/cmake/CalcConfig.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/cmake/CalcConfig.cmake

        # 此项可选，@ONLY 表示仅将 *.in 文件中的 @xxx@ 做替换，而 ${xxx} 不做替换
        @ONLY
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/cmake/CalcConfig.cmake
        DESTINATION "calc/lib/cmake"

        # 打包相关
        COMPONENT "cmake"
)

add_executable(demo
        test/main.cpp
)

target_link_libraries(demo
        PRIVATE calc
)

# 当编译动态库时, 编译demo后需要将 dll文件复制到exe目录
if (${BUILD_SHARED_LIBS})
    if (WIN32)
        add_custom_command(TARGET demo POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                "${CMAKE_CURRENT_BINARY_DIR}/output/runtime/$<CONFIG>/calc.dll"
                "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>"
        )
    endif ()
endif ()
