
clear
close all;

addpath('./test_image');
addpath('/Users/jimmy/Source/CalibMe/data/');
load('camera_14400.mat');
image = imread('00014400.jpg');



load('wwos_soccer_field_model.mat');
model_points = points;
model_line_segment = line_segment_index + 1;

[h, warped_im] = image_to_model_warp(camera, image,model_points, model_line_segment);

%saveas(gcf, 'temp.jpg');
