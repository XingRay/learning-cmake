测试
执行命令:

构建
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
.\build\output\Release\demo.exe
```
