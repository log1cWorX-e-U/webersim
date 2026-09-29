cmake_minimum_required(VERSION 3.10)
project(simulator LANGUAGES C)

set(SOURCES
    src/main.c
    src/resources.c
    src/configuration.c
)

set(LIBRARIES
    sm
    threading
    string
    physics
    m
)

set(INCLUDES
    ${CMAKE_CURRENT_LIST_DIR}/sm
    ${CMAKE_CURRENT_LIST_DIR}/threading
    ${CMAKE_CURRENT_LIST_DIR}/physics
)

add_subdirectory(sm ${CMAKE_BINARY_DIR}/libs_build/sm)
add_subdirectory(threading ${CMAKE_BINARY_DIR}/libs_build/threading)
add_subdirectory(string ${CMAKE_BINARY_DIR}/libs_build/string)
add_subdirectory(physics ${CMAKE_BINARY_DIR}/libs_build/physics)
add_subdirectory(logging ${CMAKE_BINARY_DIR}/libs_build/logging)
add_subdirectory(vector ${CMAKE_BINARY_DIR}/libs_build/vector)
add_executable(simulator ${SOURCES})

target_link_libraries(simulator ${LIBRARIES})
target_include_directories(simulator PRIVATE ${INCLUDES})

target_compile_definitions(simulator PRIVATE
    $<$<CONFIG:Debug>:DEBUG>
)
