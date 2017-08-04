% generate testing data(sift features)
clc
clear

run vl_setup.m

addpath('.\utils')

%load annotation
load('annotation_1.mat');

%Set data root
DataRoot='./seq2/';


bbx_feat_test=[];
other_feat_test=[];



for i=606:10:729
    
     disp([num2str(i)]);
     
    im=imread([DataRoot,annot(i).ImgName]);
    [frames1,descrs1] = getFeatures(im,'peakThreshold',0.01);
  
    for k = 1:size(frames1,2)
        feat_flag=1;
         % bbx features or other features
        for j = 1:size(annot(i).BBox,1)
            x1=annot(i).BBox(j,1);
            y1=annot(i).BBox(j,2);
            x2=annot(i).BBox(j,3);
            y2=annot(i).BBox(j,4);
            if(frames1(1,k) >= x1 && frames1(1,k) <= x2 && frames1(2,k) >= y1 && frames1(2,k) <= y2)
                bbx_feat_test(end+1,:) = [descrs1(:,k)' i frames1(1,k) frames1(2,k)];
                feat_flag=0;
                break;
            end
        end
        if feat_flag
            other_feat_test(end+1,:) = [descrs1(:,k)' i frames1(1,k) frames1(2,k)];
        end
    end
    
end         

save('SIFT_feat_test','bbx_feat_test','other_feat_test');