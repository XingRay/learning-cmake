# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)
set(CMAKE_CXX_STANDARD 23)

message("+--------------------+")
message("|                    |")
message("|    findXxx.cmake   |")
message("|                    |")
message("+--------------------+")

#[[

FindXXX.cmake 简单写法
我们使用 Module 模式，写一个 FindXXX.cmake 文件，来体验一下自己的find_package

案例
假设某 SDK 提供了以下内容，假设将其放在了 /libs/calc 文件夹下，请创建一个 Demo 项目，并设计一个 FindCamera.cmake
文件供本项目中的其余目标包含，使其能够链接至 calc-SDK。

+---include
|       Add.h
|       LibMacros.h
|       Sub.h
|
\---lib
        calc.dll
        calc.lib


分析
我们在目标构建的导入目标中遇到过类似的情况，但这里的 calc-SDK 并没有位于本项目中。
注意到 SDK 并无提供相应的 CalcConfig.cmake 或 calc-config.cmake 文件，因此需要自己手写 FindCalc.cmake 文件。
我们先把项目的部署框架给大概定义好：

.
├── cmake
│   └── FindCalc.cmake
├── CMakeLists.txt
└── main.cpp
涉及到的两个 CMake 文件已经标红，这里简单描述一下

FindCalc.cmake：其他库直接包含、链接 SDK 提供的库肯定是不行的，需要事先找到 SDK 的路径，此文件就是为了提前让整个 CMake 工程找到此 SDK。

项目根目录的 CMakeLists.txt：框架整体配置，包括项目、编译属性、可执行程序的配置。这里 main.cpp 直接用到了 SDK 的内容，通过以下语句进行链接


target_link_libraries(
  demo
  PRIVATE calc
)

配置

项目根目录的 CMakeLists.txt

主要目的
设置 CMAKE_MODULE_PATH 模块模式的工作路径
解析 FindCalc.cmake，并找到 calc 对应的库
创建可执行程序目标并链接

]]

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

# 编译完成后将 calc.dll 文件复制到 exe 所在目录
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        "${calc_sdk_root}/lib/calc.dll"
        $<TARGET_FILE_DIR:${PROJECT_NAME}>
)
