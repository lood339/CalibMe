#include "mex.h"
#include "pgl_ptz_boundle_adjustment.h"
#include "pgl_ptz_camera.h"
#include "mexcpp.h"

using namespace cvx_pgl;
using namespace Eigen;
//using namespace mexcpp;

enum {
  iCamera1,
  iCamera2,
  iLocation1,
  iLocation2,
  nI
};

enum {
  oPTZ1,
  oPTZ2, 
  nO
};

void mexFunction(int nOut, mxArray *pOut[],
        int nIn, const mxArray *pIn[])
{
    if (nIn != nI || nOut != nO) {
        mexPrintf("Error: nIn %d, nOut %d\n", nIn, nOut);
        return;
    }
    
    // read camera 1 and camera 2
    mexcpp::Mat<double> dCamera1(pIn[iCamera1]);
    mexPrintf("Double vector read; M = %d, N = %d\n", dCamera1.M, dCamera1.N);
    const mexcpp::Mat<double>::EigenMatrix camera1_data(dCamera1.asEigenMatrix());
    
    Vector2d pp(1280/2, 720/2);
    perspective_camera camera1;
    {        
        double fl = camera1_data(0, 0);        
        double rx = camera1_data(0, 1);
        double ry = camera1_data(0, 2);
        double rz = camera1_data(0, 3);
        double cx = camera1_data(0, 4);
        double cy = camera1_data(0, 5);
        double cz = camera1_data(0, 6);
        Eigen::Vector3d rod(rx, ry, rz);
        Eigen::Vector3d cc(cx, cy, cz);
    
        camera1.set_calibration(cvx_pgl::calibration_matrix(fl, pp));
        camera1.set_rotation(rod);
        camera1.set_camera_center(cc);
    }
    
    mexcpp::Mat<double> dCamera2(pIn[iCamera2]);
    mexPrintf("Double vector read; M = %d, N = %d\n", dCamera2.M, dCamera2.N);
    const mexcpp::Mat<double>::EigenMatrix camera2_data(dCamera2.asEigenMatrix());
    
    perspective_camera camera2;
    {        
        double fl = camera2_data(0, 0);        
        double rx = camera2_data(0, 1);
        double ry = camera2_data(0, 2);
        double rz = camera2_data(0, 3);
        double cx = camera2_data(0, 4);
        double cy = camera2_data(0, 5);
        double cz = camera2_data(0, 6);
        Eigen::Vector3d rod(rx, ry, rz);
        Eigen::Vector3d cc(cx, cy, cz);
    
        camera2.set_calibration(cvx_pgl::calibration_matrix(fl, pp));
        camera2.set_rotation(rod);
        camera2.set_camera_center(cc);
    }
    
    mexcpp::Mat<double> dLocation1(pIn[iLocation1]);
    mexPrintf("Double vector read; M = %d, N = %d\n", dLocation1.M, dLocation1.N);
    mexcpp::Mat<double>::EigenMatrix location1(dLocation1.asEigenMatrix());
    
    mexcpp::Mat<double> dLocation2(pIn[iLocation2]);
    mexPrintf("Double vector read; M = %d, N = %d\n", dLocation2.M, dLocation2.N);
    mexcpp::Mat<double>::EigenMatrix location2(dLocation2.asEigenMatrix());
  
    //std::stringstream ss;
   
    //ss << "mEigenMap contents: \n" << mEigenMap << "\n";
    //mexPrintf(ss.str().c_str());
    //ss.str("");
   
    
    Vector3d cc(113.41, 2.22, 6.03);
    Vector3d base_rot(1.278234, 1.118293, -1.103959);
    
    ptz_camera ptz1(pp, cc, base_rot);
    ptz_camera ptz2(pp, cc, base_rot);    
    ptz1.set_camera(camera1);
    ptz2.set_camera(camera2);    
      
    boundle_adjustment(ptz1, ptz2, location1, location2); 
    
    // make up some something for output
    mexcpp::Mat<double> output_ptz1(3, 1);
    mexcpp::Mat<double> output_ptz2(3, 1);
  
    pOut[oPTZ1] = output_ptz1;
    pOut[oPTZ2] = output_ptz2;
    mexPrintf("Double matrix output created.\n");    
    
    return;
}