cmake_minimum_required(VERSION 3.31.6)
project(demo)


include(FetchContent)

FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG 703bd9caab50b139428cea1aaff9974ebee5742e # release-1.10.0
)

FetchContent_MakeAvailable(googletest)

add_executable(demo
        main.cpp
)