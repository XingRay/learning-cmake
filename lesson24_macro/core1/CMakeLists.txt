find_package(OpenCV REQUIRED)

#[[
aux_source_directory(src core1_dir)
add_library(
        core1
        SHARED ${core1_dir}
)
target_include_directories(
        core1
        PUBLIC include
)
target_link_libraries(
        core1
        PUBLIC ${OpenCV_LIBS}
)
]]

add_module(
        core1
        DEP_LIBS ${OpenCV_LIBS}
)