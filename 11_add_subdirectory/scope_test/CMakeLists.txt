cmake_minimum_required(VERSION 3.31.6)
project(scope_test)

# 父级创建的变量在子模块中会复制一份
message("${PROJECT_NAME}: scope_test01:${scope_test01}")
# 这里修改的是子模块(也就是这个模块)中的变量, 与父级模块无关
set(scope_test01 "scope_test01 modified in ${PROJECT_NAME}")
message("${PROJECT_NAME}: scope_test01:${scope_test01}")

# 同样这里输出的是本模块中复制了父模块的变量
message("${PROJECT_NAME}: scope_test02:${scope_test02}")
# 加了 PARENT_SCOPE , 那么修改的就不是本模块中的变量, 而是父模块中的变量
set(scope_test02 "scope_test02 modified in ${PROJECT_NAME}" PARENT_SCOPE)
# 本模块中的这个变量没有被修改
message("${PROJECT_NAME}: scope_test02:${scope_test02}")

# 在本模块中定义的了变量
set(scope_test03 "scope_test03 set in child")
# 正常输出内容,与父模块无关, 所以在父模块中无法访问,输出为空
message("${PROJECT_NAME}: scope_test03:${scope_test03}")

# 在父模块中定义了一个变量
set(scope_test04 "scope_test04 set in child" PARENT_SCOPE)
# 没有在本模块中定义, 所以这里是输出为空,在父模块中可以正常输出值
message("${PROJECT_NAME}: scope_test04:${scope_test04}")