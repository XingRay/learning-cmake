cmake_minimum_required(VERSION 3.31.6)
project(demo)

# 接口库目标构建
# 只有头文件（`*.h`、`*.hpp`），而没有源文件（`*.c`、`*.cpp`）的情况需要创建接口库。
# 需要对只有头文件的库生成目标，并且进行链接，这种目标由于没有源文件，不会实质性的参与构建（编译），\
# 但提供了与普通目标相同的操作方式，因此接口库属于伪目标。
add_library(MyLib2 INTERFACE)
target_include_directories(
        MyLib2
        INTERFACE include # 接口库的目标只能使用 INTERFACE 属性
)
target_link_libraries(
        MyLib2
        INTERFACE xxx
)