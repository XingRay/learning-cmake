cmake_minimum_required(VERSION 3.31.6)
project(lesson05_if)

message("+--------------------+")
message("|                    |")
message("|        if          |")
message("|                    |")
message("+--------------------+")


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


# 一元运算
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

# 如果给定的名称是命令、宏或者函数这类可被调用的对象，则返回真
# 格式为：`COMMAND xxx`
if (COMMAND ocv_get_module_external_sources)
    message("ocv_get_module_external_sources is command")
endif ()

# 如果给定的变量（普通变量、缓存变量或系统环境变量）存在，则返回真
if (DEFINED var1)
    message("var1 is defined")
endif ()

# TARGET`：如果给定的名称是目标（包括二进制目标、伪目标, 则返回真。
# 格式为：`TARGET xxx`，
if (TARGET demo)
    message("demo is a target")
endif ()


# 二元运算符
# 正则表达式
set(opencv_module_name "OpenCv_Core")
if (${opencv_module_name} MATCHES "^OpenCv_")
    message("${opencv_module_name} matches regex: ^OpenCv_")
endif ()


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


add_executable(${PROJECT_NAME}
        main.cpp
)
