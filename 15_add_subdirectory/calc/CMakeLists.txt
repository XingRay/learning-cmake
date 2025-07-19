cmake_minimum_required(VERSION 3.31.6)
project(calc)

file(GLOB_RECURSE SRC_LIST
        *.cpp
)

add_library(${PROJECT_NAME} STATIC
        ${SRC_LIST}
)

target_include_directories(${PROJECT_NAME}
        PUBLIC ${OUTPUT_INCLUDE_DIR}
)

set_target_properties(${PROJECT_NAME} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_LIB_DIR}
)