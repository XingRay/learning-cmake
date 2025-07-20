cmake_minimum_required(VERSION 3.31.6)
project(demo)

message("+--------------------+")
message("|                    |")
message("|   execute process  |")
message("|                    |")
message("+--------------------+")

#execute_process(COMMAND <cmd1> [<arguments>]
#        [COMMAND <cmd2> [<arguments>]]...
#        [WORKING_DIRECTORY <directory>]
#        [TIMEOUT <seconds>]
#        [RESULT_VARIABLE <variable>]
#        [RESULTS_VARIABLE <variable>]
#        [OUTPUT_VARIABLE <variable>]
#        [ERROR_VARIABLE <variable>]
#        [INPUT_FILE <file>]
#        [OUTPUT_FILE <file>]
#        [ERROR_FILE <file>]
#        [OUTPUT_QUIET]
#        [ERROR_QUIET]
#        [COMMAND_ECHO <where>]
#        [OUTPUT_STRIP_TRAILING_WHITESPACE]
#        [ERROR_STRIP_TRAILING_WHITESPACE]
#        [ENCODING <name>]
#        [ECHO_OUTPUT_VARIABLE]
#        [ECHO_ERROR_VARIABLE]
#        [COMMAND_ERROR_IS_FATAL <ANY|LAST>])

# 执行 ls ./
execute_process(COMMAND "ls" ${PROJECT_SOURCE_DIR} OUTPUT_VARIABLE ls_dir_output)
message("ls_dir_output:${ls_dir_output}")

add_executable(demo
        main.cpp
)
