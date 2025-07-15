

3 基本测试
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
