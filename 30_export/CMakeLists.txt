cmake_minimum_required(VERSION 3.31.6)
project(demo)
set(CMAKE_CXX_STANDARD 23)

file(GLOB_RECURSE CALC_SRC_LIST
        "src/calc/*.cpp"
)

add_library(calc STATIC
        ${CALC_SRC_LIST}
)

target_include_directories(calc
        # 编译期: ${PROJECT_SOURCE_DIR}/include , 这里不能使用相对路径
        # 安装期: calc/include, 会自动补上前缀, 如: build/dist
        PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> $<INSTALL_INTERFACE:calc/include>
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
        # 实际目录 ${CMAKE_INSTALL_PREFIX}/calc/lib/cmake/${PROJECT_NAME}
        DESTINATION "calc/lib/cmake/${PROJECT_NAME}"
)

add_executable(demo
        src/main.cpp
)

target_link_libraries(demo
        PRIVATE calc
)