//
//  util.cpp
//  calib
//
//  Created by jimmy on 2017-07-27.
//  Copyright (c) 2017 Nowhere Planet. All rights reserved.
//

#include "util.h"
#include <iostream>

#include <dirent.h>
#include <string.h>

// Eigen
#include <Eigen/Geometry>
#include <unsupported/Eigen/NonLinearOptimization>
#include <unsupported/Eigen/NumericalDiff>

using std::cout;
using std::endl;

static Eigen::Vector3d rotation_to_rodrigues(const Eigen::Matrix3d &r)
{
    Eigen::AngleAxisd aa(r);
    
   // Eigen::Vector3d axis = aa.axis()*aa.angle();
    
    
    double ang = aa.angle();
    if (ang == 0.0) {
        return Eigen::Vector3d::Zero();
    }
    return aa.axis()*(ang);
}

bool writeCamera(const char *fileName, const char *imageName, const perspective_camera & camera)
{
    assert(fileName);
    assert(imageName);
    
    FILE *pf = fopen(fileName, "w");
    if (!pf) {
        printf("can not create file %s\n", fileName);
        return false;
    }
   
    fprintf(pf, "%s\n", imageName);
    fprintf(pf, "ppx\t ppy\t focal length\t Rx\t Ry\t Rz\t Cx\t Cy\t Cz\n");
    double ppx = camera.principal_point().x();
    double ppy = camera.principal_point().y();
    double fl = camera.get_calibration()(0, 0);
    Eigen::Matrix3d r = camera.get_rotation();
    Eigen::Vector3d rod = rotation_to_rodrigues(r);
    
    double Rx = rod.x();
    double Ry = rod.y();
    double Rz = rod.z();
    double Cx = camera.get_camera_center().x();
    double Cy = camera.get_camera_center().y();
    double Cz = camera.get_camera_center().z();
    fprintf(pf, "%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n", ppx, ppy, fl, Rx, Ry, Rz, Cx, Cy, Cz);
    fclose(pf);
    return true;
}

bool readCamera(const char *fileName, string & imageName, perspective_camera & camera)
{
    assert(fileName);
    FILE *pf = fopen(fileName, "r");
    if (!pf) {
        printf("can not open file %s\n", fileName);
        return false;
    }
    char buf[1024] = {NULL};
    int num = fscanf(pf, "%s\n", buf);
    assert(num == 1);
    imageName = string(buf);
    for (int i = 0; i<1; i++) {
        char lineBuf[BUFSIZ] = {NULL};
        fgets(lineBuf, sizeof(lineBuf), pf);
        cout<<lineBuf;
    }
    double ppx, ppy, fl, rx, ry, rz, cx, cy, cz;
    int ret = fscanf(pf, "%lf %lf %lf %lf %lf %lf %lf %lf %lf", &ppx, &ppy, &fl, &rx, &ry, &rz, &cx, &cy, &cz);
    if (ret != 9) {
        printf("Error: read camera parameters!\n");
        return false;
    }
    
    Eigen::Matrix3d K;
    K.setIdentity();
    K(0, 0) = fl;
    K(1, 1) = fl;
    K(0, 2) = ppx;
    K(1, 2) = ppy;
    
    Eigen::Vector3d rod(rx, ry, rz);
    Eigen::Vector3d cc(cx, cy, cz);
    
    camera.set_calibration(K);
    camera.set_rotation(rod);
    camera.set_camera_center(cc);
    fclose(pf);

    return true;
}

void readFilenames(const char *folder, vector<string> & file_names)
{
    const char *post_fix = strrchr(folder, '.');
    string pre_str(folder);
    pre_str = pre_str.substr(0, pre_str.rfind('/') + 1);
    //printf("pre_str is %s\n", pre_str.c_str());
    
    assert(post_fix);
    // vcl_vector<vcl_string> file_names;
    DIR *dir = NULL;
    struct dirent *ent = NULL;
    if ((dir = opendir (pre_str.c_str())) != NULL) {
        /* print all the files and directories within directory */
        while ((ent = readdir (dir)) != NULL) {
            const char *cur_post_fix = strrchr( ent->d_name, '.');
            if (!cur_post_fix ) {
                continue;
            }
            //printf("cur post_fix is %s %s\n", post_fix, cur_post_fix);
            
            if (!strcmp(post_fix, cur_post_fix)) {
                file_names.push_back(pre_str + string(ent->d_name));
                //  cout<<file_names.back()<<endl;
            }
            
            //printf ("%s\n", ent->d_name);
        }
        closedir (dir);
    }
    printf("read %lu files\n", file_names.size());
}

namespace {
    struct PureRotateFunctor
    {
        typedef double Scalar;
        
        typedef Eigen::VectorXd InputType;
        typedef Eigen::VectorXd ValueType;
        typedef Eigen::Matrix<Scalar,Eigen::Dynamic,Eigen::Dynamic> JacobianType;
        
        enum {
            InputsAtCompileTime = Eigen::Dynamic,
            ValuesAtCompileTime = Eigen::Dynamic
        };
        
        vector<Eigen::Vector2d > pts1_;
        vector<Eigen::Vector2d > pts2_;
        Eigen::Matrix3d invR1_;
        Eigen::Matrix3d invK1_;
        Eigen::Vector2d pp_;   // principle point
        
        int m_inputs;
        int m_values;
        
        PureRotateFunctor()
        {
            m_inputs = 5;
            m_values = 10;
        }
        
        void setValue(const vector<Eigen::Vector2d >& pts1,
                      const vector<Eigen::Vector2d >& pts2,
                      const Eigen::Matrix3d& invR1,
                      const Eigen::Matrix3d& invK1,
                      const Eigen::Vector2d& pp)
        {
            pts1_ = pts1;
            pts2_ = pts2;
            invR1_ = invR1;
            invK1_ = invK1;
            pp_ = pp;
            m_inputs = 5;
            m_values = 2*(int)pts1.size();
        }
        
        
        int operator()(const Eigen::VectorXd &x, Eigen::VectorXd &fx) const
        {
            double fl = x[0];
            double qx = x[1];
            double qy = x[2];
            double qz = x[3];
            double qw = x[4];
            
            Eigen::Quaternion<double> q(qw, qx, qy, qz);
            Eigen::Matrix3d R2 = q.normalized().toRotationMatrix();
            
            Eigen::Matrix3d K2;
            K2.fill(0);
            K2(0, 0) = K2(1, 1) = fl;
            K2(0, 2) = pp_.x();
            K2(1, 2) = pp_.y();
            K2(2, 2) = 1.0;
            
            // x2 = K_2 * R_2 * R_1^{-1} * K_1^{-1} x1
            int idx = 0;
            for (int i = 0; i<pts1_.size(); i++) {
                Eigen::Vector3d p(pts1_[i].x(), pts1_[i].y(), 1.0);
                Eigen::Vector3d q = K2 * R2 * invR1_ * invK1_ * p;
                double x = q[0]/q[2];
                double y = q[1]/q[2];
                
                fx[idx] = pts2_[i].x() - x;
                idx++;
                fx[idx] = pts2_[i].y() - y;
                idx++;
            }
            
            return 0;
        }
        
        int inputs() const { return m_inputs; }// inputs is the dimension of x.
        int values() const { return m_values; } // "values" is the number of f_i and
        
        void setCameraMatrixRotation(const Eigen::VectorXd& x,
                                     cvx::perspective_camera& camera)
        {
            double fl = x[0];
            double qx = x[1];
            double qy = x[2];
            double qz = x[3];
            double qw = x[4];
            
            Eigen::Quaternion<double> q(qw, qx, qy, qz);
            Eigen::Matrix3d R2 = q.normalized().toRotationMatrix();
            camera.set_rotation(R2);
            
            camera.set_calibration(fl, pp_.x(), pp_.y());
        }
    };
}



bool calibratePureRotateCamera(const vector<Eigen::Vector2d > & pts1,
                               const vector<Eigen::Vector2d > & pts2,
                               const cvx::perspective_camera & camera1,
                               cvx::perspective_camera & camera2)
{
    assert(pts1.size() == pts2.size());
    assert(pts1.size() >= 4);
    
   // vnl_matrix_fixed<double, 3, 3> invR1 = vnl_inverse(camera1.get_rotation().as_matrix());
   // vnl_matrix_fixed<double, 3, 3> invK1 = vnl_inverse(camera1.get_calibration().get_matrix());
   // vgl_point_2d<double> pp = camera1.get_calibration().principal_point();
    Eigen::Matrix3d invR1 = camera1.get_rotation().inverse();
    Eigen::Matrix3d invK1 = camera1.get_calibration().inverse();
    Eigen::Vector2d pp = camera1.principal_point();
    
    Eigen::Quaternion<double> q(camera1.get_rotation());
    
    Eigen::VectorXd x(5);
    x[0] = camera1.focal_length();
    x[1] = q.x();
    x[2] = q.y();
    x[3] = q.z();
    x[4] = q.w();
    
    PureRotateFunctor myFunctor;
    myFunctor.setValue(pts1, pts2, invR1, invK1, pp);
    Eigen::NumericalDiff<PureRotateFunctor> numericalDiffMyFunctor(myFunctor);
    Eigen::LevenbergMarquardt<Eigen::NumericalDiff<PureRotateFunctor>, double> levenbergMarquardt(numericalDiffMyFunctor);
    
    levenbergMarquardt.parameters.ftol = 1e-6;
    levenbergMarquardt.parameters.xtol = 1e-6;
    levenbergMarquardt.parameters.maxfev = 100; // Max iterations
    
    Eigen::VectorXd xmin = x; // initialize
    levenbergMarquardt.minimize(xmin);
    
    myFunctor.setCameraMatrixRotation(xmin, camera2);
    camera2.set_camera_center(camera1.get_camera_center());
    
   // std::cout << "x that minimizes the function: " << xmin << std::endl;
    
   // x[1] = camera1.get_rotation().as_rodrigues()[0];
   // x[2] = camera1.get_rotation().as_rodrigues()[1];
   // x[3] = camera1.get_rotation().as_rodrigues()[2];
    
    /*
    
    calibrate_pure_rotate_camera_residual residual(pts1, pts2, invR1, invK1, pp);
    
    
    
    vnl_levenberg_marquardt lmq(residual);
    lmq.set_f_tolerance(0.0001);
    
    bool isMinized = lmq.minimize(x);
    if (!isMinized) {
        vcl_cerr<<"Error: minimization failed.\n";
        lmq.diagnose_outcome();
        return false;
    }
    lmq.diagnose_outcome();
    
    residual.setCameraMatrixRotation(x, camera2);
    camera2.set_camera_center(camera1.get_camera_center());
    return true;
     */

    return true;
}