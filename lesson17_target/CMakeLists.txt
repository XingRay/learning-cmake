cmake_minimum_required(VERSION 3.31.6)
project(lesson17_target)

# 给所有的target定义宏 GLOBAL_DEF1 GLOBAL_DEF2 不推荐这种方式, 推荐使用 target_compile_definitions
add_definitions(-DGLOBAL_DEF1 -DGLOBAL_DEF2)

add_executable(${PROJECT_NAME}
        main.cpp
)

#[[

目标库的划分，可简单分为两类：二进制目标、伪目标，其大致内容如下

├── 二进制目标
│   ├── 可执行文件
│   └── 二进制库
│       ├── 普通库（动态库、静态库）
│       └── 对象库
└── 伪目标
├── 导入目标
├── 别名目标
└── 接口库

]]


# 注意，此处生成的动态库 `my_lib_shared.so` 无法做到内存上的复用，在多个进程使用到该动态库时，仍然会开辟一块内存存储该动态库内容。
# 为了真正实现内存上的复用，需要使用地址无关代码机制(position-independent code)
add_library(my_lib_shared SHARED)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")


# target 不需要在与调用`target_link_libraries`命令相同的目录中被定义
# 即使上文的`my_main`在父目录的作用域，`xxxx`在子目录的作用域，`my_main`所在的`CMakeLists.txt`也能访问到`xxxx`这一目标变量。
# 这一点有别于普通的变量，可以当做是具有目标属性的变量的专属功能。


# 传递方式
#PUBLIC    : 在绑定当前目标时给指定的内容设置公有属性，其他目标在链接当前目标时，能访问这些指定的内容
#PRIVATE   : 在绑定当前目标时给指定的内容设置私有属性，其他目标在链接当前目标时，无法访问这些内容
#INTERFACE : 在绑定当前目标时给指定的内容设置接口属性，通常在接口库中使用。其他目标在链接当前目标时，只允许访问其声明（接口）

# 添加头文件
target_include_directories(${PROJECT_NAME} PUBLIC include)

# 将给 demo 添加链接的库 depend_lib
target_link_libraries(
        ${PROJECT_NAME}
        PUBLIC depend_lib
)

# 给指定的 target 添加预编译宏定义
# PRIVATE 规定 demo 的 TEST_DEF1 TEST_DEF2 预编译宏不传递给其余目标
# PUBLIC 规定 demo 的 TEST_PUB_DEF1 预编译宏将会传递给其余目标
# 生成的建构档中会包含形如以下的内容 gcc -fPIC -shared main.cpp -o libmylib1.so -D HAVE_ABC
target_compile_definitions(${PROJECT_NAME}
        PRIVATE TEST_DEF1 TEST_DEF2
        PUBLIC TEST_PUB_DEF1
)

# 这句命令表示，在构建 mylib1 目标时添加 -Wall 选项
# PUBLIC 规定 mylib1 的 -Wall 编译选项将会传递给其余目标
# 生成的建构档中会包含形如以下的内容 gcc -fPIC -shared main.cpp -o libmylib1.so -Wall
target_compile_options(mylib1
        PUBLIC -Wall
)

if (MSVC)
    target_compile_options(myLib1
            PRIVATE -W4
    )
endif ()
target_compile_options(myLib1
        PRIVATE -Werror
)


# 目标属性
# https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#id4

# 获取目标属性
get_target_property(myLib1_prop_value myLib1 INCLUDE_DIRECTORIES)

# 设置目标属性

# 为单个目标设置单个属性
set_target_properties(myLib1 PROPERTIES
        INCLUDE_DIRECTORIES "include"
)
# 为单个目标设置多个属性
set_target_properties(myLib1 PROPERTIES
        INCLUDE_DIRECTORIES "include"
        LINK_DIRECTORIES "lib"
)
# 为多个目标设置属性
set_target_properties(myLib1 my_lib_shared PROPERTIES
        INCLUDE_DIRECTORIES "include"
        LINK_DIRECTORIES "lib"
)


# 非必要不使用全局包含、链接, 如 link_library  include_directories 语句，会影响所有子目录的构建，带来污染问题。但有些情况下这些语句可以实现其他功能。
# 例如 target_include_directories 可以将内容绑定到目标并且在导出目标后依赖关系仍然生效，而使用 include_directories 可以避免安装后仍然存在依赖关系。


# 当需要访问第三方库的时候，第三方库需要提供头文件（类似于 `*.h` 和 `*.hpp`）和库文件（包括动态库 `*.so` 和静态库 `*.a` 两种形式）。
# 提示
# Windows 下的库文件有两种形式
# 动态库`*.dll`以及导入库`*.lib`
# 静态库`*.lib`
# 在访问本项目的库`A`时，如果已经使用了`target_include_directories`的`PUBLIC`属性，将头文件路径绑定在了目标`A`中，那么目标`B`在访问`A`的时候，只需要
# target_link_libraries(B PUBLIC A)
# 即可访问到`A`所包含的头文件路径。

# 在访问其他项目的第三方库时，用户需要单独获取对应的库文件与头文件路径进行链接，例如 OpenCV：
add_executable(xxx main.cpp)
#[[
target_include_directories(
        xxx
        PUBLIC ${OpenCV_INCLUDE_DIRS}
)

target_link_libraries(
        xxx
        PRIVATE ${OpenCV_LIBS}
)
]]

# 但实际上，`OpenCV_LIBS` 是包含了众多导入目标的列表变量，例如 `opencv_core;opencv_highgui`，并且列表中的每个变量都设置了 `INTERFACE_INCLUDE_DIRECTORIES` 的属性。
# 不写 `target_include_directories` 命令也是正确的：
#[[

add_executable(xxx main.cpp)

target_link_libraries(
        xxx
        PRIVATE ${OpenCV_LIBS}
)

]]

