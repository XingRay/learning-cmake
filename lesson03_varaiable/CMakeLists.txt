cmake_minimum_required(VERSION 3.31.6)
project(lesson03_varaiable)

# 创建变量
# set(var_name value0 value1 ... )
# value 可以用空格间隔, 也可以用 ";" 间隔
set(var1 a b c)
set(var2 c;d;e)
# 底层存储都是 a;b;c 的形式

set(val1 "aaa")    # val1 内容为 1 个值：aaa
set(val2 "bb" bbb) # val2 内容为 2 个值：bb;bbb
set(val3 aa;bb)    # val3 内容为 2 个值：aa;bb
set(val4 aa;bb cc) # val4 内容为 3 个值：aa;bb;cc

#访问/读取变量
# 输出: var1,
# 注意要取变量中的值, 要使用 ${var_name} 的形式, 直接使用 var_name 会被当做字符串字面值
message(var1)

# 输出 abc
# 通过 ${var_name} 取到变量保存的值, message不会输出元素之间的";"
message(${var1})

# var1:a;b;c
# 通过 ${var_name} 取到变量保存的值拼接到字符串中, message会输出元素之间的";"
message("var1:${var1}")

# 解除定义
unset(var1)
# var1 为空
message("unset(), var1:${var1}")


#CMake 默认提供的变量，也将记载在 `CMakeCache.txt` 中。具体包括
# 提供信息的变量，例如 `CMAKE_BINARY_DIR`、`PROJECT_NAME`
message("CMAKE_BINARY_DIR:${CMAKE_BINARY_DIR}")
message(PROJECT_NAME:${PROJECT_NAME})

# 改变行为的变量，例如 `CMAKE_BUILD_TYPE`
set(CMAKE_BUILD_TYPE "Debug")

# 描述系统的变量，例如 `CMAKE_SYSTEM_PROCESSOR`
# CMAKE_SYSTEM_PROCESSOR:AMD64
message(CMAKE_SYSTEM_PROCESSOR:${CMAKE_SYSTEM_PROCESSOR})

# 控制构建的变量，例如 `LIBRARY_OUTPUT_PATH`、`CMAKE_RUNTIME_OUTPUT_DIRECTORY`
set(LIBRARY_OUTPUT_PATH "build/output")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "build/output/runtime")

# 语言的变量，例如 `CMAKE_CXX_STANDARD`
set(CMAKE_CXX_STANDARD 23)

# CTest 与 CPack 的变量

# 缓存变量
# 这种变量在定义后便被添加至了 `CMakeCache.txt` 文件中，之后访问它的时候，将从 `CMakeCache.txt` 文件中调出，因此均能得到有效访问数据
# bool型缓存变量 变量名 描述 初始值
option(ORT_WITH_CUDA "the library compile with CUDA" OFF)

# 字符串 变量名 初始值 缓存 类型 描述
# CACHE 缓存变量, 生成构建工程后, 可以在 build/CMakeCache.txt 中找到
# STRING 字符串类型, 可以在gui编辑  INTERNAL 字符串, 不显示在gui上
set(VAR_STRING "init value" CACHE STRING "string, can be edit on gui")
set(VAR_HIDDEN "init value" CACHE INTERNAL "like string, but not show on gui")
set(VAR_DIR_PATH "path/to/dir" CACHE PATH "path to dir")
set(VAR_FILE_PATH "path/to/file" CACHE PATH "path to file")
set(VAR_BOOL ON CACHE BOOL "same as option")

#读取
# 通过 $CACHE{}取值, 也可以通过 ${}取值, 但是如果有同名的普通变量时, ${}读取普通变量的值
message($CACHE{VAR_STRING})
# 解除变量, 需要加 CACHE 关键字
unset(VAR_STRING CACHE)

# 环境变量
foreach (path : $ENV{Path})
    message("${path}")
endforeach ()

# 变量的使用规范
if ("1")
    # 读取变量
    set(__ocv_argn__ ${ADD_MODULE_ARGN})
    # 使用变量
    # ...

    # 解除变量
    unset(__ocv_argn__)
endif ()

# 命名规范
#普通变量可以使用小写 + 下划线的方式，例如
set(my_var "ABC")

# 缓存变量使用大写 + 下划线的方式，例如
set(MY_VAR "ABC" CACHE STRING "My variable")


# 字符串操作

# cmake默认存储都是字符串类型
# 1 拼接
set(var1 "hello")
set(var2 "world")

# 注意: 这样写 var1 var2 是字符串字面值, 而不是变量, 相当于 "var1" "var2"
set(var3 var1 var2)
# var3:var1;var2
message("var3:${var3}")

# 取变量的值要使用 ${}
# var4=var1+var2
set(var4 ${var1} ${var2})
# var4:hello;world
message("var4:${var4}")

# 可以这样实现 append 的效果, 相当于 var1+=var2
set(var1 ${var1} ${var2})
# var1:hello;world
message("var1:${var1}")


add_executable(${PROJECT_NAME}
        main.cpp
)
