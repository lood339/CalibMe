cmake_minimum_required (VERSION 2.6)

cmake_policy(SET CMP0015 NEW)

project (cvx_core)

if(UNIX)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=gnu++11")
endif()



# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h ???
include_directories("${PROJECT_BINARY_DIR}")


set (USE_SERVER 0)

# link Eigen
if(USE_SERVER)
set(Eigen_DIR /lci/project/raid1/jimmy_chen/lib/eigen_3.2.6/include/eigen3)
else()
set(Eigen_DIR /Users/jimmy/Code/eigen_3.2.6)
endif()
include_directories (${Eigen_DIR})


# add head source files directory
include_directories (./cvx_gl ./cvx_pgl)

set(SRC_GL ./cvx_gl/gl_homg_point_2d.cpp ./cvx_gl/gl_homg_point_3d.cpp ./cvx_gl/gl_ray_3d.cpp)
set(SRC_PGL ./cvx_pgl/pgl_calibration_matrix.cpp ./cvx_pgl/pgl_perspective_camera.cpp 
            ./cvx_pgl/pgl_proj_camera.cpp ./cvx_pgl/pgl_ptz_camera.cpp ./cvx_pgl/pgl_ptz_boundle_adjustment.cpp)

add_library(cvx_core SHARED ${SRC_PG} ${SRC_PGL})

















