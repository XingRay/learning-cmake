cmake_minimum_required(VERSION 3.31.6)
project(demo)

# 允许为现有的目标创建一个可供引用的别名。别名目标可以用于简化构建过程、重命名目标或创建便于引用的名称。
# 要创建别名目标，可以使用 `add_library`、`add_executable` 或 `add_custom_target` 命令，并将 `ALIAS` 关键字与目标名称一起使用

# 添加一个库
add_library(my_library STATIC my_source.cpp)
# 创建别名目标
add_library(lib1 ALIAS my_library)
# 添加可执行文件，并链接别名目标
add_executable(my_app main.cpp)
target_link_libraries(
        my_app
        PRIVATE lib1
)
#但要注意，别名目标（例如上文中的 `lib1`）不得作为

#- `target_link_libraries`
#- `target_include_directories`

#的目标名，即不得写成
target_include_directories(
        lib1
        PUBLIC xxx
)
# 或者
target_link_libraries(
        lib1
        PRIVATE xxx
)
#的形式