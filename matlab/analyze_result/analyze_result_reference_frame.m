% analyze result

addpath('/Users/jimmy/Source/CalibMe/matlab/');
load('soccer1_seq1_syn_camera_frames.mat');
data = syn_camera_frames;
N = numel(data);

cc = [113.41, 2.22, 6.03];
base_rotation = [1.278234, 1.118293, -1.103959];

ious = zeros(N, 1);
for i = [1:N]
    pred_camera = data(i).pred_camera;
    gt_camera = data(i).gt_camera;
    
    [h, pred_mask] = model_to_image_warp(pred_camera, [720, 1280, 3]);
    [h, gt_mask] = model_to_image_warp(gt_camera, [720, 1280, 3]);
    %figure(1); clf;
    %subplot(1, 2, 1); imshow(pred_mask);
    %subplot(1, 2, 2); imshow(gt_mask);
    %pause(1);
    pred_mask = pred_mask(:,:,1);
    gt_mask = gt_mask(:,:,1);
    val_intersection = pred_mask ~=0 & gt_mask ~= 0;
    val_union = pred_mask ~=0 | gt_mask ~= 0;
    iou = 1.0*sum(val_intersection(:))/sum(val_union(:)); 
    ious(i) = iou;
end

