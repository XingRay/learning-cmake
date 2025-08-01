cmake_minimum_required(VERSION 3.31.6)
project(learning-cmake)

set(CMAKE_CXX_STANDARD 23)

# 自动添加测试
file(GLOB dirs
        *
)
message("lesson dirs:${dirs}")

# 添加所有测试用例
foreach (dir_PATH IN LISTS dirs)
    message("dir_PATH:${dir_PATH}")
    get_filename_component(dir_NAME ${dir_PATH} NAME)
    message("dir_NAME:${dir_NAME}")
    if (IS_DIRECTORY ${dir_PATH} AND (${dir_NAME} MATCHES "^lesson"))
        message("lesson dir_NAME:${dir_NAME}")
        set(CURRENT_TEST_NAME ${dir_NAME})
        add_subdirectory(${dir_PATH})
    endif ()
endforeach ()