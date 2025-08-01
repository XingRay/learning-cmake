cmake_minimum_required(VERSION 3.31.6)
project(demo)


set(CONFIG_DIR "aa/bb/cc")

option(A "a" ON)
option(B "b" OFF)

# platform-specific config file
configure_file(
        # input-path
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates/Config.h.in"

        # output-path
        "${CMAKE_CURRENT_SOURCE_DIR}/config/Config.h"

        # 此项可选，@ONLY 表示仅将 *.in 文件中的 @xxx@ 做替换，而 ${xxx} 不做替换
        @ONLY
)


# 使用场景
# 在批量生成一系列宏定义变量，或者生成与路径有关的变量的时候，使用 `configure_file` 是很方便的，但如果只有一个或几个的宏定义变量，
# 那么使用 `configure_file` 来维护一个 `*.in` 文件将显得十分冗杂。

# CMake 添加预定义变量
# 正如上述使用场景所说，单个或少量的宏定义，使用 `configure_file` 并不方便，下面提供几个解决此问题的方法。
# add_definitions
#[[
add_definitions(-DXXX)
]]

#[[
在 main.cpp 中写入

#include <iostream>
using namespace std;

int main(int argc, char *argv[])
{

#ifdef XXX
    cout << "this is XXX" <<endl;
#endif // XXX

#ifdef YYY
    cout << "this is YYY" <<endl;
#endif // YYY

return 0;
}

]]

#编译后，运行结果如下
# this is XXX

# 需要注意的是，`add_definitions` 生效的文件为当前 `CMakeLists.txt` 文件以及 **子目录** 的 `CMakeLists.txt` 文件，可类比变量的作用域。
# 并且，对于其中一个 `CMakeLists.txt` 文件，即使写成
#[[

add_executable(demo main.cpp)
add_definitions(-DXXX)

]]

#即，在创建可执行程序这个二进制目标之后再书写 `add_definitions` ，该预编译宏定义仍然**能够生效**，因为该命令作用域生成阶段，
# 这一操作等同于使用 `g++ main.cpp -DXXX` 的命令行进行编译
# 只要构建出的目标（上面的例子是 `demo`）所在的作用域中具有预编译宏定义 `XXX`，那么该宏定义都能生效（即全局生效）。


# 与 option 配合
# 实际上，对于全局生效的 `add_definitions` 我们更多的是将其与 `option` 命令结合起来使用，参考下面的代码：
# 定义于 <opencv-path>/CMakeLists.txt 中的内容

#[[

OCV_OPTION(ENABLE_IMPL_COLLECTION "xxx" OFF )
# code
if(ENABLE_IMPL_COLLECTION)
    add_definitions(-DCV_COLLECT_IMPL_DATA)
endif()]]

#我们只需在终端中输入以下内容，即可实现该编译选项的开启，并添加对应的宏
# cmake -D ENABLE_IMPL_COLLECTION=ON ..

# 由于上文中提到 `add_definitions` 的生效机制与 CMake 中变量的作用域基本一致，因此在一个 `CMakeLists.txt` 中如果创建多个目标，
# 那么这些目标均能享有这个作用域下的 `add_definitions` 所带来的效果使用 `add_definitions` 构建的目标。具体的说，就是在

# 当前的 `CMakeLists.txt` 文件
# 子目录（使用 `add_subdirectory` 所添加的模块）的 `CMakeLists.txt` 文件中
# 生效，例如以下的布局。

#[[

project: CMakeLists
    │
    └── A: CMakeLists
         │
         ├── B: CMakeLists
         │    │
         │    └── D: CMakeLists
         │
         └── C: CMakeLists

]]



# target_compile_definitions
# 在普通库目标构建中提到了 `target_compile_definitions` 命令，这也是目标属性当中 “使用要求” 的一部分。在添加预定义宏的功能上，
# 相比于 `add_definitions`，`target_compile_definitions` 则更具有针对性，它能明确的指定是哪个目标在构建的时候引入预编译宏。


# 定义于 <opencv-path>/cmake/OpenCVModule.cmake 中 _ocv_create_module 宏中
# target_compile_definitions(${the_module} PRIVATE CVAPI_EXPORTS)


# 在 `<opencv-path>/modules/core/src` 文件夹下的 `system.cpp` 这一源文件，有引用到 `CVAPI_EXPORTS` 的地方：

#[[

#if defined CVAPI_EXPORTS && defined _WIN32 && !defined WINCE
// ...
#endif

]]

# 它为指定的模块添加预编译宏，使得该宏不会被暴露给非指定的目标，因此会很安全。并且，一般设置为 `PRIVATE` 的预编译宏不能被其余包含该目标的其他目标所共享，
# 这与 CMake 目标构建时接触到的 `target_include_directories` 以及 `target_link_libraries` 的用法类似，也就是说，以下代码

#[[

target_compile_definitions(
my_lib
PUBLIC xxx
)

]]

# 可以实现其他目标在链接 `my_lib` 这个目标的时候同样享有 `xxx` 这个预编译宏定义。







add_executable(my_app main.cpp)
