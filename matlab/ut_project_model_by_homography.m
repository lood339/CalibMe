clear
close all;

addpath('/Users/jimmy/Source/CalibMe/data');

load('1_homo.mat');
load('worldcup_2014_model.mat');

im = imread('/Users/jimmy/Desktop/images/UoT_soccer/train_val/1.jpg');

model_points = points * 1.0936;
model_line_segment = line_segment_index + 1;

overlaid_im = project_model_by_homography(homography, model_points, model_line_segment, im);


