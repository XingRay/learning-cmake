cmake_minimum_required(VERSION 3.31.6)
project(demo) # 可以简化

# 函数基本用法

function(my_func)
    # function
    message("call my_func")
endfunction()

# 函数调用的函数名不区分大小写，不过通常在 CMake 中函数名建议写小写。

my_func() # 可以
MY_FUNC() # 可以
mY_fUnC() # 也可以

# 动态调用
set(call_func_name "my_func")
cmake_language(CALL ${call_func_name})


# 除此之外，一个函数还打开一个新的作用域，这点与C/C++一致。同样，使用`set(xxx PARENT_SCOPE)`可以提升变量作用域。
set(scope_test_var "in root")

function(scope_test)
    set(scope_test_var "in function")
    message("#1 scope_test_var:${scope_test_var}")

    set(scope_test_var "in function modified")
    message("#2 scope_test_var:${scope_test_var}")

    set(scope_test_var "in root modified" PARENT_SCOPE)
    message("#3 scope_test_var:${scope_test_var}")
endfunction()

message("#4 scope_test_var:${scope_test_var}")
scope_test()
message("#5 scope_test_var:${scope_test_var}")


# 参数

# 使用形参
# 当函数被调用时，首先通过实参替换形参 ，然后作为普通命令调用

function(my_foo x1 x2 x3)
    message("x1 = ${x1}, x2 = ${x2}, x3 = ${x3}")
endfunction()
# x1 = 2, x2 = 7, x3 = 4
my_foo(2 7 4)

# 使用 ARGC、ARGVn
# 除了引用形参之外，还可以引用`ARGC`变量 和`ARGVn`变量来引用参数，`ARGC`表示参数数量，以及`ARGV0, ARGV1, ARGV2, ...`
# 将具有传入参数的值，有助于创建带有可选参数的函数。同时`ARGV`保存了所有的参数列表

function(my_foo)
    message("ARGC = ${ARGC}")
    message("x1 = ${ARGV0}, x2 = ${ARGV1}, x3 = ${ARGV2}")
    message("ARGV:${ARGV}")

    # 计算数学表达式
    math(EXPR max_index "${ARGC} -1")
    message("max_index:${max_index}")

    foreach (index RANGE ${max_index})
        list(GET ARGV ${index} arg_value)
        message("ARGV[${index}]: ${arg_value}")
    endforeach ()

endfunction()

my_foo(2 7 4)


# 使用 ARGN
# 此外，`ARGN`变量保存超过形参列表之后的参数。如果实参数量大于形参数量，用`ARGN`变量引用预期之外的参数。
function(my_foo x1)
    message("x1 = ${x1}")
    message("ARGN = ${ARGN}")
endfunction()
# x1 = 2
# ARGN = 7;4
my_foo(2 7 4)


# 形参为变量
# 以上的例子中，参数都为具体的值，例如`2, 7, 4`，那么变量取值的语法`${}`作用于参数，获取到的就是具体的值。如果参数为变量的话，
# 那么`${}`获取到的参数内容就是变量这个字符串，要想获取值的话就要使用 `${${}}`
set(a1 10)
function(foo val)
    message("val, ${val}, ${${val}}")
endfunction()
foo(a1)


# 参数为变量
# 以上的例子中，参数都为具体的值，例如`2, 7, 4`，那么变量取值的语法`${}`作用于形参，获取到的就是具体的值。
# 如果参数为变量的话，那么`${}`获取到的参数内容就是字符串, 内容是传入函数的变量的名字，要想获取传入参数的值的话就要使用 `${${}}`。
set(a1 10)
function(foo val)
    # ${val} => "a1"
    # ${${val}} => "${a1}" => "10"
    message(STATUS "val, ${val}, ${${val}}")
endfunction()
foo(a1)


# 参数解析
# 经常见到以下命令：
#[[

# 案例 1
target_include_directories(
  MyLib
  PUBLIC include
  PRIVATE _deps
)

# 案例 2
execute_process(
  COMMAND ls ${current_dir}
  OUTPUT_VARIABLE subs
)

]]

# 这些内置的函数和宏可以对以上的`include`、`_deps`和`ls ${current_dir}`等内容进行解析，
# 自己写的函数也可以通过 cmake_parse_arguments 实现这种参数解析的功能

# 有两个具体的用法：
#[[

cmake_parse_arguments(<prefix> <options> <one_value_keywords>
                      <multi_value_keywords> <args>...)

cmake_parse_arguments(PARSE_ARGV <N> <prefix> <options>
                      <one_value_keywords> <multi_value_keywords>)

]]

# `<options>`：表示可选关键词列表，如果传入参数包含此变量名，则为`TRUE`，反之为 `FALSE`。
# 例如，我们常见的`INTERFACE`，`PUBLIC`，`PRIVATE`都是`target_include_directories`函数中可选关键字列表中的元素。

#[[

set(options INTERFACE PUBLIC PRIVATE)
cmake_parse_arguments(xxx "${options}" "" "" ${ARGN})

]]

# `<one_value_keywords>`：表示单值关键词列表，每个关键词仅对应一个值。
# `<multi_value_keywords>`：表示多值关键词列表，每个关键词可对应多个值。

#[[

提示
1. 实际上，能用`<one_value_keywords>`的都能用`<multi_value_keywords>`。
2. 要解析的参数`<args>...`，我们一般传入为`${ARGN}`即可，一般定义的函数或宏是无参的，除非第一个参数不是关键词，那么有多少非关键词变量，定义多少形参。
举个例子

]]

function(my_function)
    set(multi_args YYY ZZZ)
    cmake_parse_arguments("ABC" "" "" "${multi_args}" ${ARGN})
    message(STATUS "YYY: ${ABC_YYY}")
    message(STATUS "ZZZ: ${ABC_ZZZ}")
endfunction()

my_function(
        YYY 123 456 789
        ZZZ abc
)

# `prefix`：我们将参数`${ARGN}`根据`<options>`，`<one_value_keywords>`，`<multi_value_keywords>`规则进行解析，
# 解析出来的新变量名根据`<prefix>`前缀，按照 `prefix_参数名`的形式进行设置，例如：

function(my_func)
    set(options INTERFACE PUBLIC PRIVATE)
    set(one_value_args NAME ID)
    set(multy_args INNER_DEPENDS OUTER_DEPENDS)
    cmake_parse_arguments(ABC "${options}" "${one_value_args}" "${multy_args}" ${ARGN})

    # 访问 options 的内容是否为 ON
    if (${ABC_INTERFACE})   # ABC_ 前缀
        message("my_func: ABC_INTERFACE")
    elseif (${ABC_PUBLIC})  # ABC_ 前缀
        message("my_func: ABC_PUBLIC")
    elseif (${ABC_PRIVATE}) # ABC_ 前缀
        message("my_func: ABC_PRIVATE")
    endif ()

    # 访问 one_value_args 的内容
    message("ABC_NAME: ${ABC_NAME}")
    message("ABC_ID: ${ABC_ID}")

    # 访问 multy_args 的内容
    message("ABC_INNER_DEPENDS: ${ABC_INNER_DEPENDS}")
    message("ABC_OUTER_DEPENDS: ${ABC_OUTER_DEPENDS}")

endfunction()
message("===========1")
my_func(
        PUBLIC
        NAME "aaa"
        ID "123"
        INNER_DEPENDS "lib1" "lib2"
        OUTER_DEPENDS "OpenCv" "Eigen"
)
message("===========2")
#my_func: ABC_PUBLIC
#ABC_NAME: aaa
#ABC_ID: 123
#ABC_INNER_DEPENDS: lib1;lib2
#ABC_OUTER_DEPENDS: OpenCv;Eigen


function(my_func x y z)
    set(options INTERFACE PUBLIC PRIVATE)
    set(one_value_args NAME ID)
    set(multy_args INNER_DEPENDS OUTER_DEPENDS)

    cmake_parse_arguments(ABC "${options}" "${one_value_args}" "${multy_args}" ${ARGN})

    message("x:${x}")
    message("y:${y}")
    message("z:${z}")

    message("x2:${${x}}")
    message("y2:${${y}}")
    message("z2:${${z}}")

    # 访问 options 的内容是否为 ON
    if (${ABC_INTERFACE})   # ABC_ 前缀
        message("my_func: ABC_INTERFACE")
    elseif (${ABC_PUBLIC})  # ABC_ 前缀
        message("my_func: ABC_PUBLIC")
    elseif (${ABC_PRIVATE}) # ABC_ 前缀
        message("my_func: ABC_PRIVATE")
    endif ()

    # 访问 one_value_args 的内容
    message("ABC_NAME: ${ABC_NAME}")
    message("ABC_ID: ${ABC_ID}")

    # 访问 multy_args 的内容
    message("ABC_INNER_DEPENDS: ${ABC_INNER_DEPENDS}")
    message("ABC_OUTER_DEPENDS: ${ABC_OUTER_DEPENDS}")

endfunction()

set(v_x "xx")
set(v_y "yy")
set(v_z "zz")
message("===========3")
my_func("xx" "${v_y}" v_z
        PUBLIC
        NAME "aaa"
        ID "123"
        INNER_DEPENDS "lib1" "lib2"
        OUTER_DEPENDS "OpenCv" "Eigen"
)
message("===========4")
#x:xx
#y:yy
#z:v_z
#x2:
#y2:
#z2:zz
#my_func: ABC_PUBLIC
#ABC_NAME: aaa
#ABC_ID: 123
#ABC_INNER_DEPENDS: lib1;lib2
#ABC_OUTER_DEPENDS: OpenCv;Eigen


add_executable(demo
        main.cpp
)