% visualize annotation
clear
close all

addpath ('/Users/jimmy/Source/CalibMe/data');

load('0539.mat');
load('soccer_field_model.mat');
%load('/Users/jimmy/Desktop/BTDT_ptz_world_cup/analyze_result/54_camera.mat');
%camera = gt_camera;
%load('worldcup_2014_model.mat');
model_points = points;
model_line_segment = line_segment_index + 1;

%image_name = '/Users/jimmy/Desktop/images/UoT_soccer/images/test/bra_ned/54.jpg';
im = imread(image_name);

project_model(camera, model_points, model_line_segment, im)
%saveas(gcf,'temp.jpg')


