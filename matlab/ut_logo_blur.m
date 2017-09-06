clear
close all;

addpath('/home/ritazhu/sports/two-point result');
load seq1_anno_pred.mat

x1 = meta.logo_bbox(1);
y1 = meta.logo_bbox(2);
width = meta.logo_bbox(3);
height = meta.logo_bbox(4);
for i = 16:57
    
    im = imread(strcat('/home/ritazhu/sports/main-calib/all/bra_mex/',num2str(i),'.jpg'));
    R = im(:,:,1);
    G = im(:,:,2);
    B = im(:,:,3);

    c = [x1,x1+width,x1+width,x1];
    r = [y1,y1,y1+height,y1+height];

    filtered_img(:,:,1) = channel_blur(R,c,r);
    filtered_img(:,:,2) = channel_blur(G,c,r);
    filtered_img(:,:,3) = channel_blur(B,c,r);
    filename = strcat(num2str(i),'.jpg');
    
    imwrite(filtered_img,strcat(num2str(i),'.jpg'));
end



% imshow(I);
% imshow(BW);
% figure;
% imshow(filtered_img);
% hold on
% [frames1,descrs1] = getFeatures(filtered_img,'peakThreshold',0.001);
% plot(frames1(1,:),frames1(2,:),'r*');
% gaussian_filtered_logo = imgaussfilt(mean_filtered_logo,8);
% imshow(gaussian_filtered_logo);



