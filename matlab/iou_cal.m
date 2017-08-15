% compute iou between ground truth image and predicted image
function iou = iou_cal(gt_camera,predicted_camera,image_size)
% gt_camera,predicted_camera: u, v, fl, rx, ry, rz, cx, xy, cz
% image_size: destination image size. [h, w, 3]

[~, warped_model_gt] = model_to_image_warp (gt_camera,image_size);
[~, warped_model_pred] = model_to_image_warp(predicted_camera,image_size);

% compute IoU from warped_model_gt and warped_model_pred
A = (warped_model_gt == 0) & (warped_model_pred) == 0;
B = (warped_model_gt == 0) | (warped_model_pred) == 0;
tmp = sum(A(:));
whole = sum(B(:));

iou = tmp/whole;
            
