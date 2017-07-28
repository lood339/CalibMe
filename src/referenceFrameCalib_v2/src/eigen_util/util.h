//
//  util.h
//  calib
//
//  Created by jimmy on 2017-07-27.
//  Copyright (c) 2017 Nowhere Planet. All rights reserved.
//

#ifndef __calib__util__
#define __calib__util__

#include <stdio.h>
#include <string>
#include <vector>
#include "perspective_camera.h"

using std::string;
using std::vector;
using cvx::perspective_camera;

bool writeCamera(const char *fileName, const char *imageName, const perspective_camera & camera);

bool readCamera(const char *fileName, string & imageName, perspective_camera & camera);

// folder: /Users/chenjLOCAL/Desktop/*.txt
void readFilenames(const char *folder, vector<string> & files);

// pure rotation camera calibration
// assume camera1 and camera2 has similar pose
// x2 = K_2 * R_2 * R_1^{-1} * K_1^{-1} x1
bool calibratePureRotateCamera(const vector<Eigen::Vector2d > & pts1,
                               const vector<Eigen::Vector2d > & pts2,
                               const cvx::perspective_camera & camera1,
                               cvx::perspective_camera & camera2);


#endif /* defined(__calib__util__) */
