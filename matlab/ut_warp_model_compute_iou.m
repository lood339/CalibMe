% test IoU calclation
clear all
close all

addpath('/Users/jimmy/Source/CalibMe/data');
load('seq1_anno_pred.mat');

i = 1;
predicted_camera = estimated_cameras(i,:);
gt_camera = annotation(i).camera;

model_h = 70;
model_w = 118;
[iou]  = warp_model_compute_iou(gt_camera, predicted_camera, model_h, model_w);


