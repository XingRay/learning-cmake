# ======================================================
#  MyLibrary CMake 配置文件
# ======================================================

# ======================================================
#  头文件搜索
# ======================================================
# 获取没有 ../.. 相对路径标记的绝对路径
get_filename_component(ML_CONFIG_PATH "${CMAKE_CURRENT_LIST_DIR}" REALPATH)
get_filename_component(ML_INSTALL_PATH "${ML_CONFIG_PATH}/../../../" REALPATH)

# 搜索，添加至全局变量 MyLibrary_INCLUDE_DIRS
set(ML_INCLUDE_COMPONENTS "${ML_INSTALL_PATH}/include/MyLibrary")
set(MyLibrary_INCLUDE_DIRS "")
foreach(d ${ML_INCLUDE_COMPONENTS})
    get_filename_component(_d "${d}" REALPATH)
    if(NOT EXISTS "${_d}")
        message(WARNING "MyLibrary: Include directory doesn't exist: '${d}'. MyLibrary installation may be broken. Skip...")
    else()
        list(APPEND MyLibrary_INCLUDE_DIRS "${_d}")
    endif()
endforeach()
unset(_d)

# ======================================================
# 库文件搜索
# ======================================================
# 包含导出配置的 *.cmake 文件
include(${CMAKE_CURRENT_LIST_DIR}/MyModules.cmake)

# 添加至全局变量 MyLibrary_LIBS
set(ML_LIB_COMPONENTS my_target;my_target_2)
foreach(_mlcomponent ${ML_LIB_COMPONENTS})
    set(MyLibrary_LIBS ${MyLibrary_LIBS} "${_mlcomponent}")
endforeach()

# ======================================================
# 搜寻的结果、状态
# ======================================================
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
        MyLibrary
        REQUIRED_VARS ML_INSTALL_PATH
)