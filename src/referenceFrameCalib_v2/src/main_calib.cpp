//
//  main_keyframeCalib.cpp
//  VideoCalibVXL
//
//  Created by jimmy on 7/23/17.
//  Copyright (c) 2017 Nowhere Planet. All rights reserved.
//

#if 1

#include <stdlib.h>
#include "cvxImage_310.hpp"
#include "eigenVLFeatSIFT.h"
#include "eigenFlann.h"
#include "cvxImgMatch.h"
#include "perspective_camera.h"
#include <Eigen/Geometry>
#include "rotation_3d.h"
#include "util.h"

static void help()
{
    printf("usage:   ./program             refFrames images \n");
    printf("example: ./referenceFrameCalib /*.txt    /*.jpg      \n");
    printf("refFrames: reference frame location and ground truth camera\n");
    printf("images: \n");
    printf("Using vlfeat sift with fixed parameter\n");
    printf("keyframeFolder: ./abc/*.txt\n");
    printf("save to ./result/*.txt folder\n");
    printf("Assumption: reference frames and images are from the same PTZ camera\n");
}

using Eigen::Vector2d;
using Eigen::Vector3d;
using Eigen::Matrix3d;
using Eigen::AngleAxisd;


int main(int argc, const char * argv[])
{
   
    /*
    if (argc != 3)
    {
        help();
        printf("parameter number is %d, should be 2.\n", argc);
        return -1;
    }
     
    // get parameters
    const char *referenceFrameFolder = argv[1];
    const char *testImageFolder = argv[2];
     */
    
    
     //debug
    const char *referenceFrameFolder = "./reference_frames/*.txt";
    const char *testImageFolder = "./images/*.jpg";
    
    
    // Step 1: load reference frames and testing images
    vector<string> refFrameNames;
    readFilenames(referenceFrameFolder, refFrameNames);
    
    // find most similar keyframe
    vector<cv::Mat> refFrames;
    vector<cvx::perspective_camera> refCameras;
    for (int i = 0; i<refFrameNames.size(); i++) {
        string imagename;
        //vpgl_perspective_camera<double> camera;
        cvx::perspective_camera camera;
        readCamera(refFrameNames[i].c_str(), imagename, camera);
       refCameras.push_back(camera);
        cv::Mat image = cv::imread(imagename.c_str());
        assert(!image.empty());
        refFrames.push_back(image);
    }
    
    printf("load %lu key frames\n", refFrames.size());
    
    vector<string> test_image_names;
    readFilenames(testImageFolder, test_image_names);
    printf("test image number %lu\n", test_image_names.size());
    
    
    // Step 2: detect SIFT feature from reference frames
    // SIFT feature for keyframes
    vl_feat_sift_parameter sift_para;
    sift_para.edge_thresh = 20;
    sift_para.peak_thresh = 1.0;
    sift_para.magnif      = 3.0;
    sift_para.dim = 128;
    
    vector< vector< std::shared_ptr<sift_keypoint> > > refFrameFeaturesVec(refFrames.size());
    for (int i = 0; i<refFrames.size(); i++) {
        EigenVLFeatSIFT::extractSIFTKeypoint(refFrames[i], sift_para, refFrameFeaturesVec[i]);
    }
    
    // Step 3: calibrate testing images
    for (int i = 0; i<test_image_names.size(); i += 1) {
        // Step 3.1: detect sift feature in the testing image
        string cur_image_name = test_image_names[i].c_str();
        cv::Mat queryImage = cv::imread(cur_image_name.c_str());
        assert(!queryImage.empty());
        vector< std::shared_ptr<sift_keypoint> > queryImageFeatures;
        EigenVLFeatSIFT::extractSIFTKeypoint(queryImage, sift_para, queryImageFeatures);
        
        // loop all reference frames, choose one with the largest matching numbers
        int max_inlier = 0;
        cvx::perspective_camera finalCamera;
        for (int j = 0; j<refFrameFeaturesVec.size(); j++) {
            vector<std::shared_ptr<sift_keypoint> > src_keypoints = refFrameFeaturesVec[j];
            vector<std::shared_ptr<sift_keypoint> > dst_keypoints = queryImageFeatures;
            
            // SIFT matching and ransac filter
            vector<cv::Point2d> src_pts;
            vector<cv::Point2d> dst_pts;
            cvx::SIFTMatchingParameter matching_param;
            cvx::SIFTMatching(src_keypoints, dst_keypoints, matching_param, src_pts, dst_pts);
            
            Mat mask;
            Mat H = cv::findHomography(src_pts, dst_pts, mask, CV_RANSAC, 3.0);
            assert(mask.rows == src_pts.size());
            
            
            vector<Vector2d > inlier_src_pts;
            vector<Vector2d > inlier_dst_pts;
            int n_inlier = 0;
            for (int k = 0; k<src_pts.size(); k++) {
                if ((int)(mask.at<uchar>(k, 0)) == 1) {
                    inlier_src_pts.push_back(Vector2d(src_pts[k].x, src_pts[k].y));
                    inlier_dst_pts.push_back(Vector2d(dst_pts[k].x, dst_pts[k].y));
                    n_inlier++;
                }
            }
            
            printf("inlier number %d\n", n_inlier);
            if (n_inlier > max_inlier && n_inlier >= 4) {
                // assume the cameras has the same location (only rotate)
                cvx::perspective_camera curCamera;
                bool isCalib = calibratePureRotateCamera(inlier_src_pts, inlier_dst_pts, refCameras[j], curCamera);
                if (isCalib) {
                    max_inlier = n_inlier;
                    finalCamera = curCamera;
                }
            }
             
        }
        if (max_inlier >= 4) {
            char save_name[1024] = {NULL};
            sprintf(save_name, "./result/%08d.txt", i);
            writeCamera(save_name, cur_image_name.c_str(), finalCamera);
        }
    }
    
    
    return 0;
}

#endif
