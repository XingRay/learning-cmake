cmake_minimum_required(VERSION 3.31.6)
project(lesson06_loop)

message("+--------------------+")
message("|                    |")
message("|       loop         |")
message("|                    |")
message("+--------------------+")

# foreach
set(word_list "aa" "bb" "cc")
message("=====1")
foreach (word ${word_list})
    # word:aa
    # word:bb
    # word:cc
    message("word:${word}")
endforeach ()

message("=====2")
# 注意不能写成 "${word_list}", 这样写会先将变量先展开成字符串 "aa;bb;cc",再遍历
foreach (word "${word_list}")
    # word:aa;bb;cc
    message("word:${word}")
endforeach ()

message("=====3")
# 还可以写成 IN LISTS list_name ,注意不能写成 ${list_name} 的形式
foreach (word IN LISTS word_list)
    message("word:${word}")
endforeach ()


#[0, stop]
message("=====4")
foreach (index RANGE 3)
    # 0 1 2 3
    message("index:${index}")
endforeach ()

message("=====5")
foreach (index RANGE 3 10 2)
    # 3 5 7 9
    message("index:${index}")
endforeach ()

message("=====6")
set(word_list1 "aa" "bb" "cc")
set(word_list2 "xx" "yy" "zz")
foreach (word ${word_list1} ${word_list2} "oo" "pp" "qq")
    message("word:${word}")
endforeach ()

message("=====7")
foreach (word IN ITEMS ${word_list1} ${word_list2})
    message("word:${word}")
endforeach ()

message("=====8")
foreach (word IN LISTS ${word_list1} ${word_list2})
    message("word:${word}")
endforeach ()

message("=====9")
# 同时遍历多个list
set(long_list "aa" "bb" "cc" "dd" "ee")
set(short_list "xx" "yy" "zz")
foreach (longItem shortItem IN ZIP_LISTS long_list short_list)
    # 循环次数由最长的list决定, 短的list在超出自身长度的循环中取值为空

    #longItem:aa, shortItem:xx
    #longItem:bb, shortItem:yy
    #longItem:cc, shortItem:zz
    #longItem:dd, shortItem:
    #longItem:ee, shortItem:
    message("longItem:${longItem}, shortItem:${shortItem}")
endforeach ()

message("=====10")
# 只设置一个循环变量时, 通过 "循环变量名_n" ,如 item_0 item_1 item_2 方式取值
foreach (item IN ZIP_LISTS long_list short_list)
    message("item_0:${item_0}, item_1:${item_1}")
endforeach ()


# while 循环
message("=====11")
set(word_list "aa" "bb" "cc")
list(LENGTH word_list list_len)
while (${list_len} GREATER 0)
    # 从列表中取出头部元素
    list(POP_FRONT word_list word)
    message("word:${word}")
    # 更新 len
    list(LENGTH word_list list_len)
endwhile ()

add_executable(${PROJECT_NAME}
        main.cpp
)
