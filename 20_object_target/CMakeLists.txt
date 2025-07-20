cmake_minimum_required(VERSION 3.31.6)
project(demo)

# 允许将多个源文件设置为一个单独的目标，而不生成可执行文件或普通库。对象库可以被其他目标（例如可执行文件或普通库）链接和使用。
# 要创建一个对象库，使用 add_library 命令，并将 OBJECT 关键字与源文件列表一起使用

# 添加对象库
add_library(
        my_object_lib
        OBJECT file1.cpp file2.cpp file3.cpp
)
# 添加可执行文件，并链接对象库
add_executable(my_app main.cpp)
target_link_libraries(my_app PRIVATE my_object_lib)

# 通过这种方式，对象库中的源文件将会被编译为目标文件，但不会生成一个独立的可执行文件或共享库。
# 其他目标可以链接到对象库，并在链接时使用其中的目标文件和 “使用要求”

# 添加名为 obj 的对象库
add_library(obj OBJECT obj.cpp)
# 将 include 目录添加到 obj 的包含目录中
target_include_directories(obj PUBLIC include)

# 添加名为 bbb 的动态库
add_library(bbb SHARED bbb.cpp)
# 链接 obj 对象库，obj 的包含目录将会传递给 bbb
target_link_libraries(bbb PUBLIC obj)

# 提示
#此时 `bbb` 动态库将由 `bbb.cpp.o` 和 `obj.cpp.o` 两个目标文件制作而成，其中 `obj.cpp.o` 由 `obj` 对象库编译而来，`bbb.cpp.o` 由 `main.cpp` 编译而来。这里只是编译，没有链接。
#但要注意，对象库所指代的对象文件（例如上文的 `obj` 对象库则指代 `obj.cpp.o`）不会从 `bbb` 传递到其他目标，例如现在再写入以下命令
add_executable(demo main.cpp)
target_link_libraries(demo PRIVATE bbb)
# obj 对象库的 `obj.cpp.o` 对象文件不会传递给 `demo` 可执行文件目标，可参考 CMake 官网的文档了解更多关于对象库的内容