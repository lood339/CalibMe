//
//  vul_plus.h
//  calib
//
//  Created by jimmy on 2017-07-23.
//  Copyright (c) 2017 Nowhere Planet. All rights reserved.
//

#ifndef __calib__vul_plus__
#define __calib__vul_plus__

#include <stdio.h>
#include <vector>
#include <string>
#include <assert.h>

using std::string;
using std::vector;

namespace vul_plus {
    // folder: /Users/chenjLOCAL/Desktop/*.txt
    void readFilenames(const char *folder, vector<string> & files);
    
    
    void splitFilename (const string& str, string &path, string &file);

    
};

#endif /* defined(__calib__vul_plus__) */
