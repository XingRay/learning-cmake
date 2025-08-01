构建

```shell
cmake -S . -B ./build -G "Visual Studio 17 2022" -DCMAKE_INSTALL_PREFIX=build/dist
```

编译

```shell
cmake --build ./build --config Debug
```

测试

```shell
.\build\Debug\demo.exe
```

安装

```shell
cmake --install ./build --config Debug
```

编译

```shell
cmake --build ./build --config Release
```

测试

```shell
.\build\Release\demo.exe
```

安装

```shell
cmake --install ./build --config Release
```
