//
//  vul_plus.cpp
//  calib
//
//  Created by jimmy on 2017-07-23.
//  Copyright (c) 2017 Nowhere Planet. All rights reserved.
//

#include "vul_plus.h"
#include <dirent.h>
#include <string.h>

namespace vul_plus {
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
    
    void splitFilename (const string& str, string &path, string &file)
    {
        assert(!str.empty());
        unsigned int found = (unsigned int )str.find_last_of("/\\");
        path = str.substr(0, found);
        file = str.substr(found + 1);
    }


    
}; // namespace