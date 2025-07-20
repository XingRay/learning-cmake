#[[

aux_source_directory(src core2_dir)
add_library(
        core2
        SHARED ${core2_dir}
)
target_include_directories(
        core2
        PUBLIC include
)
target_link_libraries(
        core2
        PUBLIC core1
)

]]

add_module(
        core2
        DEP_LIBS core1
)