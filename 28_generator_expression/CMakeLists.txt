cmake_minimum_required(VERSION 3.31.6)
project(demo)

# 生成器表达式
#[[
CMake 工作流程
CMake 工作流程分为两步，配置阶段和生成阶段。我们在命令行中输入cmake ..的时候，可以在输出内容的最后看到这样的两行话

-- Configuring done
-- Generating done

分别指代了这两个阶段


Configure 阶段
在这个阶段，CMake 会读取你的CMakeLists.txt文件，并执行其中的命令。这些命令可能会检查系统的特性（例如，查找库或者编译器特性），设置变量，
或者定义构建目标（例如库、可执行文件，或者其他伪目标）。这个阶段的主要目的是确定构建过程需要的所有信息。

Generate 阶段
在此阶段 CMake 会生成实际的建构档。这些文件包含了实际编译和链接你的代码所需要的命令，包括

各种编译选项
与目标相关的操作

的命令都是在生成阶段添加至建构档中的。比方说

target_include_directories(
  demo
  PUBLIC include
)

target_link_libraries(
  demo
  PRIVATE core
)

这两个命令均生效于生成阶段。而后文准备介绍的生成器表达式，就作用于生成阶段。也正因如此，只有能够在生成阶段生效的命令才能使用生成器表达式，
而在配置阶段生效的命令，例如用于设置变量的 set 命令并不支持生成器表达式。


CMake 的生成器表达式是什么
生成器表达式在生成构建系统期间进行计算，以生成特定于每个生成配置的信息。他们有如下形式：$<...>。可参考 Generator Expression。
https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html#introduction

为什么要引入生成器表达式
在设置某些编译选项的时候，如果当条件较多，要制作的编译选项版本也相应增多。这时可以使用生成器表达式语法，让一部分编译信息在生成阶段自动完成，
无需在配置阶段设置，示例如下：

]]

# 现计划给 Debug 和 Release 两种构建类型添加不同的编译选项
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g -O0")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")


# 使用生成器表达式可以简化成
add_compile_options(
        $<$<CONFIG:Debug>:-g -O0>
        $<$<CONFIG:Release>:-O2>
)


# 设置源码的编码
if(MSVC)
    add_compile_options("$<$<C_COMPILER_ID:MSVC>:/source-charset:utf-8>")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/source-charset:utf-8>")
else()
    add_compile_options(-finput-charset=UTF-8)
endif()


#[[

常用生成器表达式


布尔生成器表达式
逻辑运算符

$<BOOL:string>

如果字符串为空、0、不区分大小写的FALSE、OFF、N、NO、IGNORE、NOTFOUND，或者区分大小写的以-NOTFOUND结尾的字符串，则表达式的值为0，否则为1
]]

add_library(mylib ${SOURCES})

target_compile_definitions(mylib PUBLIC
        $<$<BOOL:${USE_OTHERLIB}>:USE_OTHER_LIB>
)
#[[
在这个例子中，$<BOOL:${USE_OTHERLIB}> 会检查变量 USE_OTHERLIB 是否为假。如果 USE_OTHERLIB 为假，那么这个表达式就会返回 0，否则返回 1。
然后，$<1:USE_OTHERLIB> 会在前面的表达式为真时添加一个编译定义 USE_OTHER_LIB。
]]

#[[
$<AND:conditions>：逻辑与

conditions 是以逗号分割的条件列表，一般来说，条件是列表的，都是使用逗号进行分割，后文不再赘述。逻辑运算条件成立，表达式的值为0，否则为1，后文不再赘述。
]]

add_library(mylib ${SOURCES})

target_compile_definitions(mylib PUBLIC
        # 在 debug模式 并且 存在target: other_lib 时, 增加宏定义 USE_OTHER_LIB
        $<$<AND:$<CONFIG:Debug>,$<TARGET_EXISTS:other_lib>>:USE_OTHER_LIB>
)
# 在这个例子中，$<AND:$<CONFIG:Debug>,$<TARGET_EXISTS:otherlib>>会在当前配置为Debug并且目标 otherlib 存在时返回1，否则返回0。
# 然后，$<1:USE_OTHERLIB> 会在前面的表达式为真时添加一个编译定义 USE_OTHERLIB。

#[[
$<OR:conditions>：逻辑或

在给定的任何条件为真时返回1，否则返回0
]]

add_library(mylib ${SOURCES})

target_compile_definitions(mylib PUBLIC
        $<$<OR:$<CONFIG:Debug>,$<TARGET_EXISTS:other_lib>>:USE_OTHER_LIB>
)
# 在这个例子中，$<OR:$<CONFIG:Debug>,$<TARGET_EXISTS:otherlib>>会在当前配置为 Debug 或者目标 other_lib 存在时返回 1，否则返回 0。
# 然后，$<1:USE_OTHER_LIB> 会在前面的表达式为真时添加一个编译定义 USE_OTHER_LIB。

#[[
$<NOT:condition>：逻辑非

在给定的条件为假时返回1，否则返回0
]]

add_library(mylib ${SOURCES})

target_compile_definitions(mylib PUBLIC
        $<$<NOT:$<TARGET_EXISTS:other_lib>>:USE_OTHER_LIB>
)
# 在这个例子中，$<NOT:$<TARGET_EXISTS:other_lib>>会在目标otherlib不存在时返回1，否则返回0。然后，$<1:USE_OTHER_LIB>
# 会在前面的表达式为真时添加一个编译定义 USE_OTHER_LIB。

#[[

字符串比较

判断字符串是否相等
$<STREQUAL:string1,string2>

判断数值是否相等
$<EQUAL:value1,value2>

判断string是否包含在list中，list使用分号分割
$<IN_LIST:string,list>
这里的 list 是在逗号后面的列表，即 ${...} 所表示的内容，因此其内容需要使用分号分割。

]]

#[[

变量查询

判断目标是否存在
$<TARGET_EXISTS:target>

判断编译类型配置是否包含在cfgs列表（比如"Release，Debug"）中；不区分大小写
$<CONFIG:cfgs>

判断 CMake 定义的平台ID是否包含在 platform_ids 列表中
$<PLATFORM_ID:platform_ids>

判断编译语言是否包含在 languages 列表中
$<COMPILE_LANGUAGE:languages>

]]


#[[

字符串生成器表达式
使用生成器表达式的主要目的可能就是因为此功能了。比如 CMake 官方的例子：基于编译器 ID 指定include目录：

]]

include_directories("/usr/include/$<CXX_COMPILER_ID>/")
# 根据编译器的类型，$<CXX_COMPILER_ID>会被替换成对应的ID（比如“GNU"/“Clang”/"MSVC"）。
include_directories("/usr/include/GNU/")
include_directories("/usr/include/Clang/")
include_directories("/usr/include/MSVC/")


#[[

条件表达式

如果条件为真，则结果为true_string，否则为空
$<condition:true_string>

如果条件为真，则结果为str1，否则为str2
$<IF:condition,str1,str2>

]]

#[[
字符串转换

将字符串转为小写
$<LOWER_CASE:string>

]]

add_library(mylib ${SOURCES})

set(TARGET_NAME "MYLIB")

target_compile_definitions(mylib PUBLIC
        TARGET_NAME=$<LOWER_CASE:${TARGET_NAME}>
)
# 在这个例子中， $<LOWER_CASE:${TARGET_NAME}>会将TARGET_NAME变量的值转换为小写。然后，这个小写的值会被赋给编译定义 TARGET_NAME。
# 等价于
target_compile_definitions(mylib PUBLIC
        TARGET_NAME=mylib
)

#[[

$<UPPER_CASE:string>，将字符串转为大写

还有其他很多生成器表达式, 参考:
https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html#introduction


]]


#[[

构建安装表达式
该生成器表达式属于字符串生成器表达式的一种。这个问题来自于项目的导出与安装, 在安装导出目标的时候，如果导出目标中包含的目标使用了
target_include_directories 命令，例如

]]

target_include_directories(
        my_target PUBLIC include
)

#[[
则执行 cmake .. 的操作后会出现形如

-- CMake Error in xxx/xxx/CMakeLists.txt:
-- Target "my_target" INTERFACE_INCLUDE_DIRECTORIES property contains
-- path:
--
--   "/xxx/xxx/include"
--
-- which is prefixed in the source directory.

的问题，这表示包含目录具有绝对路径，这其实是 install 指定的头文件安装路径（默认是 /usr/local/include）与 target_include_directories
指定的路径（这里是那串绝对路径 /xxx/xxx/include）互相冲突了

解决方法
最为有效且通用的解决方法是使用导出安装的生成器表达式，有 $<BUILD_INTERFACE>:xxx 和 $<INSTALL_INTERFACE:xxx，下面给出一个比较常见的示例。

]]

message("CMAKE_CURRENT_LIST_DIRS:${CMAKE_CURRENT_LIST_DIRS}")
target_include_directories(
        my_target PUBLIC
        # 在构建期 "cmake --build ./build" 的取值, 不在构建期则为空
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIRS}/include>
        # 在安装阶段 "cmake --install ./build" 的取值, 不在安装阶段取值为空
        $<INSTALL_INTERFACE:include/MyLibrary>
)

#[[
这个命令表示，将一系列内容以公开传播方式包含于目标 my_target 中，这里的一系列内容则是会根据当前处于何种方式（构建或是安装）进行选择。
BUILD_INTERFACE 表示在构建时启用，
INSTALL_INTERFACE 表示在安装时启用。

假设导出目标名为 MyModules，可以在安装路径 <path-to-install>/cmake/MyModules.cmake 下找到如下类似的语句
]]
set_target_properties(my_target PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include/MyLibrary"
)
# 这是 INSTALL_INTERFACE 生成器表达式生效的产物。

add_executable(demo
        main.cpp
)

