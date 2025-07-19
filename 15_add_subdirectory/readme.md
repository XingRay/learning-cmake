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

测试

```shell
.\build\output\exe\Release\test01.exe
```

```shell
.\build\output\exe\Release\test02.exe
```