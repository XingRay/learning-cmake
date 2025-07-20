#[[
主要任务

提供一个 CMake 目标变量（一般是导入目标）
找到 SDK 的头文件
找到 SDK 的库文件
提供有无找到的状态信息

详细注释的示例代码

]]

# 设置 calc 的路径（可自行设置）
set(calc_sdk_root "${PROJECT_SOURCE_DIR}/libs/calc")

# 发现头文件路径，并设置 Calc_INCLUDE_DIRS
find_path(
        Calc_INCLUDE_DIR
        NAMES Add.h LibMacros.h Sub.h
        PATHS "${calc_sdk_root}/include"

        # 默认路径下会包含 /usr/local 等内容，这句话表明不包含默认路径
        NO_DEFAULT_PATH
)

# 发现库文件路径
find_library(
        Calc_LIB
        # 在windows中, 要链接的是导入库, 导入库会引入 dll 文件, 只要将 dll文件复制到与 exe在同一个目录中即可
        NAMES "calc.lib" # "calc.dll"
        PATHS "${calc_sdk_root}/lib"

        # 同 find_path
        NO_DEFAULT_PATH
)

# 设置导入目标，称为 calc
if (NOT TARGET calc)
    # 将目标设置为在项目中全局可见 GLOBAL
    add_library(calc STATIC IMPORTED GLOBAL)
    # 为导入目标添加相关属性
    set_target_properties(calc PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${Calc_INCLUDE_DIR}"
            IMPORTED_LOCATION "${Calc_LIB}"
    )
endif ()

set(Calc_INCLUDE_DIRS ${Calc_INCLUDE_DIR})
set(Calc_LIBS calc)


# 这里用到了一个 CMake 自带的函数，会根据指定内容设置 Calc_FOUND 变量
include(FindPackageHandleStandardArgs)
# 如果 Calc_FOUND 将被设置为 FALSE，并在使用 find_package(Calc REQUIRED) 时也会报错

find_package_handle_standard_args(
        Calc
        # Calc_LIBS 和 Calc_INCLUDE_DIRS 为必须参数, 如果其中任意为空, 则 Calc_FOUND 设置为 False
        REQUIRED_VARS Calc_LIBS Calc_INCLUDE_DIRS
)
message("Calc_FOUND:${Calc_FOUND}")