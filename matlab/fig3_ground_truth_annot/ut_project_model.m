% visualize annotation
clear
close all

addpath ('/home/ritazhu/sports/two-point result');
% load('/home/ritazhu/sports/CalibMe-master/matlab/soccer_field_model.mat');
load('bra_ned_anno_pred.mat');
camera = estimated_cameras(8,:);

load('/home/ritazhu/sports/CalibMe-master/matlab/worldcup_2014_model.mat');
model_points = points;
model_line_segment = line_segment_index + 1;

im = imread('/home/ritazhu/sports/two-point result/66.jpg');

project_model(camera, model_points, model_line_segment, im)
saveas(gcf,'tmp66.jpg')


