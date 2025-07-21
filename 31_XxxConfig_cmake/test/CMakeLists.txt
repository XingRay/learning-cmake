cmake_minimum_required(VERSION 3.31.6)
project(demo)
set(CMAKE_CXX_STANDARD 23)

set(Calc_DIR ${PROJECT_SOURCE_DIR}/../build/dist/calc/lib/cmake)
message("Calc_DIR:${Calc_DIR}")
find_package(Calc)

message("CALC_INSTALL_PATH:${CALC_INSTALL_PATH}")
message("Calc_INCLUDE_DIRS:${Calc_INCLUDE_DIRS}")
message("Calc_LIBS:${Calc_LIBS}")
message("Calc_FOUND:${Calc_FOUND}")


add_executable(${PROJECT_NAME}
        main.cpp
)

message("Calc_LIBS:${Calc_LIBS}")
target_link_libraries(${PROJECT_NAME}
        ${Calc_LIBS}
)