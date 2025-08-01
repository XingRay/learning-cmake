cmake_minimum_required(VERSION 3.31.6)
project(lesson04_list)

message("+--------------------+")
message("|                    |")
message("|     list api       |")
message("|                    |")
message("+--------------------+")

# 获取list长度
set(SRC_LIST "main.cpp" "sub.cpp")
list(LENGTH SRC_LIST SRC_LIST_LEN)
message("LENGTH SRC_LIST:${SRC_LIST}  len:${SRC_LIST_LEN}")

# 获取 list 中指定 index(可以有多个) 的元素(可以是对应的多个元素)
set(SRC_LIST "main.cpp" "sub.cpp" "mul.cpp" "div.cpp")
list(GET SRC_LIST 1 3 SELECTED_SRC_LIST)
# SELECTED_SRC_LIST:add.cpp;mul.cpp
message("GET SELECTED_SRC_LIST:${SELECTED_SRC_LIST}")
# 索引支持负数, -1 表示倒数第1个 -3表示倒数第3个 , index不能超过 [-size, size-1]范围
list(GET SRC_LIST -1 -3 SELECTED_SRC_LIST)
# SELECTED_SRC_LIST2:div.cpp;sub.cpp
message("GET SELECTED_SRC_LIST2:${SELECTED_SRC_LIST}")


# join , 将多个字符串通过连接符相连, 如 [a b c] 通过连接符 '-'连接得到 "a-b-c"
set(var1 "aa" "bb" "cc")
list(JOIN var1 "#" JOIN_STR)
# JOIN_STR:aa#bb#cc
message("JOIN JOIN_STR:${JOIN_STR}")

# find 查找 找到了输出下标到 output_var , 否则输出 -1 到 output_var
set(word_list "abc" "zxc" "qwe" "hello" "world")
list(FIND word_list "qwe" FOUND_INDEX)
# FOUND_INDEX: 2
message("FIND FOUND_INDEX: ${FOUND_INDEX}")
list(FIND word_list "asd" FOUND_INDEX)
# FOUND_INDEX: -1
message("FIND FOUND_INDEX: ${FOUND_INDEX}")


# append 在尾部追加
set(word_list "aaa" "bbb")
list(APPEND word_list "ccc" "ddd")
# word_list:aaa;bbb;ccc;ddd
message("APPEND word_list:${word_list}")


# insert 在指定index处插入, 插入的元素从index处开始放置, 列表中被插入的部分后移
set(word_list "aa" "bb" "cc" "dd" "ee")
list(INSERT word_list 2 "xx" "yy")
# word_list:aa;bb;xx;yy;cc;dd;ee
message("INSERT word_list:${word_list}")

# prepend 在队列头部插入
set(word_list "aa" "bb" "cc" "dd" "ee")
list(PREPEND word_list "xx" "yy")
# word_list:xx;yy;aa;bb;cc;dd;ee
message("PREPEND word_list:${word_list}")

# pop_back 取出最后的元素
set(word_list "aa" "bb" "cc" "dd" "ee")
list(POP_BACK word_list POP_ITEM)
# POP_BACK POP_ITEM:ee, word_list:aa;bb;cc;dd
message("POP_BACK POP_ITEM:${POP_ITEM}, word_list:${word_list}")


# POP_FRONT 取出头部元素
set(word_list "aa" "bb" "cc" "dd" "ee")
list(POP_FRONT word_list POP_ITEM)
# POP_FRONT POP_ITEM:aa, word_list:bb;cc;dd;ee
message("POP_FRONT POP_ITEM:${POP_ITEM}, word_list:${word_list}")


# REMOVE_ITEM  删除指定元素, 根据值进行删除
set(word_list "aa" "bb" "cc" "dd" "ee")
list(REMOVE_ITEM word_list "cc" "ee")
# REMOVE_ITEM word_list:aa;bb;dd
message("REMOVE_ITEM word_list:${word_list}")


# REMOVE_ITEM  删除指定元素, 根据下标进行删除
set(word_list "aa" "bb" "cc" "dd" "ee")
list(REMOVE_AT word_list 1 3)
# REMOVE_AT word_list:aa;cc;ee
message("REMOVE_AT word_list:${word_list}")

# REMOVE_DUPLICATES 删除重复元素
set(word_list "aa" "bb" "aa" "cc" "aa" "bb")
list(REMOVE_DUPLICATES word_list)
# REMOVE_DUPLICATES word_list:aa;bb;cc
message("REMOVE_DUPLICATES word_list:${word_list}")


# REVERSE 翻转列表
set(word_list "aa" "bb" "cc" "dd" "ee")
list(REVERSE word_list)
# REVERSE word_list:ee;dd;cc;bb;aa
message("REVERSE word_list:${word_list}")

# 排序
set(word_list "ee" "aa" "bb" "dd" "cc")
list(SORT word_list)
# SORT word_list:aa;bb;cc;dd;ee
message("SORT word_list:${word_list}")
# sort 有3个参数
# COMPARE: 排序方式
#     STRING 字符串顺序[默认]
#     FILE_BASENAME: 按文件基本名（不含路径和扩展名）排序
#     NATURAL: 识别字符串中的数字序列，再按数字的字符串排序
# CASE: SENSITIVE 区分大小写  INSENSITIVE: 不区分大小写
# ORDER: 排序顺序 ASCENDING: 升序  DESCENDING:降序
list(SORT word_list
        COMPARE NATURAL
        CASE INSENSITIVE
        ORDER DESCENDING)

set(file_list "file10.txt" "file2.txt" "File1.txt" "src/file3.cpp")
# 逐字符比较 ASCII 值，不考虑数字的数值大小。
list(SORT file_list COMPARE STRING CASE SENSITIVE)
message("STRING SORT: ${file_list}")

set(file_list "src/main.cpp" "include/Header.h" "tests/test1.cpp" "lib/file10.lib")
# 比较的是 file10、Header、main、test1
list(SORT file_list COMPARE FILE_BASENAME CASE INSENSITIVE)
message("FILE_BASENAME SORT: ${file_list}")

set(file_list "src/file3.cpp" "aa/file10.txt" "src/file1.cpp" "aa/file4.txt" "src/file9.cpp" "file5.txt")
# 字符串部分安装字典顺序排序, 有数字的部分, 数字要转化为数值进行排序, 而不是字符串, 所以 5<10 , 升序: file5.txt;file10.txt
list(SORT file_list COMPARE NATURAL)
# NATURAL SORT: file4.txt;file5.txt;file10.txt;src/file1.cpp;src/file3.cpp;src/file9.cpp
message("NATURAL SORT: ${file_list}")


add_executable(${PROJECT_NAME}
        main.cpp
)
