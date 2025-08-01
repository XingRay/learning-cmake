cmake_minimum_required(VERSION 3.31.6)
project(demo)

# 使用第三方库时, 可能遇到仅提供了若干头文件和若干库文件（例如 `*.so` 和 `*.a`）
# 在这种情况下我们无法通过自己 `add_library` 从源文件创建目标，我们需要引入导入目标
add_library(camera SHARED IMPORTED)

# 引入头文件方式 1
target_include_directories(
        camera
        INTERFACE include
)

# 引入头文件方式 2
set_target_properties(camera PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/include"
)

set_target_properties(camera PROPERTIES
        # 注意要指定绝对路径
        # 对于 `lib` 目录中存在多个 `*.so` 等动态库的情况下，请找到真正的动态库（其他动态库一般是陪衬的）
        IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/libMVSDK.so"
)
