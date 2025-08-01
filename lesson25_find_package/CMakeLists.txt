# 指定 CMake 的最小版本号，低于此版本的 CMake 将终止建构档的生成过程
cmake_minimum_required(VERSION 3.31.6)
project(demo)
set(CMAKE_CXX_STANDARD 23)

message("+--------------------+")
message("|                    |")
message("|    find_package    |")
message("|                    |")
message("+--------------------+")

set(OpenCV_DIR "D:/develop/opencv/4.11.0/sdk/windows/opencv/build/x64/vc16/lib")
find_package(OpenCV REQUIRED)
foreach (m ${OpenCV_LIBS})
    message(${m})
endforeach ()
#[[

opencv_calib3d
opencv_core
opencv_dnn
opencv_features2d
opencv_flann
opencv_gapi
opencv_highgui
opencv_imgcodecs
opencv_imgproc
opencv_ml
opencv_objdetect
opencv_photo
opencv_stitching
opencv_video
opencv_videoio
opencv_world

]]

#`find_package` 命令找到OpenCV并且完成配置的过程

#Module 模式
#这种模式下，`find_package` 需要解析 `Findxxx.cmake` 文件，这也是 `find_package` 默认工作的模式

#Config 模式
#这种模式下，`find_package` 需要解析 `xxxConfig.cmake` 文件或者 `xxx-config.cmake` 文件。实际上只有 `Findxxx.cmake` 文件无法找到，
#即 Module 模式执行不成功，才会进入 Config 模式。

# Module 模式下 `find_package` 的参数为：
#find_package(<package> [VERSION] [EXACT] [QUIET] [MODULE]
#             [REQUIRED] [[COMPONENTS] [components...]]
#             [OPTIONAL_COMPONENTS components...]
#             [NO_POLICY_SCOPE])

#[[

package    : 必填, 需要查找的包名, 注意区分大小写
VERSION    : 可选, 指定版本，如果指定就必须检查找到的 包的版本是否和`VERSION`兼容
EXACT      : 可选, 如果指定该参数，则表示需要寻找必须 完全匹配的版本而不是兼容版本 | 配合`VERSION`使用
REQUIRED   : 可选, 表示一定要找到包，找不到的话就立即 停掉整个 CMake 解析过程
QUIET      : 可选, 表示如果查找失败，不会在屏幕进行输出, 不得与`REQUIRED`搭配
MODULE     : 可选, 加入了 `MODULE`选项，那么就只在 Module 模式查找，如果查找失败不会切换到 Config 模式,直接停止搜索
COMPONENTS : 可选, 表示查找的包中必须要找到的组件 (components)，如果有任何一个找不到 就算失败，类似于`REQUIRED`，导致 CMake 停止执行。

]]

# 文件搜索过程
#[[
Module 模式下需要查找到名为 `Find<PackageName>.cmake` 的配置文件。该文件的查找过程只涉及到两个路径：`CMAKE_MODULE_PATH` 和 CMake 安装路径下的 Modules 目录。即: 搜索路径

依次为：
- 先在 `CMAKE_MODULE_PATH` 变量对应的路径中查找。如果路径为空，或者路径中查找失败，则在 CMake 安装目录（即 `CMAKE_ROOT` 变量）下的 Modules 目录中查找。
    这个目录通常为 `/usr/share/cmake-x.xx/Modules`。这两个变量可以在`CMakeLists.txt`文件中打印查看具体内容：
- 其中 `CMAKE_MODULE_PATH` 默认为空，可以利用 `set` 命令对该变量进行设置。
- 在安装 CMake 时，CMake 为我们提供了很多开发库的 `FindXXX.cmake` 模块文件，这些文件都定义在 `CMAKE_ROOT` 指代路径的文件夹里面。可以在终端通过键入以下命令进行查询
]]

# 没有设置, 读取为空
message("CMAKE_MODULE_PATH:${CMAKE_MODULE_PATH}")


# D:\develop\cmake\cmake-4.0.3-windows-x86_64\share\cmake-4.0
message("CMAKE_ROOT:${CMAKE_ROOT}")
execute_process(COMMAND ls
        # # D:\develop\cmake\cmake-4.0.3-windows-x86_64\share\cmake-4.0\Modules
        WORKING_DIRECTORY "${CMAKE_ROOT}/Modules"
        OUTPUT_VARIABLE ls_output
)
message("ls_output:${ls_output}")
#AddFileDependencies.cmake
#AndroidTestUtilities
#AndroidTestUtilities.cmake
#BasicConfigVersion-AnyNewerVersion.cmake.in
#BasicConfigVersion-ExactVersion.cmake.in
#BasicConfigVersion-SameMajorVersion.cmake.in
#BasicConfigVersion-SameMinorVersion.cmake.in
#BundleUtilities.cmake
#CMake.cmake
#CMakeASM-ATTInformation.cmake
#CMakeASMCompiler.cmake.in
#CMakeASMInformation.cmake
# ...


#[[

Config 模式
Config 模式下 `find_package` 的完整命令参数如下，不必全部了解。
相比于 Module 模式，Config 模式的参数更多，也更复杂，但实际在使用过程中我们并不会用到所有参数，大部分参数都是可选的，我们只需要掌握基本的参数用法即可。

其中具体查找库并给 `XXX_INCLUDE_DIRS` 和 `XXX_LIBS` 两个变量赋值的操作由 `XXXConfig.cmake` 模块完成。

两种模式看起来似乎差不多，不过 CMake 默认采取 Module 模式，如果 Module 模式未找到库，才会采取 Config 模式。总之，Config 模式是一个备选策略。
通常，库安装时会拷贝一份 `XXXConfig.cmake` 到系统目录中，因此在没有显式指定搜索路径时也可以顺利找到。

与 Module 模式不同，Config 模式需要查找的路径非常非常非常多，也要匹配很多的可能性，因此有些路径是首先作为根目录，然后进行子目录的匹配，而有些则是直接指定到具体的 `XXXConfig.cmake` 文件。具体将会按照如下顺序进行查找：
1. `<PackageName>_DIR`
2. 在不同的平台下搜索其中之一: `CMAKE_PREFIX_PATH`、`CMAKE_FRAMEWORK_PATH`、`CMAKE_APPBUNDLE_PATH`
3. `PATH`环境变量路径
4. `CMAKE_SYSTEM_PREFIX_PATH`等系统变量路径

**<PackageName>_DIR**

首先搜索名为`<PackageName>_DIR`的 CMake 变量或环境变量路径，这个变量默认为空。这个路径需要直接指定到`<PackageName>Config.cmake`或`<lower-case-package-name>-config.cmake`文件所在目录才能找到，可参考以下示例：
]]

#[[

<PackageName>_DIR
首先搜索名为<PackageName>_DIR的 CMake 变量或环境变量路径，这个变量默认为空。这个路径需要直接指定到<PackageName>Config.cmake或
<lower-case-package-name>-config.cmake文件所在目录才能找到，可参考以下示例：

CMAKE_PREFIX_PATH 等变量
如果按照<PackageName>_DIR搜索不到相应的XXXConfig.cmake文件的话，则会查找名为CMAKE_PREFIX_PATH、CMAKE_FRAMEWORK_PATH、
CMAKE_APPBUNDLE_PATH的 CMake 变量或环境变量路径。这些变量指定的路径将作为查找时的根目录，它们默认都为空。根目录的相关内容在后文会提及。

如果你电脑中安装了 ROS 并配置好之后，你在终端执行 echo $CMAKE_PREFIX_PATH 会发现 ROS 会将 CMAKE_PREFIX_PATH 这个变量设置为 ROS 中的库的路径，
意思是会首先查找 ROS 安装的库，如果恰好你在 ROS 中安装了 **OpenCV **库，就会发现首先找到的是 ROS 中的 OpenCV，而不是你自己安装到系统中的 OpenCV。


PATH 环境变量路径
若还找不到，则是搜索 PATH 环境变量路径，这个路径也是根目录，默认为系统环境 PATH 环境变量值。
其实这个路径才是 Config 模式大部分情况下能够查找到安装到系统中各种库的原因。这个路径的查找规则为：遍历 PATH 环境变量中的各路径，
如果该路径如果以 bin 或 sbin 结尾，则自动回退到上一级目录得到根目录。在终端键入以下内容以查看系统环境变量路径：


CMAKE_SYSTEM_PREFIX_PATH 等变量
我们在安装 OpenCV 的时候，可以在 cmake-gui 中修改 CMAKE_INSTALL_PREFIX 变量的内容，把 OpenCV 安装在 /opt/opencv 下，
我们在使用 find_package 时也不需要指名路径，说明除了上面的一些变量之外，还存在另外一系列路径。这里列出最重要的一个变量：CMAKE_SYSTEM_PREFIX_PATH


https://cmake.org/cmake/help/latest/command/find_package.html#search-procedure

]]

message("CMAKE_PREFIX_PATH:${CMAKE_PREFIX_PATH}")
message("CMAKE_FRAMEWORK_PATH:${CMAKE_FRAMEWORK_PATH}")
message("CMAKE_APPBUNDLE_PATH:${CMAKE_APPBUNDLE_PATH}")
message("path:$ENV{Path}")
message("========== env path")
foreach (path $ENV{Path})
    message("${path}")
endforeach ()

message("========== CMAKE_SYSTEM_PREFIX_PATH")
foreach (path ${CMAKE_SYSTEM_PREFIX_PATH})
    message("${path}")
endforeach ()


#[[

根目录路径详解
上述提及到的根目录路径，在指明这些内容时，CMake 会首先检查这些根目录路径下是否有名为 <PackageName>Config.cmake 或 <lower-case-package-name>-config.cmake 的模块文件，
如果没有，CMake 会继续检查或匹配这些根目录下的以下路径：

<prefix>/(lib/<arch>|lib|share)/cmake/<name>*/
<prefix>/(lib/<arch>|lib|share)/<name>*/
<prefix>/(lib/<arch>|lib|share)/<name>*/(cmake|CMake)/

其中为 arch 系统架构名，如 Ubuntu 下一般为：x86_64-linux-gnu，整个 (lib/<arch>|lib|share) 为可选路径，例如 OpenCV 库而言会检查或匹配以下内容：

<prefix>/lib/x86_64-linux-gnu/opencv4/
<prefix>/lib/cmake/opencv4/
<prefix>/share/opencv4/

注意: 上文提及过的 <PackageName>_DIR 路径不是根目录路径

]]

# 添加可执行文件并链接
set(SRC_LIST main.cpp)

add_executable(
        ${PROJECT_NAME}
        ${SRC_LIST}
)

target_link_libraries(
        ${PROJECT_NAME}
        PRIVATE calc
)




