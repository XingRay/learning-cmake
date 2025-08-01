cmake_minimum_required(VERSION 3.31.6)
project(demo)

set(CMAKE_CXX_STANDARD 23)

# 在父模块定义的变量可以传递到子模块, 也就是在子模块中可以读取父模块定义的值,但是默认是通过复制传递的
set(OUTPUT_LIB_DIR ${PROJECT_SOURCE_DIR}/build/output/lib)
set(OUTPUT_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)
set(OUTPUT_EXE_DIR ${PROJECT_SOURCE_DIR}/build/output/exe)

# 添加子模块
add_subdirectory(calc)
add_subdirectory(sort)
add_subdirectory(test01)
add_subdirectory(test02)


#scope_test: scope_test01:scope test01 in root
#scope_test: scope_test01:scope_test01 modified in scope_test
#scope_test: scope_test02:scope test02 in root
#scope_test: scope_test02:scope test02 in root
#scope_test: scope_test03:scope_test03 set in child
#scope_test: scope_test04:
#demo: scope_test01:scope test01 in root
#demo: scope_test02:scope_test02 modified in scope_test
#demo: scope_test03:
#demo: scope_test04:scope_test04 set in child
set(scope_test01 "scope test01 in root")
set(scope_test02 "scope test02 in root")
add_subdirectory(scope_test)
message("${PROJECT_NAME}: scope_test01:${scope_test01}")
message("${PROJECT_NAME}: scope_test02:${scope_test02}")

message("${PROJECT_NAME}: scope_test03:${scope_test03}")
message("${PROJECT_NAME}: scope_test04:${scope_test04}")
