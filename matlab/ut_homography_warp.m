% homography warp between two images, This is an example

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

output_image = homography_warp(h12, image1, size(image1));
figure; imshow(output_image); title('warped image');

blend_image = uint8(0.5 * output_image + 0.5 * image2);
figure; imshow(blend_image); title('blend image');
