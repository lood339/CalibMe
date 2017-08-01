% compute the iou between two images, This is an example

clear
close all

addpath('./test_image');

load('camera_14400.mat');
camera1 = camera;
image1 = imread('00014400.jpg');

load('camera_3600.mat');
camera2 = camera;
image2 = imread('00003600.jpg');


h1 = camera_to_homography(camera1);
h2 = camera_to_homography(camera2);

h12 = h2 * inv(h1);  % homography from image 1 to image 2


iou = IoU_from_homography(h12, size(image1), size(image1));
