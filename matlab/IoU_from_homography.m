%IoU from a homography
function iou = IoU_from_homography(h, sz1, sz2)
% h: 3 x 3 homography matrix, from image 1 to image2
% sz1: [width, height] of image 1
% sz2: [width, height] of image 2
% iou: intersection over union of the warp

warped_image = homography_warp(h, ones(sz1(1),sz1(2),3,'uint8'));
s1 = length(find(warped_image(:,:,1) ~= 0));
iou = s1 / (sz2(1) * sz2(2));

end