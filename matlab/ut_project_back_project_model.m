% test project and back-project model
clear all
close all

addpath('/Users/jimmy/Source/CalibMe/data');
load('seq1_anno_pred.mat');

i = 5;
predicted_camera = estimated_cameras(i,:);
gt_camera = annotation(i).camera;

load('wwos_soccer_field_model.mat');
model_points = points;
model_line_segment = line_segment_index + 1;


project_back_project_model(gt_camera, predicted_camera, model_size, model_points, model_line_segment);
              
