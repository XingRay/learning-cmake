cmake_minimum_required(VERSION 3.31.6)
project(demo)
set(CMAKE_CXX_STANDARD 23)

set(Calc_DIR ${PROJECT_SOURCE_DIR}/../build/dist/calc/lib/cmake)
message("Calc_DIR:${Calc_DIR}")
find_package(Calc)

message("Calc_INSTALL_PATH:${Calc_INSTALL_PATH}")
message("Calc_INCLUDE_DIRS:${Calc_INCLUDE_DIRS}")
message("Calc_LIBS:${Calc_LIBS}")
message("Calc_FOUND:${Calc_FOUND}")
message("Calc_BUILD_TYPE:${Calc_BUILD_TYPE}")

add_executable(${PROJECT_NAME}
        main.cpp
)

message("Calc_LIBS:${Calc_LIBS}")
target_link_libraries(${PROJECT_NAME}
        ${Calc_LIBS}
)

if (WIN32 AND Calc_BUILD_TYPE STREQUAL "SHARED")
    add_custom_command(TARGET demo POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy
            "${Calc_INSTALL_PATH}/bin/$<CONFIG>/calc.dll"
            "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>"
    )
endif ()