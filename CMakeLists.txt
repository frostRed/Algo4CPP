#cmake_minimum_required(VERSION <specify CMake version here>)
project(testflight_curses)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES In.cpp StdOut.cpp StdIn.cpp)

add_executable(main ${SOURCE_FILES})

add_executable(BinarySearch BinarySearch.cpp)

add_executable(BinarySearch_test BinarySearch_test.cpp ${SOURCE_FILES})
