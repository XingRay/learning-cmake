add_library(add OBJECT
        Add.cpp
)

message("Add: PROJECT_SOURCE_DIR:${PROJECT_SOURCE_DIR}")
target_include_directories(add
        PUBLIC ${PROJECT_SOURCE_DIR}/include
)
