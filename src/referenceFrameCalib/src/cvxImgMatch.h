//
//  cvxImgMatch.h
//  RGBD_RF
//
//  Created by jimmy on 2016-09-06.
//  Copyright (c) 2016 Nowhere Planet. All rights reserved.
//

#ifndef __RGBD_RF__cvxImgMatch__
#define __RGBD_RF__cvxImgMatch__

// matching two images in pixel level

#include <stdio.h>
#include <vector>
#include <opencv2/core/core.hpp>
#include <opencv2/core/core_c.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgproc/imgproc_c.h>
#include "eigenVLFeatSIFT.h"

using std::vector;


namespace cvx {
    struct SIFTMatchingParameter
    {
        // @todo add parameter here
        
    };
    // @todo document
    void SIFTMatching(const cv::Mat & srcImg, const cv::Mat & dstImg,
                      const SIFTMatchingParameter & param,
                      vector<cv::Point2d> & srcPts, vector<cv::Point2d> & dstPts);
    // @todo document
    void SIFTMatching(const vector<std::shared_ptr<sift_keypoint> >& srcKeypoints,
                             const vector<std::shared_ptr<sift_keypoint> >& dstKeypoints,
                             const SIFTMatchingParameter & param,
                             vector<cv::Point2d> & srcPts, vector<cv::Point2d> & dstPts);
    
} // namespace



#endif /* defined(__RGBD_RF__cvxImgMatch__) */
