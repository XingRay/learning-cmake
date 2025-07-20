cmake_minimum_required(VERSION 3.31.6)
project(demo) # 可以简化


add_executable(demo
        main.cpp
)

# 安装文件
install(FILES main.cpp calc.app
        DESTINATION "install/src"

        # 打包相关
        COMPONENT dev

)

install(FILES readme.md LICENSE
        DESTINATION "install/src"

        # 打包相关
        COMPONENT doc

        # 文件不存在不会报错, 也不会影响安装流程
        OPTIONAL
)

# 安装目录
install(DIRECTORY build/output
        DESTINATION "install/lib"
        COMPONENT "lib"
        ${compatible_MESSAGE_NEVER}
)

# 安装目标
install(TARGETS demo
        # 静态库
        ARCHIVE DESTINATION lib
        # 动态库
        LIBRARY DESTINATION lib
        # 可执行文件 / windows dll文件
        RUNTIME DESTINATION lib
)


# 导出安装
install(TARGETS demo
        # 静态库
        ARCHIVE DESTINATION lib
        # 动态库
        LIBRARY DESTINATION lib
        # 可执行文件 / windows dll文件
        RUNTIME DESTINATION lib

        # 定义导出目标
        EXPORT MyModule
)

install(TARGETS demo2
        # 静态库
        ARCHIVE DESTINATION lib
        # 动态库
        LIBRARY DESTINATION lib
        # 可执行文件 / windows dll文件
        RUNTIME DESTINATION lib

        # 这样在一个导出目标 MyModule 中导出2个target
        EXPORT MyModule
)

# 导出目标是个虚拟的概念, 还需要真正的导出成文件才能被其他的用户使用
install(EXPORT MyModule
        FILE MyModule.cmake
        # 通常会安装到这里
        DESTINATION "lib/cmake/${PROJECT_NAME}"
)