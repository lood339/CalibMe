% visualize annotation
clear
close all

addpath ('/Users/jimmy/Source/CalibMe/data');

load('0539.mat');
load('soccer_field_model.mat');
model_points = points;
model_line_segment = line_segment_index + 1;

im = imread(image_name);

project_model(camera, model_points, model_line_segment, im)
saveas(gcf,'temp.jpg')


