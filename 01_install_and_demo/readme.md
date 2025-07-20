1 下载 CMake
https://cmake.org/download/

用户手册
https://cmake.org/cmake/help/latest/index.html


2 安装cmake
下载安装cmake到自定义目录. 并添加到系统 path
验证:

```shell
cmake --version
```

输出

```
cmake version 4.0.3

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

3 基本测试
https://cmake.org/cmake/help/latest/manual/cmake.1.html

执行命令:

构建

```shell
cmake -S . -B ./build
```

-S 指定要编译的项目的CMakeLists.txt文件所在的目录
-B 生成的项目文件保存的目录, 这种方式可以代替

```shell
mkdir build && cd build
```

默认添加 -G 参数, 如在windows:

```shell
cmake -S . -B ./build -G "Visual Studio 17 2022"
```

编译

```shell
cmake --build ./build --config Release
```

--build :表示进入编译阶段, 参数为要编译的项目的路径,通常是上一步构建的输出路径
--config:构建类型选择, 一般为Release或者Debug

执行

```shell
.\build\Release\demo.exe
```
