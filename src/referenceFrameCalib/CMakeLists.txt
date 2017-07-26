cmake_minimum_required (VERSION 2.6)

cmake_policy(SET CMP0015 NEW)

project (ReferenceFrameCalib)

if(UNIX)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=gnu++11")
endif()

# The version number
set (ReferenceFrameCalib 1)
set (ReferenceFrameCalib 0)



# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h ???
include_directories("${PROJECT_BINARY_DIR}")


set (USE_SERVER 0)

# link OpenCV
set(OpenCV_DIR /Users/jimmy/Code/opencv-3.1.0)
include_directories ( ${OpenCV_DIR}/include )
link_directories ( ${OpenCV_DIR}/lib )
set(OPENCV_LIB opencv_core opencv_highgui opencv_imgproc opencv_imgcodecs opencv_calib3d)

# link Eigen
set(Eigen_DIR /Users/jimmy/Code/eigen_3.2.6)
include_directories (${Eigen_DIR})

# link Flann
set(FLANN_DIR /Users/jimmy/Code/flann-1.8.4-src)
include_directories ( ${FLANN_DIR}/src/cpp)
link_directories ( ${FLANN_DIR}/build/lib)

# link vlfeat
set(VL_FEAT_DIR /Users/jimmy/Code/vlfeat)
include_directories (${VL_FEAT_DIR})
link_directories (${VL_FEAT_DIR}/bin/maci64)

# link vxl
set(VXL_DIR /Users/jimmy/Code/vxl_core)
include_directories (${VXL_DIR}/build/vcl ${VXL_DIR}/build/core ${VXL_DIR}/vxl_core/vcl ${VXL_DIR}/vxl_core/core)
link_directories (${VXL_DIR}/build/lib)
set(VXL_LIB vpgl vnl vgl vcl vul vpgl_algo vsl vpgl_io vnl_io vgl_io vgl_algo vnl_algo v3p_netlib)

# add head source files directory
include_directories (./src ./src/opencv_util ./src/vxl_util)


# opencv util source code
set(SRC_OPENCV ./src/opencv_util/cvxImgMatch.cpp ./src/opencv_util/eigenFlann.cpp ./src/opencv_util/eigenVLFeatSIFT.cpp ./src/opencv_util/sift_64.c)

# vxl util code
set(SRC_VXL ./src/vxl_util/vul_plus ./src/vxl_util/vpgl_plus)


# add the executable
add_executable(ReferenceFrameCalib ./src/main_calib.cpp "${SRC_OPENCV}" "${SRC_VXL}")
target_link_libraries(ReferenceFrameCalib ${OPENCV_LIB} ${VXL_LIB} flann vl)















