cmake_minimum_required(VERSION 3.31.6)
project(test01)

file(GLOB_RECURSE SRC_LIST
        *.cpp
)

add_executable(${PROJECT_NAME}
        ${SRC_LIST}
)
target_link_libraries(${PROJECT_NAME}
        PRIVATE calc
)
target_link_directories(${PROJECT_NAME}
        PRIVATE ${OUTPUT_LIB_DIR}
)

target_include_directories(${PROJECT_NAME}
        PRIVATE ${OUTPUT_INCLUDE_DIR}
)

set_target_properties(${PROJECT_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_EXE_DIR}
)