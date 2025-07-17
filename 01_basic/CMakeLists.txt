# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)

# 单行注释

#[[
这是多行注释
这是多行注释
这是多行注释
]]

# 创建项目
project(
        demo                                # 设置项目名
        LANGUAGES CXX                       # 可选 指定语言，未指定的语言将不参与构建，例如 test.c 文件
        VERSION 1.0.0.0                     # 可选 版本号 major.minor.patch.tweak
        DESCRIPTION "this is a demo"        # 可选 描述信息
        HOMEPAGE_URL "http://www.xxx.com"   # 可选 项目网站
)
# project(demo) # 可以简化


# 输出日志
#输出: hello
message(STATUS "hello")
#输出: world
message(STATUS world)

# 日志级别
# 通知(默认)消息,用于输出信息。
message("important message")
message(NOTICE "notice message")
# 状态消息 有 -- ，看起来更重要
message(STATUS "normal message")

# 调试信息
message(VERBOSE "verbose message")
message(DEBUG "debug message")
message(TRACE "trace message")

# 警告信息， 程序会继续执行
# 一般警告, 表示使用者需要注意
message(WARNING "warning message")
# 用于开发时的警告，用 -Wno-dev 忽略
message(AUTHOR_WARNING "author warning message")
# 表示该功能弃用的警告
message(DEPRECATION "deprecation warning message")

# 错误,跳过生成步骤,继续执行后面程序
#message(SEND_ERROR "send error message")
# 错误,构建终止
#message(FATAL_ERROR "fatal error message")


#变量
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


# list api

# 获取list长度
set(SRC_LIST "main.cpp" "add.cpp" "sub.cpp")
list(LENGTH SRC_LIST SRC_LIST_LEN)
message("LENGTH SRC_LIST:${SRC_LIST}  len:${SRC_LIST_LEN}")

# 获取 list 中指定 index(可以有多个) 的元素(可以是对应的多个元素)
set(SRC_LIST "main.cpp" "add.cpp" "sub.cpp" "mul.cpp" "div.cpp")
list(GET SRC_LIST 1 3 SELECTED_SRC_LIST)
# SELECTED_SRC_LIST:add.cpp;mul.cpp
message("GET SELECTED_SRC_LIST:${SELECTED_SRC_LIST}")
# 索引支持负数, -1 表示倒数第1个 -3表示倒数第3个 , index不能超过 [-size, size-1]范围
list(GET SRC_LIST -1 -3 SELECTED_SRC_LIST)
# SELECTED_SRC_LIST2:div.cpp;sub.cpp
message("GET SELECTED_SRC_LIST2:${SELECTED_SRC_LIST}")


# join , 将多个字符串通过连接符相连, 如 [a b c] 通过连接符 '-'连接得到 "a-b-c"
set(var1 "aa" "bb" "cc")
list(JOIN var1 "#" JOIN_STR)
# JOIN_STR:aa#bb#cc
message("JOIN JOIN_STR:${JOIN_STR}")

# find 查找 找到了输出下标到 output_var , 否则输出 -1 到 output_var
set(word_list "abc" "zxc" "qwe" "hello" "world")
list(FIND word_list "qwe" FOUND_INDEX)
# FOUND_INDEX: 2
message("FIND FOUND_INDEX: ${FOUND_INDEX}")
list(FIND word_list "asd" FOUND_INDEX)
# FOUND_INDEX: -1
message("FIND FOUND_INDEX: ${FOUND_INDEX}")


# append 在尾部追加
set(word_list "aaa" "bbb")
list(APPEND word_list "ccc" "ddd")
# word_list:aaa;bbb;ccc;ddd
message("APPEND word_list:${word_list}")


# insert 在指定index处插入, 插入的元素从index处开始放置, 列表中被插入的部分后移
set(word_list "aa" "bb" "cc" "dd" "ee")
list(INSERT word_list 2 "xx" "yy")
# word_list:aa;bb;xx;yy;cc;dd;ee
message("INSERT word_list:${word_list}")

# prepend 在队列头部插入
set(word_list "aa" "bb" "cc" "dd" "ee")
list(PREPEND word_list "xx" "yy")
# word_list:xx;yy;aa;bb;cc;dd;ee
message("PREPEND word_list:${word_list}")

# pop_back 取出最后的元素
set(word_list "aa" "bb" "cc" "dd" "ee")
list(POP_BACK word_list POP_ITEM)
# POP_BACK POP_ITEM:ee, word_list:aa;bb;cc;dd
message("POP_BACK POP_ITEM:${POP_ITEM}, word_list:${word_list}")


# POP_FRONT 取出头部元素
set(word_list "aa" "bb" "cc" "dd" "ee")
list(POP_FRONT word_list POP_ITEM)
# POP_FRONT POP_ITEM:aa, word_list:bb;cc;dd;ee
message("POP_FRONT POP_ITEM:${POP_ITEM}, word_list:${word_list}")


# REMOVE_ITEM  删除指定元素, 根据值进行删除
set(word_list "aa" "bb" "cc" "dd" "ee")
list(REMOVE_ITEM word_list "cc" "ee")
# REMOVE_ITEM word_list:aa;bb;dd
message("REMOVE_ITEM word_list:${word_list}")


# REMOVE_ITEM  删除指定元素, 根据下标进行删除
set(word_list "aa" "bb" "cc" "dd" "ee")
list(REMOVE_AT word_list 1 3)
# REMOVE_AT word_list:aa;cc;ee
message("REMOVE_AT word_list:${word_list}")

# REMOVE_DUPLICATES 删除重复元素
set(word_list "aa" "bb" "aa" "cc" "aa" "bb")
list(REMOVE_DUPLICATES word_list)
# REMOVE_DUPLICATES word_list:aa;bb;cc
message("REMOVE_DUPLICATES word_list:${word_list}")


# REVERSE 翻转列表
set(word_list "aa" "bb" "cc" "dd" "ee")
list(REVERSE word_list)
# REVERSE word_list:ee;dd;cc;bb;aa
message("REVERSE word_list:${word_list}")

# 排序
set(word_list "ee" "aa" "bb" "dd" "cc")
list(SORT word_list)
# SORT word_list:aa;bb;cc;dd;ee
message("SORT word_list:${word_list}")
# sort 有3个参数
# COMPARE: 排序方式
#     STRING 字符串顺序[默认]
#     FILE_BASENAME: 按文件基本名（不含路径和扩展名）排序
#     NATURAL: 识别字符串中的数字序列，再按数字的字符串排序
# CASE: SENSITIVE 区分大小写  INSENSITIVE: 不区分大小写
# ORDER: 排序顺序 ASCENDING: 升序  DESCENDING:降序
list(SORT word_list
        COMPARE NATURAL
        CASE INSENSITIVE
        ORDER DESCENDING)

set(file_list "file10.txt" "file2.txt" "File1.txt" "src/file3.cpp")
# 逐字符比较 ASCII 值，不考虑数字的数值大小。
list(SORT file_list COMPARE STRING CASE SENSITIVE)
message("STRING SORT: ${file_list}")

set(file_list "src/main.cpp" "include/Header.h" "tests/test1.cpp" "lib/file10.lib")
# 比较的是 file10、Header、main、test1
list(SORT file_list COMPARE FILE_BASENAME CASE INSENSITIVE)
message("FILE_BASENAME SORT: ${file_list}")

set(file_list "src/file3.cpp" "aa/file10.txt" "src/file1.cpp" "aa/file4.txt" "src/file9.cpp" "file5.txt")
# 字符串部分安装字典顺序排序, 有数字的部分, 数字要转化为数值进行排序, 而不是字符串, 所以 5<10 , 升序: file5.txt;file10.txt
list(SORT file_list COMPARE NATURAL)
# NATURAL SORT: file4.txt;file5.txt;file10.txt;src/file1.cpp;src/file3.cpp;src/file9.cpp
message("NATURAL SORT: ${file_list}")


# if
if (1)
    message("1 is TRUE")
endif ()

if ("1")
    message("\"1\" is TRUE")
else ()
    message("\"1\" is FALSE")
endif ()

set(conditions
        # 0以外的数值都是 TRUE
        "0" "1" "2" "-1"
        # ON YES TRUE Y 不区分大小写 是 TRUE, 其他字符串全是 FALSE
        "ON" "OFF"
        "YES" "NO"
        "TRUE" "FALSE"
        "Y" "N"
        "" "abc" "yes" "no" "yEs" "ye"
        "IGNORE"
        "NOTFOUND" "FOUND" "-NOTFOUND" "OpenCv-NOTFOUND" "NOFOUND"
)

foreach (condition ${conditions})
    if (${condition})
        message("${condition} is TRUE")
    else ()
        message("${condition} is FALSE")
    endif ()
endforeach ()

# 逻辑判断 与/或/非
if ("y" AND "1")
    message("y and 1 is true")
endif ()

if ("n" OR "1")
    message("n or 1 is true")
endif ()

if (NOT "0")
    message("not 0")
endif ()

# 数值比较
if ("3" LESS "4")
    message("3<4")
endif ()

if ("6" GREATER "2")
    message("6>2")
endif ()

if ("5" EQUAL "5")
    message("5==5")
endif ()

set(a "3")
if (${a} LESS_EQUAL "4")
    message("a<=4")
endif ()

if (${a} LESS_EQUAL "3")
    message("a<=3")
endif ()

if (${a} GREATER_EQUAL "2")
    message("a>=2")
endif ()

if (${a} GREATER_EQUAL "3")
    message("a>=3")
endif ()


# 字符串比较
set(a "def")
if (a STREQUAL "def")
    message("${a} string-equal def")
endif ()

if (NOT a STREQUAL "abc")
    message("${a} not string-equal abc")
endif ()

if (a STRGREATER "abc")
    message("${a} > abc")
endif ()

if (a STRGREATER_EQUAL "abc")
    message("${a} >= abc")
endif ()

if (a STRGREATER_EQUAL "def")
    message("${a} >= def")
endif ()

if (a STRLESS "ghi")
    message("${a} < ghi")
endif ()

if (a STRLESS_EQUAL "ghi")
    message("${a} <= ghi")
endif ()

if (a STRLESS_EQUAL "def")
    message("${a} <= def")
endif ()


# 文件判断
if (EXISTS "Add.cpp")
    message("Add.cpp exist")
endif ()

if (NOT EXISTS "Abc.cpp")
    message("Abc.cpp not exist")
endif ()

if (IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    message("${CMAKE_CURRENT_SOURCE_DIR} is dir")
endif ()

if (NOT IS_DIRECTORY "Add.cpp")
    message("Add.cpp is not dir")
endif ()

if (NOT IS_SYMLINK "Add.cpp")
    message("Add.cpp is not symlink")
endif ()

if (IS_ABSOLUTE "${CMAKE_CURRENT_SOURCE_DIR}")
    message("${CMAKE_CURRENT_SOURCE_DIR} is absolute path")
endif ()

if (NOT IS_ABSOLUTE "../")
    message("../ is not absolute path")
endif ()

# 其他
set(word_list "aa" "bb" "cc")
if ("aa" IN_LIST word_list)
    message("aa is in list ${word_list}")
endif ()

# 路径判断
if (${CMAKE_CURRENT_SOURCE_DIR} PATH_EQUAL "${PROJECT_SOURCE_DIR}")
    message("${CMAKE_CURRENT_SOURCE_DIR} path equal ${PROJECT_SOURCE_DIR}")
endif ()

# 注意 path equal 与 string equal 的区别
set(path1 "/home//tom///Linux")
set(path2 "/home/tom/Linux")
if (${path1} PATH_EQUAL ${path2})
    message("${path1} path equal ${path2}")
endif ()

if (NOT ${path1} STREQUAL ${path2})
    message(" ${path1} is not string equal ${path2}")
endif ()


# 循环
set(word_list "aa" "bb" "cc")
foreach (word ${word_list})
    message("word:${word}")
endforeach ()

#[0, stop]
message("=====")
foreach (index RANGE 3)
    # 0 1 2 3
    message("index:${index}")
endforeach ()

message("=====")
foreach (index RANGE 3 10 2)
    # 3 5 7 9
    message("index:${index}")
endforeach ()

message("=====")
set(word_list1 "aa" "bb" "cc")
set(word_list2 "xx" "yy" "zz")
foreach (word ${word_list1} ${word_list2} "oo" "pp" "qq")
    message("word:${word}")
endforeach ()

message("=====2")
foreach (word IN ITEMS ${word_list1} ${word_list2})
    message("word:${word}")
endforeach ()
message("=====3")
# 注意取值方式不一样, list没有 ${}
foreach (word IN LISTS word_list1 word_list2)
    message("word:${word}")
endforeach ()

message("=====4")
# 同时遍历多个list
set(long_list "aa" "bb" "cc" "dd" "ee")
set(short_list "xx" "yy" "zz")
foreach (longItem shortItem IN ZIP_LISTS long_list short_list)
    # 循环次数由最长的list决定, 短的list在超出自身长度的循环中取值为空

    #longItem:aa, shortItem:xx
    #longItem:bb, shortItem:yy
    #longItem:cc, shortItem:zz
    #longItem:dd, shortItem:
    #longItem:ee, shortItem:
    message("longItem:${longItem}, shortItem:${shortItem}")
endforeach ()

message("=====5")
# 只设置一个循环变量时, 通过 "循环变量名_n" ,如 item_0 item_1 item_2 方式取值
foreach (item IN ZIP_LISTS long_list short_list)
    message("item_0:${item_0}, item_1:${item_1}")
endforeach ()


# while 循环
message("=====6")
set(word_list "aa" "bb" "cc")
list(LENGTH word_list list_len)
while (${list_len} GREATER 0)
    # 从列表中取出头部元素
    list(POP_FRONT word_list word)
    message("word:${word}")
    # 更新 len
    list(LENGTH word_list list_len)
endwhile ()

# 创建可执行文件, 也就是创建一个类型为 exe 的 target
add_executable(
        demo     # 目标名 target

        main.cpp # 用到的源文件, 可以用空格分隔或者多行
        Add.cpp
)
# 下面的方式可以可以的
#add_executable(
#        demo
#        main.cpp Add.cpp
#)
#
#add_executable(
#        demo
#        main.cpp;Add.cpp
#)