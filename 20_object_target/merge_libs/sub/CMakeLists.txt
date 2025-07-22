# 创建对象库, 不会被编译为库文件
add_library(sub OBJECT
        Sub.cpp
)

# 链接接口库
target_link_libraries(sub
        PUBLIC calc_interface
)