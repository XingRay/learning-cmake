# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)

# 单行注释

#[[
这是多行注释
这是多行注释
这是多行注释
]]

# 创建项目
#project(
#        demo                                # 设置项目名
#        LANGUAGES CXX                       # 可选 指定语言，未指定的语言将不参与构建，例如 test.c 文件
#        VERSION 1.0.0.0                     # 可选 版本号 major.minor.patch.tweak
#        DESCRIPTION "this is a demo"        # 可选 描述信息
#        HOMEPAGE_URL "http://www.xxx.com"   # 可选 项目网站
#)

# 可以简写
project(demo) # 可以简化

# 创建可执行文件, 也就是创建一个类型为 exe 的 target
add_executable(
        demo     # 目标名 target

        main.cpp # 用到的源文件, 可以用空格分隔或者多行
)