#include "mex.h"
#include "ptz_pose_estimation.h"
#include "mexcpp.h"

using namespace Eigen;

enum {
  iPoint,
  iPanTilt,
  iThreshold,
  nI
};

enum {
  oPTZ,   
  nO
};

void mexFunction(int nOut, mxArray *pOut[],
        int nIn, const mxArray *pIn[])
{
    if (nIn != nI || nOut != nO) {
        mexPrintf("Error: nIn %d, nOut %d\n", nIn, nOut);
        return;
    }
    
    // default principal point
    Vector2d principal_point(1280/2, 720/2);
    
    // read point matrix
    mexcpp::Mat<double> dPoint(pIn[iPoint]);
    //mexPrintf("Double matrix read; M = %d, N = %d\n", dPoint.M, dPoint.N);
    const mexcpp::Mat<double>::EigenMatrix point_data(dPoint.asEigenMatrix());
    assert(point_data.cols() == 2);
    
    // rean pan-tilt matrix
    mexcpp::Mat<double> dPanTilt(pIn[iPanTilt]);
    //mexPrintf("Double matrix read; M = %d, N = %d\n", dPanTilt.M, dPanTilt.N);
    const mexcpp::Mat<double>::EigenMatrix pan_tilt_data(dPanTilt.asEigenMatrix());
    assert(pan_tilt_data.cols() == 2);
    assert(point_data.rows() == pan_tilt_data.rows());
    
    double threshold = mexcpp::scalar<double>(pIn[iThreshold]);
    
    // change data format
    vector<Eigen::Vector2d> image_points;
    vector<vector<Eigen::Vector2d> > candidate_pan_tilt;
    Eigen::Vector3d estimated_ptz(0, 0, 0);
    
    for(int i = 0; i<point_data.rows(); i++) {
        vector<Eigen::Vector2d> pan_tilt_group;
        Eigen::Vector2d p = point_data.row(i);
        Eigen::Vector2d pan_tilt = pan_tilt_data.row(i);
        pan_tilt_group.push_back(pan_tilt);
        image_points.push_back(p);
        candidate_pan_tilt.push_back(pan_tilt_group);         
    }
    assert(image_points.size() == candidaten_pan_tilt.size());
    
    // fixed ransac parameter for simplicity
    ptz_pose_opt::PTZPreemptiveRANSACParameter param;
    param.reprojection_error_threshold_ = threshold;
    param.sample_number_ = 64;
    
    // estimate camera pose
    bool is_opt = ptz_pose_opt::preemptiveRANSACOneToMany(image_points, 
            candidate_pan_tilt, 
            principal_point,
            param,
            estimated_ptz, false);
    
    // make up some something for output
    mexcpp::Mat<double> output_ptz(3, 1);
    
    if(is_opt) {
        output_ptz(0, 0) = estimated_ptz[0];
        output_ptz(1, 0) = estimated_ptz[1];
        output_ptz(2, 0) = estimated_ptz[2];
    }
    else {
        mexPrintf("Warning: PTZ camera optimization failed.\n");        
    }
    pOut[oPTZ] = output_ptz;    
    //mexPrintf("Double matrix output created.\n");        
    return;
}