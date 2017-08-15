% unit test for "model_to_image_warp.m"
clear
close all;

addpath('./test_image');

load('camera_14400.mat');
image = imread('00014400.jpg');

[h, warped_template] = model_to_image_warp(camera, size(image));

figure;
subplot(2,1, 1); imshow(image);
subplot(2, 1, 2); imshow(warped_template);