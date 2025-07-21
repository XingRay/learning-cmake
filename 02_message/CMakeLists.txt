cmake_minimum_required(VERSION 3.31.6)
project(demo)


# 输出日志
#输出: hello
message( "hello")
#输出: world
message( world)

# 日志级别
# 通知(默认)消息,用于输出信息。
message("important message")
message(NOTICE "notice message")
# 状态消息 有 -- ，看起来更重要
message(STATUS "normal message")

# 调试信息
message(VERBOSE "verbose message")
message(DEBUG "debug message")
message(TRACE "trace message")

# 警告信息， 程序会继续执行
# 一般警告, 表示使用者需要注意
message(WARNING "warning message")
# 用于开发时的警告，用 -Wno-dev 忽略
message(AUTHOR_WARNING "author warning message")
# 表示该功能弃用的警告
message(DEPRECATION "deprecation warning message")

# 错误,跳过生成步骤,继续执行后面程序
#message(SEND_ERROR "send error message")
# 错误,构建终止
#message(FATAL_ERROR "fatal error message")

add_executable(demo
        main.cpp
)