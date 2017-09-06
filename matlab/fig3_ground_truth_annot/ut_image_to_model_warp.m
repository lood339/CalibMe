clear
close all;

addpath ('/home/ritazhu/sports/two-point result');

load('seq1_anno_pred.mat');
camera = estimated_cameras(5,:);

image = imread('/home/ritazhu/sports/two-point result/0520.jpg');

load('/home/ritazhu/sports/CalibMe-master/matlab/wwos_soccer_field_model.mat');
model_points = points;
model_line_segment = line_segment_index + 1;

[h, warped_im] = image_to_model_warp(camera, image,model_points, model_line_segment);

saveas(gcf, 'temp.jpg');
