# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)





# 设置 C++ 标准, 11 14 17 20 23 26

# #include <format>需要会报错, 需要 c++20
# error C2039: 'format': is not a member of 'std'
#set(CMAKE_CXX_STANDARD 17)

# 正常编译输出
set(CMAKE_CXX_STANDARD 20)
# 也可以通过下面的指令设置
# cmake -S . -B ./build -DCMAKE_CXX_STANDARD=20


set(SRC_LIST main.cpp Add.cpp)

add_executable(
        demo
        ${SRC_LIST}
)

# 项目生成时的目录, 也就是 cmake 指令的 -B 参数指定目录
message(STATUS "CMAKE_SOURCE_DIR:${CMAKE_SOURCE_DIR}")

# 当前 cmake 脚本所在的目录, 项目只有一个 cmake脚本时, 与 CMAKE_SOURCE_DIR 相等
# 但是有多个 cmake脚本通过 add_subdirectories 指令嵌套时,
# 子目录中的cmake脚本中的 CMAKE_CURRENT_SOURCE_DIR 的取值会表示自身所在的路径
message(STATUS "CMAKE_CURRENT_SOURCE_DIR:${CMAKE_CURRENT_SOURCE_DIR}")

# 设置可执行文件、库文件的输出路径（相对路径或绝对路径）
# 统一设置所有target的输出目录, 可以通过 set_target_properties 修改指定 target 的输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/build/output/runtime)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/build/output/library)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/build/output/archive)

# 通过 target 的 [LIBRARY/RUNTIME/ARCHIVE]_OUTPUT_DIRECTORY 属性设置输出目录
# windows 中 可执行文件(.exe)和动态库(.dll)属于 runtime , 静态库(.lib)属于 archive
# linux/macos中 可执行文件属于runtime, 动态库（.so/.dylib）属于 library 静态库(.a)属于archive
# 这个 target 在编译平台上是什么类型, 就设置对应的属性的值为想要输出的目录,
# 如这里是windows平台下编译可执行文件, 那么设置 RUNTIME_OUTPUT_DIRECTORY 属性即可
set_target_properties(demo PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build/output"
)

# windows: CMAKE_SYSTEM_NAME:Windows
message("CMAKE_SYSTEM_NAME:${CMAKE_SYSTEM_NAME}")
# vs: CMAKE_C_COMPILER:C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe
message("CMAKE_C_COMPILER:${CMAKE_C_COMPILER}")
# vs: CMAKE_CXX_COMPILER:C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe
message("CMAKE_CXX_COMPILER:${CMAKE_CXX_COMPILER}")
