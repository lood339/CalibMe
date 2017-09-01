function [iou] = warp_model_compute_iou(gt_camera, predicted_camera, ...
                            model_h, model_w)
% gt_camera,predicted_camera: u, v, fl, rx, ry, rz, cx, xy, cz
% model_h, model_w: model size. highlights 70 x 118, World Cup 74 x 115
% compute iou by warp model
assert(length(gt_camera) == 9);
assert(length(predicted_camera) == 9);

gt_h = model_to_image_homography(gt_camera, model_h, model_w);
est_h = model_to_image_homography(predicted_camera, model_h, model_w);

%gt_h = gt_h/max(abs(gt_h(:)));
%est_h = est_h/max(abs(est_h(:)));

% homography composition
h = inv(est_h) * gt_h;

model_h = model_h * 12;
model_w = model_w * 12;
template = uint8(ones(model_h, model_w, 3))*255;
bbox = uint8(zeros(model_h*3, model_w*3, 3))*255;
bbox([model_h:model_h*2-1], [model_w:model_w*2-1],:) = template;

% warp the template
warped_box = homography_warp(h, bbox, size(bbox), [0, 0, 0]);

pred_mask = warped_box(:,:,1);
gt_mask = bbox(:,:,1);
val_intersection = pred_mask ~=0 & gt_mask ~= 0;
val_union = pred_mask ~=0 | gt_mask ~= 0;
iou = 1.0*sum(val_intersection(:))/sum(val_union(:)); 

%iou = 1.0;
%vis_model = 2;
%figure; imshow(bbox);
%figure; imshow(warped_box);



end