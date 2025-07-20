cmake_minimum_required(VERSION 3.31.6)
project(demo) # 可以简化

# 宏的定义
macro(myFun)
    # macro
    message("message in macro")
endmacro()

myFun()

# 动态调用
# 可以使用`cmake_language(CALL ...)`子命令来调用宏：
cmake_language(CALL myFun)


# 宏与函数最大的区别就是，宏不会创建新的作用域，而是单纯的发生了文本替换，这与C/C++完全一致
set(root_var "var in root")
macro(myMacro)
    message("root_var#1:${root_var}")
    set(root_var "update by macro")
    message("root_var#2:${root_var}")
endmacro()

message("root_var#3:${root_var}")
myMacro()
message("root_var#4:${root_var}")
# 输出:
#root_var#3:var in root
#root_var#1:var in root
#root_var#2:update by macro
#root_var#4:update by macro
# macro修改的就是定义在外部的 root_var , 没有创建作用域, 也就没有创建同名副本


# 参数
#与函数一样，同样可以设置参数，也同时具备`ARGC`、`ARGV`、`ARGVx`、`ARGN`的参数，如果这些参数在宏内部进行引用，调用该宏的时候，这些内容会发生替换，例如
macro(my_macro xx)
    message("xx   = ${xx} => ${${xx}}")   # 这里的 ${xx} 会被直接替换为 aa
    message("ARGC = ${ARGC}") # 这里的 ${ARGC} 会被直接替换为 3
    message("ARGV = ${ARGV}") # 这里的 ${ARGV} 会被直接替换为 aa;bb;cc
endmacro()
set(aa "value_aa")

#xx   = aa => value_aa
#ARGC = 3
#ARGV = aa;bb;cc
my_macro(aa bb cc)


# 宏与函数的区别
# 宏不会开辟新的作用域(文本替换)，因此在宏内部定义的变量，将在外部继续生效
macro(test)
    set(val "666")
endmacro()

set(val "123")
message("val = ${val}")
test()
message("val = ${val}")
#val = 123
#val = 666

#这一点在函数就不会出现，内部设置的变量一般无法覆盖外部的变量，但如果需要覆盖，可以使用 `PARENT_SCOPE` 提升作用域。

# 宏在被调用的范围内有一个同名的变量，将使用现有变量而不是参数
macro(aaa)
    # 输出: ARGN
    message(ARGN)
    # 输出: $ARGN:x;y;z ,原因: 这里宏展开后直接就是 message("$ARGN:x;y;z")
    message("$ARGN:${ARGN}")
    # 报错, 宏展开后: message("$$ARGN:${x;y;z}")
    # message("$$ARGN:${${ARGN}}")

    # 这里的 ${ARGN} 在调用时会发生替换，替换为 x;y;z => foreach (m x;y;z)
    foreach (m ${ARGN})
        message("m = ${m}")
    endforeach ()
    message("================")
    # 这里的 ARGN 没有引用，在调用时不会发生替换, 宏展开后还是 foreach (m IN LISTS ARGN)
    foreach (m IN LISTS ARGN)
        message("m = ${m}")
    endforeach ()
endmacro()

function(bbb)
    aaa(x y z)
endfunction()

bbb(a b c)


macro(add_module name)
    # 参数解析
    set(multy_args DEP_LIBS)
    cmake_parse_arguments(
            # prefix 每个key在取对应的值的时候,要统一添加的前缀, 如要取 DEP_LIBS 对应的值, 要使用  ${MOD_DEP_LIBS}
            MOD

            # option 表示可选关键词列表, 列表中的每个元素都是一个可选的关键字, 如果传入参数包含此变量名，则为`TRUE`，反之为 `FALSE`
            ""

            # one_value_keyword, 参数中, 这些key对应单个值
            ""

            # multi_value_keyword, 参数中, 这些key对用多个值
            # 实际上，能用`<one_value_keywords>`的都能用`<multi_value_keywords>`
            # 要解析的参数`<args>...`，我们一般传入为`${ARGN}`即可，一般定义的函数或宏是无参的，
            # 除非第一个参数不是关键词，那么有多少非关键词变量，定义多少形参。
            "${multy_args}"

            # arg
            ${ARGN}
    )

    # 创建 target
    aux_source_directory(src _src_dir)
    add_library(${name} SHARED ${_src_dir})
    # 设置 target 属性
    target_include_directories(${name} PUBLIC include)
    target_link_libraries(${name} PUBLIC ${MOD_DEP_LIBS})
    unset(_src_dir)
endmacro()


macro(my_macro)
    set(options INTERFACE PUBLIC PRIVATE)
    set(one_value_args NAME ID)
    set(multy_args INNER_DEPENDS OUTER_DEPENDS)
    cmake_parse_arguments(ABC "${options}" "${one_value_args}" "${multy_args}" ${ARGN})

    # 访问 options 的内容是否为 ON
    if (${ABC_INTERFACE})   # ABC_ 前缀
        message("my_macro: ABC_INTERFACE")
    elseif (${ABC_PUBLIC})  # ABC_ 前缀
        message("my_macro: ABC_PUBLIC")
    elseif (${ABC_PRIVATE}) # ABC_ 前缀
        message("my_macro: ABC_PRIVATE")
    endif ()

    # 访问 one_value_args 的内容
    message("ABC_NAME: ${ABC_NAME}")
    message("ABC_ID: ${ABC_ID}")

    # 访问 multy_args 的内容
    message("ABC_INNER_DEPENDS: ${ABC_INNER_DEPENDS}")
    message("ABC_OUTER_DEPENDS: ${ABC_OUTER_DEPENDS}")

endmacro()
message("==========1")
my_macro(
        PUBLIC
        NAME "aaa"
        ID "123"
        INNER_DEPENDS "lib1" "lib2"
        OUTER_DEPENDS "OpenCv" "Eigen"
)
message("==========2")
#my_macro: ABC_PUBLIC
#ABC_NAME: aaa
#ABC_ID: 123
#ABC_INNER_DEPENDS: lib1;lib2
#ABC_OUTER_DEPENDS: OpenCv;Eigen


macro(my_macro x y z)
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
        message("my_macro: ABC_INTERFACE")
    elseif (${ABC_PUBLIC})  # ABC_ 前缀
        message("my_macro: ABC_PUBLIC")
    elseif (${ABC_PRIVATE}) # ABC_ 前缀
        message("my_macro: ABC_PRIVATE")
    endif ()

    # 访问 one_value_args 的内容
    message("ABC_NAME: ${ABC_NAME}")
    message("ABC_ID: ${ABC_ID}")

    # 访问 multy_args 的内容
    message("ABC_INNER_DEPENDS: ${ABC_INNER_DEPENDS}")
    message("ABC_OUTER_DEPENDS: ${ABC_OUTER_DEPENDS}")
endmacro()

set(v_x "xx")
set(v_y "yy")
set(v_z "zz")

message("==========3")
my_macro("xx" "${v_y}" v_z
        PUBLIC
        NAME "aaa"
        ID "123"
        INNER_DEPENDS "lib1" "lib2"
        OUTER_DEPENDS "OpenCv" "Eigen"
)
message("==========4")
#x:xx
#y:yy
#z:v_z
#x2:
#y2:
#z2:zz
#my_macro: ABC_PUBLIC
#ABC_NAME: aaa
#ABC_ID: 123
#ABC_INNER_DEPENDS: lib1;lib2
#ABC_OUTER_DEPENDS: OpenCv;Eigen


# RMVL中使用有关添加测试用例的宏

# 在当前目录中添加新的测试用例
# 用法:
# rmvl_add_test(
#   <name>
#   [DEPENDS <rmvl_target>]
#   [DEPEND_TESTS <test_target>]
# )
# 示例:
# rmvl_add_test(
#   detector                       # 测试名
#   DEPENDS armor_detector         # 需要依赖的 RMVL 目标库
#   DEPEND_TESTS GTest::gtest_main # 需要依赖的第三方测试工具目标库
# )
macro(rmvl_add_test _name)
    # add arguments variable
    set(multy_args DEPENDS DEPEND_TESTS)
    cmake_parse_arguments(TEST "" "" "${multy_args}" ${ARGN})
    # add testing executable
    set(test_dir)
    aux_source_directory(test test_dir)
    add_executable(rmvl_${_name}_test ${test_dir})
    # depends
    foreach (_dep ${TEST_DEPENDS})
        target_link_libraries(
                rmvl_${_name}_test
                PRIVATE rmvl_${_dep}
        )
    endforeach (_dep ${TEST_DEPENDS})
    # test depends
    target_link_libraries(
            rmvl_${_name}_test
            PRIVATE ${TEST_DEPEND_TESTS}
    )
    gtest_discover_tests(rmvl_${_name}_test)
endmacro(rmvl_add_test _name)


add_executable(demo
        main.cpp
)