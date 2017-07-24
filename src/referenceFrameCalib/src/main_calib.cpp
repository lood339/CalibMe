//
//  main_keyframeCalib.cpp
//  VideoCalibVXL
//
//  Created by jimmy on 7/23/17.
//  Copyright (c) 2017 Nowhere Planet. All rights reserved.
//

#if 1

#include <stdlib.h>
#include <vcl_vector.h>
#include <vcl_string.h>
#include <vcl_iostream.h>

#include <vcl_list.h>
#include <vpgl/vpgl_perspective_camera.h>
#include <vcl_algorithm.h>
#include <vcl_numeric.h>
#include "vul_plus.h"
#include "cvxImage_310.hpp"
#include "eigenVLFeatSIFT.h"
#include "vpgl_plus.h"
#include "eigenFlann.h"
#include "cvxImgMatch.h"

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

int main(int argc, const char * argv[])
{
    
    if (argc != 3)
    {
        help();
        printf("parameter number is %d, should be 2.\n", argc);
        return -1;
    }
     
    // get parameters
    const char *keyframeFolder = argv[1];
    const char *imageFolder = argv[2];
    
    /*
     //debug
    const char *keyframeFolder = "./reference_frames/*.txt";
    const char *imageFolder = "./images/*.jpg";
     */
    
    
    vector<string> keyframeNames;
    vul_plus::readFilenames(keyframeFolder, keyframeNames);
    
    // find most similar keyframe
    vector<cv::Mat> keyFrames;
    vector<vpgl_perspective_camera<double> > keyframeCameras;
    for (int i = 0; i<keyframeNames.size(); i++) {
        string imagename;
        vpgl_perspective_camera<double> camera;
        VpglPlus::readCamera(keyframeNames[i].c_str(), imagename, camera);
        keyframeCameras.push_back(camera);
        cv::Mat image = cv::imread(imagename.c_str());
        assert(!image.empty());
        keyFrames.push_back(image);
    }
    printf("load %lu key frames\n", keyFrames.size());
    
    vector<string> test_image_names;
    vul_plus::readFilenames(imageFolder, test_image_names);
    printf("test image number %lu\n", test_image_names.size());
    
    
    // SIFT feature for keyframes
    vl_feat_sift_parameter sift_para;
    sift_para.edge_thresh = 20;
    sift_para.peak_thresh = 1.0;
    sift_para.magnif      = 3.0;
    sift_para.dim = 128;
    
    vector< vector< std::shared_ptr<sift_keypoint> > > keyframeFeaturesVec(keyFrames.size());
    for (int i = 0; i<keyFrames.size(); i++) {
        EigenVLFeatSIFT::extractSIFTKeypoint(keyFrames[i], sift_para, keyframeFeaturesVec[i]);
    }
    
    
    for (int i = 0; i<test_image_names.size(); i += 1) {
        string cur_image_name = test_image_names[i].c_str();
        cv::Mat queryImage = cv::imread(cur_image_name.c_str());
        assert(!queryImage.empty());
        vector< std::shared_ptr<sift_keypoint> > queryImageFeatures;
        EigenVLFeatSIFT::extractSIFTKeypoint(queryImage, sift_para, queryImageFeatures);
        
        // loop all keyframes;
        int max_inlier = 0;
        vpgl_perspective_camera<double> finalCamera;
        for (int j = 0; j<keyframeFeaturesVec.size(); j++) {
            vector<std::shared_ptr<sift_keypoint> > src_keypoints = keyframeFeaturesVec[j];
            vector<std::shared_ptr<sift_keypoint> > dst_keypoints = queryImageFeatures;
            
            vector<cv::Point2d> src_pts;
            vector<cv::Point2d> dst_pts;
            SIFTMatchingParameter matching_param;
            CvxImgMatch::SIFTMatching(src_keypoints, dst_keypoints, matching_param, src_pts, dst_pts);
            
            
            Mat mask;
            Mat H = cv::findHomography(src_pts, dst_pts, mask, CV_RANSAC, 3.0);
            assert(mask.rows == src_pts.size());
            
            
            vector<vgl_point_2d<double> > inlier_src_pts;
            vector<vgl_point_2d<double> > inlier_dst_pts;
            int n_inlier = 0;
            for (int k = 0; k<src_pts.size(); k++) {
                if ((int)(mask.at<uchar>(k, 0)) == 1) {
                    inlier_src_pts.push_back(vgl_point_2d<double>(src_pts[k].x, src_pts[k].y));
                    inlier_dst_pts.push_back(vgl_point_2d<double>(dst_pts[k].x, dst_pts[k].y));
                    n_inlier++;
                }
            }
            printf("inlier number %d\n", n_inlier);
            if (n_inlier > max_inlier && n_inlier >= 4) {
                vpgl_perspective_camera<double> curCamera;
                bool isCalib = VpglPlus::calibrate_pure_rotate_camera(inlier_src_pts, inlier_dst_pts, keyframeCameras[j], curCamera);
                if (isCalib) {
                    max_inlier = n_inlier;
                    finalCamera = curCamera;
                }
            }
        }
        if (max_inlier >= 4) {
            char save_name[1024] = {NULL};
            sprintf(save_name, "./result/%08d.txt", i);
            VpglPlus::writeCamera(save_name, cur_image_name.c_str(), finalCamera);
        }
    }
    
    return 0;
}

#endif
